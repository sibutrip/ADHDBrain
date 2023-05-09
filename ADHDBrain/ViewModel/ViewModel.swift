//
//  ViewModel.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/29/23.
//

import Foundation
import EventKit

enum GameState {
    case ingame, inmenu
}
@MainActor
class ViewModel: ObservableObject {
    let eventManager: EventService
    @Published var gameState: GameState = .ingame
    @Published var tasks: [TaskItem]
    var unsortedTasks: Int {
        tasks.filter {
            $0.sortStatus == .unsorted
        }.count
    }
    
    public func sortTask(for dropTask: DropTask?) {
        guard var task = dropTask?.task, let time = dropTask?.timeSelection else {
            return
        }
        task.sort(at: time)
        tasks = tasks.filter {
            $0.id != task.id
        }
        tasks.append(task)
        Task {
            await eventManager.scheduleEvent(for: task)
        }
    }
    
    init() {
        tasks = [
            .init(name: "grocery shopping"),
            .init(name: "do performance review")
        ]
        eventManager = EventService()
        
    }
}
