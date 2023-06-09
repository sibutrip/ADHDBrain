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
    
    @Published var sortFull = false
    
    @Saving var tasks: [TaskItem] {
        didSet {
//            self.tasks = self.tasks.sorted()
            objectWillChange.send()
        }
    }
    
    var unsortedTasks: [TaskItem] {
        tasks
            .filter { $0.sortStatus == .unsorted }
    }
    
    public func sortTask(_ task: TaskItem, at time: TimeSelection) async {
        do {
            var task = task
            try await task.sort(at: time)
            var tasks = self.tasks
            tasks = tasks.filter {
                $0.id != task.id
            }
            tasks.append(task)
            self.tasks = tasks
            DirectoryService.writeModelToDisk(tasks)
        } catch {
            sortFull = true
        }
    }
    
    public func unscheduleTask(_ task: TaskItem) {
        var task = task
        var tasks = self.tasks
        // TODO: dont throw this error
        if let date = task.scheduledDate {
            try? eventService.deleteEvent(for: date)
        }
        tasks = tasks.filter {
            $0.id != task.id
        }
        task.scheduledDate = nil
        task.sortStatus = .unsorted
        tasks.append(task)
        DirectoryService.writeModelToDisk(tasks)
        self.tasks = tasks
    }
    
    public func deleteTask(_ task: TaskItem) throws {
        var tasks = self.tasks
        if let date = task.scheduledDate {
            try? eventService.deleteEvent(for: date)
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
