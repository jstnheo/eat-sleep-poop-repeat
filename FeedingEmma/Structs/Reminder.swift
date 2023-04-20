//
//  Reminder.swift
//  FeedingEmma
//
//  Created by Justin on 4/4/23.
//

import Foundation

struct Reminder: Identifiable, Equatable {
    var id: UUID
    var dueDate: Date
    var type: EventType
    var isRecurring: Bool
}

extension ReminderMO: Structable {
    func asStruct() -> Reminder {
        // Required Attributes
        guard let id = self.id,
              let dueDate = self.dueDate,
              let type = EventType(rawValue: self.type ?? "") else {
            fatalError("Missing required attributes in ReminderMO")
        }

        return Reminder(id: id,
                        dueDate: dueDate,
                        type: type,
                        isRecurring: recurring)
                    
    }
}

extension Reminder {
    
    /**
     Returns a new due date for a given `dueDate` parameter based on the following conditions:
     - If `dueDate` plus one day is greater than the current date and time, return `dueDate` plus one day.
     - If the current time is before the due time of `dueDate`, return a new date representing the same time on the current day.
     - Otherwise, return a new date representing the same time on the next day.
     
     - Parameter dueDate: The due date to calculate the new due date for.
     - Returns: A new due date calculated according to the specified conditions.
    */
    
    static func calculateNewDueDate(dueDate: Date) -> Date {
        let now = Date()
        
        if dueDate.addingTimeInterval(24 * 60 * 60) > now {
            // If dueDate + 1 day > Now
            return dueDate.addingTimeInterval(24 * 60 * 60)
        } else {
            let dueDateTime = Calendar.current.dateComponents([.hour, .minute], from: dueDate)
            let todayDueDate = Calendar.current.date(bySettingHour: dueDateTime.hour!, minute: dueDateTime.minute!, second: 0, of: Date())!
            if todayDueDate > now {
                // If Today at time of dueDate > Now
                return todayDueDate
            } else {
                // Otherwise, return Tomorrow at time of dueDate
                return Calendar.current.date(byAdding: .day, value: 1, to: todayDueDate)!
            }
        }
    }
}
