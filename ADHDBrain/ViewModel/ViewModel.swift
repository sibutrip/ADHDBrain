//
//  ViewModel.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/29/23.
//

import Foundation
import EventKit

@MainActor
class ViewModel: ObservableObject {
    
    let eventService: EventService
    @Saving var tasks: [TaskItem] {
        didSet {
            objectWillChange.send()
        }
    }
    var unsortedTasks: Int {
        tasks
            .filter { $0.sortStatus == .unsorted }
            .count
    }
    
    public func sortTask(_ dropTask: DropTask?) async throws {
        guard var task = dropTask?.task, let time = dropTask?.timeSelection else {
            return
        }
        try await task.sort(at: time)
        var tasks = self.tasks
        tasks = tasks.filter {
            $0.id != task.id
        }
        tasks.append(task)
        self.tasks = tasks
        DirectoryService.writeModelToDisk(tasks)
    }
    
    public func unscheduleTask(_ task: TaskItem) {
        do {
            var task = task
            var tasks = self.tasks
            if let date = task.scheduledDate {
                try eventService.deleteEvent(for: date)
            }
            tasks = tasks.filter {
                $0.id != task.id
            }
            task.scheduledDate = nil
            task.sortStatus = .unsorted
            tasks.append(task)
            DirectoryService.writeModelToDisk(tasks)
            self.tasks = tasks
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func deleteTask(_ task: TaskItem) throws {
        var tasks = self.tasks
        if let date = task.scheduledDate {
            try eventService.deleteEvent(for: date)
        }
        tasks = tasks.filter {
            $0.id != task.id
        }
        DirectoryService.writeModelToDisk(tasks)
        self.tasks = tasks
    }
    
    private func initTasks() {
        let tasks: [TaskItem]? = try? DirectoryService.readModelFromDisk()
        if let tasks = tasks {
            _tasks.projectedValue = tasks
        } else {
            self.tasks = []
        }
    }
    
    init() {
        eventService = EventService.shared
        initTasks()
    }
}
