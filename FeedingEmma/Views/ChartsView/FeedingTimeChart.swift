//
//  FeedingTimeChart.swift
//  FeedingEmma
//
//  Created by Justin on 4/18/23.
//

import SwiftUI

var feedDatum: [FeedingTimeData] = [
    FeedingTimeData(startTime: Date().minusDay(), duration: 300),
    FeedingTimeData(startTime: Date().minusDay().minusDay(), duration: 240),
    FeedingTimeData(startTime: Date().minusDay().minusDay().minusDay(), duration: 540),
    FeedingTimeData(startTime: Date().minusDay().minusDay().minusDay(), duration: 440),
    FeedingTimeData(startTime: Date().minusDay().minusDay(), duration: 320),
    FeedingTimeData(startTime: Date().minusDay(), duration: 310),
]

struct FeedingTimeData: Identifiable {
    var id = UUID().uuidString
    var startTime: Date
    var duration: TimeInterval
}

struct FeedingTimeChart: View {
    
    var feedData: [FeedingTimeData]
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Text("Feeding Time")
                    .fontWeight(.bold)
                
                Spacer()
                
                Menu {
                    
                    Button("Year"){}
                    Button("Month"){}
                    Button("Day"){}
                    
                } label: {
                    HStack(spacing: 4) {
                        Text("Last 7 days")
                        
                        Image(systemName: "arrowtriangle.down.fill")
                            .scaleEffect(0.7)
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.theme.textSecondary)
                }
                
            }
            
            HStack(spacing: 10) {
                Capsule()
                    .fill(Color.theme.feedingPrimary)
                    .frame(width: 20, height: 8)
                
                Text("Duration")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.theme.textSecondary )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            GraphView()
                .padding(.top, 20)
            
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .padding(.top, 25)
    }
    
    @ViewBuilder
    func GraphView() -> some View {
        
        GeometryReader { proxy in
            
            ZStack {
                VStack(spacing: 0) {
                    ForEach(getGraphLines(), id: \.self) { line in
                        HStack(spacing: 8) {
                            Text("\(Int(line / 60))")
                                .font(.caption)
                                .foregroundColor(Color.theme.textSecondary)
                                .frame(height: 20)
                            
                            Rectangle()
                                .fill(Color.theme.textSecondary.opacity(0.2))
                                .frame(height: 1)
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: -15)
                    }
                }
                
                HStack {
                    ForEach(last7DaysFeedData()) { feed in
                        VStack(spacing: 0) {
                            Capsule()
                                .fill(Color.theme.feedingPrimary)
                                .frame(width: 8)
                                .frame(height: getBarHeight(point: CGFloat(feed.duration), size: proxy.size))
                            
                            Text(feed.startTime.isToday ? "Today" : feed.startTime.shortDateString)
                                .font(.caption)
                                .frame(height: 25, alignment: .bottom)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                }
                .padding(.leading, 30)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.leading, 30)
        }
        .frame(height: 190)
        
    }
    
    func last7DaysFeedData() -> [FeedingTimeData] {
        let now = Date()
        let weekAgo = Calendar.current.date(byAdding: .day, value: -6, to: now) ?? now
        
        let filteredFeedData = feedData.filter { feed in
            let feedDate = feed.startTime
            return (weekAgo...now).contains(feedDate)
        }.sorted(by: { $0.startTime < $1.startTime })
        
        return filteredFeedData
    }
    
    func getBarHeight(point: CGFloat, size: CGSize) -> CGFloat {
        let max = getMax()
        
        let height = (point / max) * (size.height - 37 )
        return height
    }
    
    // getting Sample Graph Lines based on max Value
    
    func getGraphLines() -> [CGFloat] {
        let max = getMax()
        var lines: [CGFloat] = []

        lines.append(max)

        for index in 1...4 {
            let progress = max / 4

            lines.append(max - (progress * CGFloat(index)))
        }

        return lines
    }
    
    func getMax() -> CGFloat {
        let max = feedData.max { first, second in
            return second.duration > first.duration
        }?.duration ?? 0

        return max
    }
}

struct FeedingTimeChart_Previews: PreviewProvider {
    static var previews: some View {
        FeedingTimeChart(feedData: feedDatum)
    }
}

extension Date {
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
}

extension Date {
    var shortDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter.string(from: self)
    }
}

