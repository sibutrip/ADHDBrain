//
//  Task.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/29/23.
//

import Foundation

enum SortStatus: Equatable, Codable {
    case sorted(TimeSelection)
    case skipped(TimeSelection)
    case unsorted
}

struct TaskItem: Identifiable, Equatable, Codable {
    let id: UUID
    let name: String
    var sortStatus: SortStatus = .unsorted
    var skipUntilDate: Date?
    
    init(name: String) {
        id = UUID()
        self.name = name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.skipUntilDate = try container.decodeIfPresent(Date.self, forKey: .skipUntilDate)
        if let skipUntilDate = skipUntilDate {
            if Date() > skipUntilDate {
                self.sortStatus = .unsorted
            } else {
                self.sortStatus = try container.decode(SortStatus.self, forKey: .sortStatus)
            }
        }
    }
    
    mutating func sort(at time: TimeSelection) {
        let midnight = DateComponents(calendar: Calendar.current, timeZone: .autoupdatingCurrent, year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: Calendar.current.component(.day, from: Date()), hour: 0, minute: 0, second: 0)
        switch time {
        case .morning, .afternoon, .evening:
            self.sortStatus = .sorted(time)
        case .skip1:
            self.sortStatus = .skipped(time)
            self.skipUntilDate = Calendar.current.date(byAdding: .day, value: 1, to: midnight.date!)!
        case .skip3:
            self.sortStatus = .skipped(time)
            self.skipUntilDate = Calendar.current.date(byAdding: .day, value: 3, to: midnight.date!)!
        case .skip7:
            self.sortStatus = .skipped(time)
            self.skipUntilDate = Calendar.current.date(byAdding: .day, value: 7, to: midnight.date!)!
        case .noneSelected:
            return
        }
    }
    
    mutating func checkSkipDate() {
        guard let skipUntilDate = self.skipUntilDate else {
            return
        }
        if Date() > skipUntilDate {
            self.sortStatus = .unsorted
            self.skipUntilDate = nil
        }
    }
}
