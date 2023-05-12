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
    @Published var tasks: [TaskItem]
    var unsortedTasks: Int {
        tasks
            .filter { $0.sortStatus == .unsorted }
            .count
    }
    
    public func sortTask(for dropTask: DropTask?) async throws {
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
    
    init() {
        eventService = EventService()
        let tasks: [TaskItem]? = try? DirectoryService.readModelFromDisk()
        if let tasks = tasks {
            self.tasks = tasks
        } else {
            self.tasks = []
        }
//        print("tasks are", self.tasks)
    }
}
