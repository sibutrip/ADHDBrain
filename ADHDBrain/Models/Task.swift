//
//  Task.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/29/23.
//

import Foundation

enum SortedTime {
    case Morning, Afternoon, Evening
}

enum SkippedTime {
    case OneDay, ThreeDays, SevenDays
}

enum SortStatus: Equatable {
    case sorted(SortedTime)
    case skipped(SkippedTime)
    case unsorted
}


struct Task: Identifiable, Equatable {
    let id = UUID()
    let name: String
    var sortStatus: SortStatus = .unsorted
}
