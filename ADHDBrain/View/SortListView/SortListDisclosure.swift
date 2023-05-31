//
//  SortListDisclosure.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 5/31/23.
//

import Foundation
import SwiftUI

struct SortListDisclosure: View {
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
                    VStack {
                        HStack {
                            ForEach(Time.skips) { skip in
                                Button {
                                    print(skip.name)
                                } label: {
                                    Label(skip.name, image: skip.image)
                                        .foregroundColor(skip.color)
                                        .labelStyle(.iconOnly)
                                        .padding(5)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        Text("Skip")
                            .font(.caption)
                    }
                    Spacer()
                    VStack {
                        HStack {
                            ForEach(Time.days) { day in
                                Button {
                                    print(day.name)
                                } label: {
                                    Label(day.name, systemImage: day.image)
                                        .foregroundColor(day.color)
                                        .labelStyle(.iconOnly)
                                        .padding(5)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        Text("Schedule")
                            .font(.caption)
                    }
                }
            }

    }
    
    init(_ task: TaskItem, _ disclosureExpanded: Binding<Set<UUID>>) {
        self.task = task
        _disclosureExpanded = disclosureExpanded
    }
}
