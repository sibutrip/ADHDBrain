//
//  DragPreference.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/30/23.
//

import Foundation
import SwiftUI

struct DragPreference: PreferenceKey {
    static var defaultValue: Bool?

    static func reduce(value: inout Bool?, nextValue: () -> Bool?) {
        value = nextValue()
    }
}




