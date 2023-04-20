//
//  FeedingTimelineView.swift
//  FeedingEmma
//
//  Created by Justin on 4/17/23.
//

import SwiftUI

struct FeedingTimelineView: View {
    let event: FeedingEvent
    
    init(feedingEvent: FeedingEvent) {
        self.event = feedingEvent
    }
    
    var body: some View {
        
        VStack(spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text("Feeding")
                        .font(.headline)
                        .foregroundColor(Color.theme.feedingPrimary)

                    if let timeString = timeString(event: event) {
                        Text(timeString)
                            .foregroundColor(Color.theme.textSecondary)
                    }
                                    
                    Text(amountString(event: event))
                        .foregroundColor(Color.theme.textSecondary)
                    
                }
                Spacer()
                Text(event.timestamp, style: .time)
            }
            
            if let notes = event.note, notes.isEmpty == false {
                                
                Text(notes)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)

            }
        }
    }
    
    private func mlToOz(_ ml: Float) -> Float {
        let oz = ml / 29.574
        return oz
    }
    
    func timeString(event: FeedingEvent) -> String? {
        var result: [String] = []

        if let leftSeconds = event.leftSeconds,
            let rightSeconds = event.rightSeconds,
            leftSeconds > 0 || rightSeconds > 0 {
            
            result.append("\(leftSeconds.formatAsHoursAndMinutes()) (L)")
            
            result.append("\(rightSeconds.formatAsHoursAndMinutes()) (R)")

        } else {
            if event.duration > 0 {
                result.append(event.duration.formatAsHoursAndMinutes())
            }
        }
        
        return result.isEmpty ? nil : result.joined(separator: " • ")
    }
    
    func amountString(event: FeedingEvent) -> String {
        var result: [String] = []
        
        result.append(event.source.rawValue)
        
        if event.source == .bottle {
            result.append(event.nourishment.localizedString)
            
            if let mlAmount = event.mlAmount {
                switch UserDefaults.standard.measurementUnit {
                case .ml:
                    result.append("\(Int(mlAmount)) ml")
                case .oz:
                    let ozAmount = mlToOz(mlAmount)
                    result.append("\(String(format: "%.1f", ozAmount)) oz")
                }
            }
        }
                
        if event.source == .solid {
            
            // TODO:
            //Tablespoon amount
        }

        return result.joined(separator: " • ")
    }
}
