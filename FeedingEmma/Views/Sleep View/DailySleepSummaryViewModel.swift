//
//  DailySleepSummaryViewModel.swift
//  FeedingEmma
//
//  Created by Justin on 4/17/23.
//

import Foundation
import Combine

class DailySleepSummaryViewModel: ObservableObject {
    @Published private var historyService: HistoryService
    
    @Published var isEmpty: Bool = true
    
    @Published var recentTime = ""
    
    @Published var totalCount = ""
    @Published var totalAmount = ""
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(service: HistoryService = DataManager.shared) {
        self.historyService = service
        
        updateEvents()
    }
    
    private func updateEvents() {
        self.historyService.eventsPublisher
            .map { (events: [EventProtocol]) -> [SleepEvent] in
                return events.compactMap { $0 as? SleepEvent }
                    .filter { Calendar.current.isDate($0.timestamp, inSameDayAs: Date()) }
            }
            .sink { [weak self] sleepEvents in
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    strongSelf.isEmpty = sleepEvents.isEmpty
                    
                    if let mostRecent = sleepEvents.first {
                        strongSelf.recentTime = "\(mostRecent.timestamp.time()) - \(mostRecent.endTimestamp?.time() ?? "")"
                    }
                    
                    let totalSleepTime = sleepEvents.reduce(0) { $0 + $1.duration }
                    let totalSleepCount = sleepEvents.count
                    
                    strongSelf.totalAmount = totalSleepTime.formatAsHoursAndMinutes()
                    strongSelf.totalCount = "\(totalSleepCount) \(totalSleepCount < 2 ? "sleep" : "sleeps")"
                }
            }
            .store(in: &cancellables)
    }
}
