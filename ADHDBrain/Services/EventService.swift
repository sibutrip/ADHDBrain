//
//  EventService.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 5/3/23.
//

import Foundation
import EventKit

class EventService {
    // to-do make used dates a property wrapper. also for task items. fo read/writing
    private var usedDates = [Date]()
    {
        didSet {
//            _ = usedDates.map {print($0.description(with: .autoupdatingCurrent)) }
            DirectoryService.shared.writeModelToDisk(usedDates)
        }
    }
    
    func scheduleEvent(for task: TaskItem) async  {
        let eventStore : EKEventStore = EKEventStore()
        do {
            if try await eventStore.requestAccess(to: .event) {
                
                guard let scheduledDate = task.scheduledDate else { return }
                let event = EKEvent(eventStore: eventStore)
                event.title = task.name
                event.startDate = scheduledDate
                event.endDate = scheduledDate.addingTimeInterval(900)
                event.calendar = eventStore.defaultCalendarForNewEvents
                event.addAlarm(.init(absoluteDate: scheduledDate))
                try eventStore.save(event, span: .thisEvent)
                print(event.description)
            }
        } catch {
            print("failed to save event with error : \(error.localizedDescription)")
        }
        print("Saved Event")
    }
    
    public func selectDate(from timeSelection: TimeSelection) -> Date {
        let usedDates = self.usedDates
        let availableDates = fetchAvailableDates(for: timeSelection)
        let randomDate = availableDates.filter { date in
            !usedDates.contains(date)
        }.randomElement()!
        self.usedDates.append(randomDate)
        return randomDate
    }
    
    private func fetchAvailableDates(for timeSelection: TimeSelection) -> [Date] {
        let cal = Calendar(identifier: .gregorian)
        let date = Date()
        let time = DateComponents(calendar: .autoupdatingCurrent, timeZone: .autoupdatingCurrent, year: cal.component(.year, from: date), month: cal.component(.month, from: date), day: cal.component(.day, from: date), hour: cal.component(.hour, from: date), minute: cal.component(.minute, from: date), second: cal.component(.second, from: date))
        let endHour: Int
        switch timeSelection {
        case .morning:
            endHour = 11
        case .afternoon:
            endHour = 16
        case .evening:
            endHour = 20
        default:
            return []
        }
        let hourDiff = (endHour - time.hour!) * 4
        let minDiff = (60 - time.minute!) / 15 // integer division
        var availableSlots = hourDiff + minDiff
        if availableSlots > 14 || availableSlots < 0 { // if the time hasnt come yet today (greater than 16), limit to 16. if it's already passed today (less than 0), set to 16
            availableSlots = 14
        }
        let dates = generateDates(for: availableSlots, during: timeSelection)
        return dates
    }
    
    private func generateDates(for availableSlots: Int, during timeSelection: TimeSelection) -> [Date] {
        let cal = Calendar.current
        var dates = [Date]()
        var availableSlots = availableSlots
        var mins = 45
        var hour: Int
        switch timeSelection {
        case .morning:
            hour = 11
        case .afternoon:
            hour = 16
        case .evening:
            hour = 20
        default:
            return []
        }
        
        while availableSlots > 0 {
            let date = (cal.nextDate(after: Date(), matching: DateComponents(calendar: .autoupdatingCurrent, timeZone: .autoupdatingCurrent, hour: hour, minute: mins), matchingPolicy: .nextTime))
            
            dates.append(date!)
            
            availableSlots -= 1
            if mins == 0 {
                mins = 45
                hour -= 1
            } else {
                mins -= 15
            }
        }
        return dates
    }
    
    private func filterDates() {
        let usedDates: [Date]? = try? DirectoryService.shared.readModelFromDisk()
        if var usedDates = usedDates {
            usedDates = usedDates.filter {
                Date() < $0
            }
            self.usedDates = usedDates
        } else {
            self.usedDates = []
        }
    }
    
    init() {
        filterDates()
        
        print("used dates are", self.usedDates)
        let store = EKEventStore.init()
        store.requestAccess(to: .event) { (granted, error) in
            if let error = error {
                print("request access error: \(error)")
            } else if granted {
                print("granted!")
            } else {
            }
        }
    }
}
