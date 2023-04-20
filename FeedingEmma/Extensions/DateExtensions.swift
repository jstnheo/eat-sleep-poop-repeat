//
//  DateExtensions.swift
//  FeedingEmma
//
//  Created by Justin on 4/2/23.
//

import Foundation

extension Date {
    
    func subtractRandomIntervalToday() -> Date {
        let randomInterval = TimeInterval(Int.random(in: 60...6000)) // Random interval in seconds (between 1 minute and 1 month)
        let newDate = self.addingTimeInterval(-randomInterval)
        return newDate
    }
    
    func subtractRandomInterval() -> Date {
        let randomInterval = TimeInterval(Int.random(in: 60...2592000)) // Random interval in seconds (between 1 minute and 1 month)
        let newDate = self.addingTimeInterval(-randomInterval)
        return newDate
    }
    
    func addRandomInterval() -> Date {
        let randomInterval = TimeInterval(Int.random(in: 60...360))
        let newDate = self.addingTimeInterval(randomInterval)
        return newDate
    }
    
    func addMinutes(_ value: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: value, to: self)!
    }
    
    func addDay() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    func minusDay() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    func minus6Months() -> Date {
        return Calendar.current.date(byAdding: .month, value: -6, to: self)!
    }
    
    func time() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: self)
    }
}

extension Date {
    func groupMonthsByYear(endDate: Date) -> [[MonthItem]] {
        var result: [[MonthItem]] = []
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month], from: self)
        let endDateComponents = calendar.dateComponents([.year, .month], from: endDate)
        
        // If current date and end date are in the same month, return a single array with one MonthItem
        if currentDateComponents.year == endDateComponents.year && currentDateComponents.month == endDateComponents.month {
            let monthItem = MonthItem(id: 1, month: currentDateComponents.month!, year: currentDateComponents.year!)
            result.append([monthItem])
            return result
        }
        
        var currentYear = currentDateComponents.year!
        var currentMonth = currentDateComponents.month!
        while currentYear > endDateComponents.year! || (currentYear == endDateComponents.year! && currentMonth >= endDateComponents.month!) {
            var monthsInCurrentYear: [MonthItem] = []
            while currentMonth >= 1 {
                let monthItem = MonthItem(id: monthsInCurrentYear.count + result.flatMap({ $0 }).count + 1, month: currentMonth, year: currentYear)
                monthsInCurrentYear.append(monthItem)
                currentMonth -= 1
            }
            currentMonth = 12
            currentYear -= 1
            result.append(monthsInCurrentYear)
        }
        return result
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
}
