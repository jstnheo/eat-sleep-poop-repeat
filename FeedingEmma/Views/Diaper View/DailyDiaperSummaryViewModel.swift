//
//  DailyDiaperSummaryViewModel.swift
//  FeedingEmma
//
//  Created by Justin on 4/17/23.
//

import Foundation
import Combine

class DailyDiaperSummaryViewModel: ObservableObject {
    @Published private var historyService: HistoryService
    
    @Published var isEmpty: Bool = true
    
    @Published var recentTime = ""
    @Published var recentCondition = ""
    
    @Published var totalCount = ""
    @Published var totalAmounts = ""
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(service: HistoryService = DataManager.shared) {
        self.historyService = service
        
        updateEvents()
    }
    
    private func updateEvents() {
        self.historyService.eventsPublisher
            .map { (events: [EventProtocol]) -> [DiaperEvent] in
                return events.compactMap { $0 as? DiaperEvent }
                    .filter { Calendar.current.isDate($0.timestamp, inSameDayAs: Date()) }
            }
            .sink { [weak self] diaperEvent in
                guard let strongSelf = self else { return }
                                
                DispatchQueue.main.async {
                    
                    strongSelf.isEmpty = diaperEvent.isEmpty
                    
                    // RECENT
                    if let mostRecent = diaperEvent.first {
                        strongSelf.recentTime = "\(mostRecent.timestamp.time())"
                        strongSelf.recentCondition = "\(mostRecent.condition.rawValue) • \(mostRecent.messRating) mess"
                    }
                    
                    // TOTAL
                    strongSelf.totalCount = "\(diaperEvent.count) \(diaperEvent.count < 2 ? "diaper" : "diapers")"
                    
                    let cleanCount = diaperEvent.filter { $0.condition == .clean }.count
                    let wetCount = diaperEvent.filter { $0.condition == .wet }.count
                    let dirtyCount = diaperEvent.filter { $0.condition == .dirty }.count
                    let bothCount = diaperEvent.filter { $0.condition == .both }.count

                    var countsString = ""

                    if cleanCount > 0 {
                        countsString += "\(cleanCount) clean • "
                    }
                    if wetCount > 0 {
                        countsString += "\(wetCount) wet • "
                    }
                    if dirtyCount > 0 {
                        countsString += "\(dirtyCount) dirty • "
                    }
                    if bothCount > 0 {
                        countsString += "\(bothCount) both • "
                    }

                    // Remove the trailing " • " if it exists
                    if countsString.hasSuffix(" • ") {
                        countsString = String(countsString.dropLast(3))
                    }
                    
                    strongSelf.totalAmounts = countsString
                }
         
            }
            .store(in: &cancellables)
    }
}
