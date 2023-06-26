//
//  SortListDisclosure.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 5/31/23.
//

import Foundation
import SwiftUI

struct SortListDisclosure: View {
    @ObservedObject var vm: ViewModel
    let task: TaskItem
    @Binding var taskExpanded: TaskItem?
    var body: some View {
        DisclosureGroup(task.name, isExpanded: Binding<Bool>(
            get: {
                taskExpanded == task
            },
            set: { isExpanding in
                if isExpanding {
                    taskExpanded = task
                } else {
                    taskExpanded = nil
                }
            }) ) {
                HStack(alignment: .center) {
                    DisclosureRow(for: Time.skips, vm, task, $taskExpanded)
                    Spacer()
                    DisclosureRow(for: Time.days, vm, task, $taskExpanded)
                }
            }
    }
    
    init(_ vm: ViewModel, _ task: TaskItem, _ taskExpanded: Binding<TaskItem?>) {
        self.vm = vm
        self.task = task
        _taskExpanded = taskExpanded
    }
}
