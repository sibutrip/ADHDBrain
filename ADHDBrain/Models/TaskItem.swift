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
    
    var sortName: String {
        switch self {
        case .sorted(let timeSelection):
            switch timeSelection {
            case .morning:
                return "Morning"
            case .afternoon:
                return "Afternoon"
            case .evening:
                return "Evening"
            default:
                return ""
            }
        case .skipped(let skipSelection):
            switch skipSelection {
            case .skip1, .skip3, .skip7:
                return "Skipped"
            default:
                return ""
            }
        case .unsorted:
            return "Unsorted"
        }
    }
}

enum ScheduleError: Error {
    case scheduleFull
}

struct TaskItem: Identifiable, Equatable, Codable {
    let id: UUID
    let name: String
    var sortStatus: SortStatus = .unsorted
    var scheduledDate: Date?
    var scheduleDescription: String {
        switch sortStatus {
        case .sorted(_):
            return "scheduled at \(scheduledDate?.formatted() ?? "")"
        case .skipped(_):
            return "skipped until \(scheduledDate?.formatted() ?? "")"
        case .unsorted:
            return "unsorted"
        }
    }
    
    init(name: String) {
        id = UUID()
        self.name = name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.scheduledDate = try container.decodeIfPresent(Date.self, forKey: .scheduledDate)
        if let scheduledDate = scheduledDate {
            if Date() > scheduledDate {
                self.sortStatus = .unsorted
            } else {
                self.sortStatus = try container.decode(SortStatus.self, forKey: .sortStatus)
            }
        }
    }
    
    mutating func sort(at time: TimeSelection) async throws {
        let midnight = DateComponents(calendar: Calendar.current, timeZone: .autoupdatingCurrent, year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: Calendar.current.component(.day, from: Date()), hour: 0, minute: 0, second: 0)
        switch time {
        case .morning, .afternoon, .evening:
            let eventService = EventService.shared
            let scheduledDate = eventService.selectDate(from: time)
            guard let scheduledDate = scheduledDate else {
                throw ScheduleError.scheduleFull
            }
            self.scheduledDate = scheduledDate
            self.sortStatus = .sorted(time)
            await eventService.scheduleEvent(for: self)
        case .skip1:
            self.sortStatus = .skipped(time)
            self.scheduledDate = Calendar.current.date(byAdding: .day, value: 1, to: midnight.date!)!
        case .skip3:
            self.sortStatus = .skipped(time)
            self.scheduledDate = Calendar.current.date(byAdding: .day, value: 3, to: midnight.date!)!
        case .skip7:
            self.sortStatus = .skipped(time)
            self.scheduledDate = Calendar.current.date(byAdding: .day, value: 7, to: midnight.date!)!
        case .noneSelected:
            return
        }
        return
    }
    
    mutating private func checkSkipDate() {
        guard let skipUntilDate = self.scheduledDate else {
            return
        }
        if Date() > skipUntilDate {
            self.sortStatus = .unsorted
            self.scheduledDate = nil
        }
    }
}
