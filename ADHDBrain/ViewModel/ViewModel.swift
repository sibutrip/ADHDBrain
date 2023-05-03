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
        guard var task = dropTask?.task, let time = dropTask?.timeSelection else {
            return
        }
        task.sort(at: time)
        tasks = tasks.filter {
            $0.id != task.id
        }
        tasks.append(task)
    }
    
    init() {
        tasks = [
            .init(name: "grocery shopping"),
            .init(name: "do performance review")
        ]
    }
}
