//
//  Task.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/29/23.
//

import Foundation

enum SortStatus: Equatable {
    case sorted(TimeSelection)
    case skipped(TimeSelection)
    case unsorted
}

struct Task: Identifiable, Equatable {
    let id = UUID()
    let name: String
    var sortStatus: SortStatus = .unsorted
    
    mutating func sort(at time: TimeSelection) {
        if [TimeSelection.morning, TimeSelection.afternoon, TimeSelection.evening].contains(time) {
            self.sortStatus = .sorted(time)
        } else if [TimeSelection.skip1, TimeSelection.skip3, TimeSelection.skip7].contains(time) {
            self.sortStatus = .skipped(time)
        }
    }
}
