//
//  SleepTimelineView.swift
//  FeedingEmma
//
//  Created by Justin on 4/17/23.
//

import SwiftUI

struct SleepTimelineView: View {
    let timestamp: Date
    let duration: TimeInterval
    
    init(sleepEvent: SleepEvent) {
        self.timestamp = sleepEvent.timestamp
        self.duration = sleepEvent.duration
    }
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Sleep")
                    .font(.headline)
                    .foregroundColor(Color.theme.sleepPrimary)
                Text(duration.formatAsHoursAndMinutes())
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(timestamp, style: .time)
        }
    }
}

//struct SleepTimelineView_Previews: PreviewProvider {
//    static var previews: some View {
//        SleepTimelineView()
//    }
//}
