//
//  TimeIntervalExtension.swift
//  FeedingEmma
//
//  Created by Justin on 4/17/23.
//

import Foundation

extension TimeInterval {
    func formatAsHoursAndMinutes() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .default // remove separators between components
        
        if self >= 3600 {
            // Format as hours and minutes
            let formattedString = formatter.string(from: self)!
            return formattedString.replacingOccurrences(of: "h", with: " hr").replacingOccurrences(of: "m", with: " min")
        } else {
            // Format as minutes
            let minutes = Int(self / 60)
            return "\(minutes) min"
        }
    }
}
