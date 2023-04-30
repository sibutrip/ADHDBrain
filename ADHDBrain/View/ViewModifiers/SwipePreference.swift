//
//  SwipePreference.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/30/23.
//

import Foundation
import SwiftUI

struct SwipePreference: PreferenceKey {
    static var defaultValue: TaskSwipe?

    static func reduce(value: inout TaskSwipe?, nextValue: () -> TaskSwipe?) {
        value = nextValue()
    }
}

struct TaskSwipe: Equatable {
    let task: Task
    let swipeDiretion: SwipeDirection
}

enum SwipeDirection: Equatable {
    case left, right, notSwiped
}
