//
//  Unsort.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 5/12/23.
//

import Foundation
import SwiftUI

struct Unsort: ViewModifier {
    @Binding var tasks: [TaskItem]
    let task: TaskItem
    
    init(_ tasks: Binding<[TaskItem]>, _ task: TaskItem) {
        _tasks = tasks
        self.task = task
    }
    
    func body(content: Content) -> some View {
        if task.sortStatus != .unsorted {
            content
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        var task = task
                        task.sortStatus = .unsorted
                        task.scheduledDate = nil
#warning("remove from calendar")
                        tasks = tasks.map { existingTask in
                            if task.id == existingTask.id {
                                return task
                            } else {
                                return existingTask
                            }
                        }
                    } label: {
                        Label("Unsort", systemImage: "arrow.uturn.backward")
                    }
                    .tint(.yellow)
                }
        } else {
            content
        }
    }
}
