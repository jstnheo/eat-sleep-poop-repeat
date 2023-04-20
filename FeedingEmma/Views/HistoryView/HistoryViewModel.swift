//
//  HistoryViewModel.swift
//  FeedingEmma
//
//  Created by Justin on 4/3/23.
//

import Foundation
import CoreData
import Combine

class HistoryViewModel: ObservableObject {
    @Published private var historyService: HistoryService
    @Published var events: [Date: [any EventProtocol]] = [:]
    
    var filterBy: EventType? {
        didSet {
            updateEvents()
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(historyService: HistoryService = DataManager.shared, filterBy: EventType? = nil) {
        self.historyService = historyService
        self.filterBy = filterBy
        
        updateEvents()
    }
    
    private func updateEvents() {
        self.historyService.eventsPublisher
            .map { events in
                
                let filteredArray: [any EventProtocol]
                
                if let filterBy = self.filterBy {
                    switch filterBy {
                    case .feeding:
                        filteredArray = events.filter { $0 is FeedingEvent }
                    case .diaper:
                        filteredArray = events.filter { $0 is DiaperEvent }
                    case .sleep:
                        filteredArray = events.filter { $0 is SleepEvent }
                    }
                } else {
                    filteredArray = events
                }
                
                return Dictionary(grouping: filteredArray) { event in
                    Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: event.timestamp))!
                }
            }
            .assign(to: \.events, on: self)
            .store(in: &cancellables)
    }
    
    func deleteEvent(at offsets: IndexSet, date: Date) {
        let indexes = offsets.map { $0 }
        let eventsToDelete = indexes.map { events[date]![$0] }
        
        for event in eventsToDelete {
            historyService.deleteHistoryEvent(id: event.id)
        }
    }
    
    func numberOfFeedings(for date: Date) -> Int {
         return events[date]?.filter { $0 is FeedingEvent }.count ?? 0
     }

     func timeSlept(for date: Date) -> TimeInterval {
         return 88
//         let sleepEvents = events[date]?.compactMap { $0 as? SleepEvent } ?? []
//         return sleepEvents.reduce(into: TimeInterval(0)) { total, event in
//             total + event.duration
//         }
     }

     func numberOfDiapers(for date: Date) -> Int {
         return events[date]?.filter { $0 is DiaperEvent }.count ?? 0
     }
}
