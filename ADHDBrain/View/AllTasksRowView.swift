//
//  AllTasksRowView.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 5/11/23.
//

import Foundation
import SwiftUI

struct AllTasksRowView: View {
    let task: TaskItem
    @ObservedObject var vm: ViewModel
    
    var scheduleColor: Color {
        switch task.sortStatus {
            
        case .sorted(let status):
            switch status {
                
            case .morning, .afternoon, .evening:
                return Color.green
            default:
                return Color.black
            }
        case .skipped(let status):
            switch status {
                
            case .skip1,.skip3,.skip7:
                return Color.red
            default:
                return Color.black
            }
        case .unsorted:
            return Color.black
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(task.name)
            Text(task.scheduleDescription)
                .font(.caption)
                .foregroundColor(scheduleColor)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                var task = task
                task.sortStatus = .unsorted
                vm.tasks = vm.tasks.map { existingTask in
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
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button {
                vm.tasks = vm.tasks.filter {
                    $0.id != task.id
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
        
    }
    init(_ task: TaskItem, _ vm: ViewModel) {
        self.task = task
        self.vm = vm
    }
}
