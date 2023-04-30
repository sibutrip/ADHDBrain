//
//  DropPreference.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/30/23.
//

import Foundation
import SwiftUI

struct DropPreference: PreferenceKey {
    static var defaultValue: TaskDrop?

    static func reduce(value: inout TaskDrop?, nextValue: () -> TaskDrop?) {
        value = nextValue()
    }
}

struct TaskDrop: Equatable {
    let task: Task
    let dropAction: DropAction
}

enum DropAction: Equatable {
    case morning, afternoon, evening, noDrop
}
