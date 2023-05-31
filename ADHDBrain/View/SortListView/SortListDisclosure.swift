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
    @Binding var disclosureExpanded: Set<UUID>
    var body: some View {
        DisclosureGroup(task.name, isExpanded: Binding<Bool>(
            get: {
                disclosureExpanded.contains(task.id)
            },
            set: { isExpanding in
                disclosureExpanded.removeAll()
                if isExpanding {
                    disclosureExpanded.insert(task.id)
                }
            }) ) {
                HStack(alignment: .center) {
                    DisclosureRow(for: Time.skips, vm, task)
                    Spacer()
                    DisclosureRow(for: Time.days, vm, task)
                }
            }
    }
    
    init(_ vm: ViewModel, _ task: TaskItem, _ disclosureExpanded: Binding<Set<UUID>>) {
        self.vm = vm
        self.task = task
        _disclosureExpanded = disclosureExpanded
    }
}