var feedingEvents: [FeedingEvent] = [
    FeedingEvent(id: UUID(),
                 serverId: nil,
                 timestamp: Date().minusDay(),
                 endTimestamp: Date().minusDay().addMinutes(4),
                 leftSeconds: 0,
                 rightSeconds: 0,
                 gAmount: 0,
                 mlAmount: 0,
                 source: .breast, nourishment: nil, note: nil),
    FeedingEvent(id: UUID(),
                 serverId: nil,
                 timestamp: Date().minusDay().minusDay(),
                 endTimestamp: Date().minusDay().minusDay().addMinutes(4),
                 leftSeconds: 0,
                 rightSeconds: 0,
                 gAmount: 0,
                 mlAmount: 0,
                 source: .breast, nourishment: nil, note: nil),
    FeedingEvent(id: UUID(),
                 serverId: nil,
                 timestamp: Date().minusDay(),
                 endTimestamp: Date().minusDay().addMinutes(6),
                 leftSeconds: 0,
                 rightSeconds: 0,
                 gAmount: 0,
                 mlAmount: 0,
                 source: .breast, nourishment: nil, note: nil),
    FeedingEvent(id: UUID(),
                 serverId: nil,
                 timestamp: Date().minusDay().minusDay().minusDay(),
                 endTimestamp: Date().minusDay().minusDay().minusDay().addMinutes(44),
                 leftSeconds: 0,
                 rightSeconds: 0,
                 gAmount: 0,
                 mlAmount: 0,
                 source: .breast, nourishment: nil, note: nil),
    FeedingEvent(id: UUID(),
                 serverId: nil,
                 timestamp: Date().minusDay().minusDay().minusDay(),
                 endTimestamp: Date().minusDay().minusDay().minusDay().addMinutes(88),
                 leftSeconds: 0,
                 rightSeconds: 0,
                 gAmount: 0,
                 mlAmount: 0,
                 source: .breast, nourishment: nil, note: nil),
    FeedingEvent(id: UUID(),
                 serverId: nil,
                 timestamp: Date().minusDay(),
                 endTimestamp: Date().minusDay().addMinutes(2),
                 leftSeconds: 0,
                 rightSeconds: 0,
                 gAmount: 0,
                 mlAmount: 0,
                 source: .breast, nourishment: nil, note: nil),
    FeedingEvent(id: UUID(),
                 serverId: nil,
                 timestamp: Date().minusDay().minusDay().minusDay().minusDay().minusDay(),
                 endTimestamp: Date().minusDay().minusDay().minusDay().minusDay().minusDay().addMinutes(4),
                 leftSeconds: 0,
                 rightSeconds: 0,
                 gAmount: 0,
                 mlAmount: 0,
                 source: .breast, nourishment: nil, note: nil),
    FeedingEvent(id: UUID(),
                 serverId: nil,
                 timestamp: Date().minusDay().minusDay().minusDay().minusDay().minusDay().minusDay(),
                 endTimestamp: Date().minusDay().minusDay().minusDay().minusDay().minusDay().minusDay().addMinutes(4),
                 leftSeconds: 0,
                 rightSeconds: 0,
                 gAmount: 0,
                 mlAmount: 0,
                 source: .breast, nourishment: nil, note: nil),
    FeedingEvent(id: UUID(),
                 serverId: nil,
                 timestamp: Date().minusDay().minusDay().minusDay().minusDay().minusDay().minusDay().minusDay(),
                 endTimestamp: Date().minusDay().minusDay().minusDay().minusDay().minusDay().minusDay().minusDay().addMinutes(4),
                 leftSeconds: 0,
                 rightSeconds: 0,
                 gAmount: 0,
                 mlAmount: 0,
                 source: .breast, nourishment: nil, note: nil),
    FeedingEvent(id: UUID(),
                 serverId: nil,
                 timestamp: Date().minusDay().minusDay().minusDay().minusDay().minusDay().minusDay().minusDay(),
                 endTimestamp: Date().minusDay().minusDay().minusDay().minusDay().minusDay().minusDay().minusDay().addMinutes(4),
                 leftSeconds: 0,
                 rightSeconds: 0,
                 gAmount: 0,
                 mlAmount: 0,
                 source: .breast, nourishment: nil, note: nil),
    FeedingEvent(id: UUID(),
                 serverId: nil,
                 timestamp: Date().minusDay().minusDay().minusDay().minusDay().minusDay().minusDay(),
                 endTimestamp: Date().minusDay().minusDay().minusDay().minusDay().minusDay().minusDay().addMinutes(4),
                 leftSeconds: 0,
                 rightSeconds: 0,
                 gAmount: 0,
                 mlAmount: 0,
                 source: .breast, nourishment: nil, note: nil),
    FeedingEvent(id: UUID(),
                 serverId: nil,
                 timestamp: Date().minusDay().minusDay().minusDay().minusDay().minusDay(),
                 endTimestamp: Date().minusDay().minusDay().minusDay().minusDay().minusDay().addMinutes(4),
                 leftSeconds: 0,
                 rightSeconds: 0,
                 gAmount: 0,
                 mlAmount: 0,
                 source: .breast, nourishment: nil, note: nil),
    FeedingEvent(id: UUID(),
                 serverId: nil,
                 timestamp: Date().minusDay().minusDay().minusDay().minusDay().minusDay(),
                 endTimestamp: Date().minusDay().minusDay().minusDay().minusDay().minusDay().addMinutes(4),
                 leftSeconds: 0,
                 rightSeconds: 0,
                 gAmount: 0,
                 mlAmount: 0,
                 source: .breast, nourishment: nil, note: nil),
    FeedingEvent(id: UUID(),
                 serverId: nil,
                 timestamp: Date().minusDay().minusDay().minusDay().minusDay().minusDay(),
                 endTimestamp: Date().minusDay().minusDay().minusDay().minusDay().minusDay().addMinutes(4),
                 leftSeconds: 0,
                 rightSeconds: 0,
                 gAmount: 0,
                 mlAmount: 0,
                 source: .breast, nourishment: nil, note: nil),
    FeedingEvent(id: UUID(),
                 serverId: nil,
                 timestamp: Date().minusDay(),
                 endTimestamp: Date().minusDay().addMinutes(4),
                 leftSeconds: 0,
                 rightSeconds: 0,
                 gAmount: 0,
                 mlAmount: 0,
                 source: .breast, nourishment: nil, note: nil)
    
]

