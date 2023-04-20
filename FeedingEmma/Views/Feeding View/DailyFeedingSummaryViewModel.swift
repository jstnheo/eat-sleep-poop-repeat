//
//  DailyFeedingSummaryViewModel.swift
//  FeedingEmma
//
//  Created by Justin on 4/17/23.
//

import Foundation
import Combine

class DailyFeedingSummaryViewModel: ObservableObject {
    private var service: HistoryService
    
    @Published var isEmpty: Bool = true
    
    @Published var recentTime = ""
    @Published var recentSource = ""
    
    @Published var totalCount = ""
    @Published var totalTimeAndAmount = ""
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(service: HistoryService = DataManager.shared) {
        self.service = service
        
        self.updateEvents()
    }
    
    private func updateEvents() {
        self.service.eventsPublisher
            .map { (events: [EventProtocol]) -> [FeedingEvent] in
                return events.compactMap { $0 as? FeedingEvent }
                    .filter { Calendar.current.isDate($0.timestamp, inSameDayAs: Date()) }
            }
            .sink { [weak self] feedingEvents in
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    strongSelf.isEmpty = feedingEvents.isEmpty
                    
                    // RECENT
                    if let mostRecent = feedingEvents.first {
                        strongSelf.recentTime = "\(mostRecent.timestamp.time()) - \(mostRecent.endTimestamp?.time() ?? "")"
                        strongSelf.recentSource = mostRecent.source.rawValue
                    }
                    
                    //TOTAL
                    strongSelf.totalCount = "\(feedingEvents.count) \(feedingEvents.count < 2 ? "feeding" : "feedings")"
                    
                    let totalTime = feedingEvents.reduce(0) { $0 + $1.duration }.formatAsHoursAndMinutes()
                    
                    if let totalAmount = strongSelf.calculateAmount(events: feedingEvents) {
                        strongSelf.totalTimeAndAmount = "\(totalTime) • \(totalAmount)"
                    } else {
                        strongSelf.totalTimeAndAmount = "\(totalTime)"
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func calculateAmount(events: [FeedingEvent]) -> String? {
        let totalMlAmount = events.reduce(0.0) { $0 + ($1.mlAmount ?? 0.0) }
        
        guard totalMlAmount > 0 else {
            return nil
        }
        
        // Convert to OZ
        switch UserDefaults.standard.measurementUnit {
        case .ml:
            return "\(Int(totalMlAmount)) ml"
        case .oz:
            let ozAmount = mlToOz(totalMlAmount)
            return "\(String(format: "%.1f", ozAmount)) oz"
        }
        
    }
    
    private func mlToOz(_ ml: Float) -> Float {
        let oz = ml / 29.574
        return oz
    }
}
