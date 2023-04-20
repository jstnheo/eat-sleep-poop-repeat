//
//  FeedingAmountViewModel.swift
//  FeedingEmma
//
//  Created by Justin on 4/19/23.
//

import Foundation
import Combine

struct ProcessedFeedingAmountData: Identifiable {
    let id = UUID().uuidString
    let date: Date
    let mlAmount: Float
}

class FeedingAmountViewModel: ObservableObject {
    
    @Published private var historyService: HistoryService
    
    @Published var processedData: [ProcessedFeedingAmountData] = []
    @Published var totalAmount: Float = 0
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(historyService: HistoryService = DataManager.shared) {
        self.historyService = historyService
        
        self.historyService.eventsPublisher
            .map { $0.compactMap { $0 as? FeedingEvent } }
            .sink { events in
                self.processedData = self.processFeedingAmountEvents(events)
                self.totalAmount = self.processedData.reduce(0.0) {
                    partialResult, item in
                    item.mlAmount + partialResult
                }
            }
            .store(in: &cancellables)
    }
    
    
    func processFeedingAmountEvents(_ events: [FeedingEvent]) -> [ProcessedFeedingAmountData] {
        let sortedFeedingEvents = events.sorted { $0.timestamp > $1.timestamp }
        guard let lastDate = sortedFeedingEvents.first?.timestamp else { return [] }

        let calendar = Calendar.current
        guard let startDate = calendar.date(byAdding: .day, value: -7, to: lastDate) else { return [] }

        var dailyFeedingData: [Date: Float] = [:]

        (0...7).forEach { i in
            if let currentDate = calendar.date(byAdding: .day, value: i, to: startDate) {
                let date = calendar.startOfDay(for: currentDate)
                dailyFeedingData[date] = 0
            }
        }

        for event in sortedFeedingEvents {
            let startOfDay = calendar.startOfDay(for: event.timestamp)
            if let existingAmount = dailyFeedingData[startOfDay], startOfDay >= startDate {
                dailyFeedingData[startOfDay] = existingAmount + (event.mlAmount ?? 0)
            }
        }

        return dailyFeedingData.map { ProcessedFeedingAmountData(date: $0.key, mlAmount: $0.value) }
    }
    
    func max() -> Double {
        return Double(processedData.max { $0.mlAmount < $1.mlAmount }?.mlAmount ?? 0)
    }
}
