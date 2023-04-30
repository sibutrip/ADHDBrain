//
//  ViewModel.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/29/23.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var tasks: [Task]
    var unsortedTasks: Int {
        tasks.filter {
            $0.sortStatus == .unsorted
        }.count
    }
    
    public func sortTask(for taskSwipe: TaskDrop?) {
        guard let taskSwipe = taskSwipe else {
            return
        }
        var task = taskSwipe.task
        let dropAction = taskSwipe.dropAction
        switch dropAction {
            
        case .morning:
            tasks.removeAll {
                task == $0
            }
            task.sortStatus = .sorted(.morning)
            tasks.append(task)
        case .afternoon:
            tasks.removeAll {
                task == $0
            }
            task.sortStatus = .sorted(.afternoon)
            tasks.append(task)
        case .evening:
            tasks.removeAll {
                task == $0
            }
            task.sortStatus = .sorted(.evening)
            tasks.append(task)
        case .noDrop:
            print("no drop")
            return
        }
    }
    
    init() {
        tasks = [
            .init(name: "clean bathroom"),
            .init(name: "do performance review")
        ]
    }
}
