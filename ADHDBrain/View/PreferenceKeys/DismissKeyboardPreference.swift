//
//  DismissKeyboardPreference.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 5/13/23.
//

import Foundation
import SwiftUI

struct DismissKeyboardPreference: PreferenceKey {
    static var defaultValue: SortView.FocusedField?

    static func reduce(value: inout SortView.FocusedField?, nextValue: () -> SortView.FocusedField?) {
        value = nextValue()
    }
}
