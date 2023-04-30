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
    
    public func sortTask(for taskSwipe: TaskSwipe?) {
        guard let taskSwipe = taskSwipe else {
            return
        }
        var task = taskSwipe.task
        let swipeDirection = taskSwipe.swipeDiretion
        switch swipeDirection {
        case .right:
            tasks.removeAll {
                task == $0
            }
            task.sortStatus = .sorted(.notDetermined)
            tasks.append(task)
        case .left:
            tasks.removeAll {
                task == $0
            }
            task.sortStatus = .skipped
            tasks.append(task)
        case .notSwiped:
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
