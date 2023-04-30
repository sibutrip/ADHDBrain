//
//  Task.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/29/23.
//

import Foundation

struct Task: Identifiable, Equatable {
    enum SortStatus: Equatable {
        case sorted(SortedTime)
        case skipped
        case unsorted
    }
    enum SortedTime {
        case morning, afternoon, evening, notDetermined
    }
    let id = UUID()
    let name: String
    var sortStatus: SortStatus = .unsorted
}
