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
        let dropAction = dropTask.timeSelection
        //        switch dropAction {
        //        case .morning:
        //            tasks.removeAll {
        //                task == $0
        //            }
        //            task.sortStatus = .sorted(.Morning)
        //            tasks.append(task)
        //        case .afternoon:
        //            tasks.removeAll {
        //                task == $0
        //            }
        //            task.sortStatus = .sorted(.Afternoon)
        //            tasks.append(task)
        //        case .evening:
        //            tasks.removeAll {
        //                task == $0
        //            }
        //            task.sortStatus = .sorted(.Evening)
        //            tasks.append(task)
        //        case .noneSelected:
        //            return
        //        case .skip1:
        //            return
        //        case .skip3:
        //            return
        //        case .skip7:
        //            return
    }
    
    init() {
        tasks = [
            .init(name: "grocery shopping"),
            .init(name: "do performance review")
        ]
    }
}
