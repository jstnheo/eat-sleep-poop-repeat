//
//  DiaperTimelineView.swift
//  FeedingEmma
//
//  Created by Justin on 4/11/23.
//

import SwiftUI

struct DiaperTimelineView: View {
    private let diaperEvent: DiaperEvent
    
    init(diaperEvent: DiaperEvent) {
        self.diaperEvent = diaperEvent
    }
    
    var body: some View {
        
        VStack(spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Diaper")
                        .font(.headline)
                        .foregroundColor(Color.theme.diaperPrimary)
                    
                    Text("\(diaperEvent.condition.rawValue) • \(diaperEvent.messRating) mess")
                        .foregroundColor(Color.theme.textSecondary)
                    
                }
                
                Spacer()
                
                Text(diaperEvent.timestamp, style: .time)
            }
            
            if let notes = diaperEvent.note, notes.isEmpty == false {
                                
                Text(notes)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)

            }
        }
    }
}

struct DiaperTimelineView_Previews: PreviewProvider {
    
    static var previews: some View {
        let event = DiaperEvent(timestamp: Date(), condition: .clean, messRating: 9)
        DiaperTimelineView(diaperEvent: event)
    }
}
