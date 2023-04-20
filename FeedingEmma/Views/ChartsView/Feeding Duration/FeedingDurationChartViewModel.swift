//
//  FeedingDurationChartViewModel.swift
//  FeedingEmma
//
//  Created by Justin on 4/19/23.
//


import Foundation
import Combine

struct ProcessedFeedingData: Identifiable {
    let id = UUID().uuidString
    let date: Date
    let duration: Int
}

class FeedingDurationChartViewModel: ObservableObject {
    
    @Published private var historyService: HistoryService
    
    @Published var processedData: [ProcessedFeedingData] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(historyService: HistoryService = DataManager.shared) {
        self.historyService = historyService
        
        self.historyService.eventsPublisher
            .map { $0.compactMap { $0 as? FeedingEvent } }
            .sink { events in
                self.processedData = self.processFeedingEvents(events)
            }
            .store(in: &cancellables)
    }
    
    
    func processFeedingEvents(_ events: [FeedingEvent]) -> [ProcessedFeedingData] {
        let sortedFeedingEvents = events.sorted { $0.timestamp > $1.timestamp }
        guard let lastDate = sortedFeedingEvents.first?.timestamp else { return [] }

        let calendar = Calendar.current
        guard let startDate = calendar.date(byAdding: .day, value: -7, to: lastDate) else { return [] }

        var dailyFeedingData: [Date: Int] = [:]

        (0...7).forEach { i in
            if let currentDate = calendar.date(byAdding: .day, value: i, to: startDate) {
                let date = calendar.startOfDay(for: currentDate)
                dailyFeedingData[date] = 0
            }
        }

        for event in sortedFeedingEvents {
            let startOfDay = calendar.startOfDay(for: event.timestamp)
            if let existingDuration = dailyFeedingData[startOfDay], startOfDay >= startDate {
                dailyFeedingData[startOfDay] = existingDuration + Int(event.duration)
            }
        }

        return dailyFeedingData.map { ProcessedFeedingData(date: $0.key, duration: $0.value) }
    }
    
    func max() -> Double {
        return Double(processedData.max { $0.duration < $1.duration }?.duration ?? 0)
    }
}
