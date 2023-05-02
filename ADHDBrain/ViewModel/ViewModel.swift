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
    
    public func sortTask(for dropTask: DropTask?) {
        guard let dropTask = dropTask else {
            return
        }
        var task = dropTask.task
        let dropAction = dropTask.dropAction
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
        case .noneSelected:
            print("no drop")
            return
        case .skip1:
            return
        case .skip3:
            return
        case .skip7:
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
