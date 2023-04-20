//
//  FeedingAmountViewModelTests.swift
//  FeedingEmmaTests
//
//  Created by Justin on 4/20/23.
//

import XCTest
@testable import FeedingEmma
import Combine

final class FeedingAmountViewModelTests: XCTestCase {
    
    var mockHistoryService: MockHistoryService!
    var viewModel: FeedingAmountViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockHistoryService = MockHistoryService()
        viewModel = FeedingAmountViewModel(historyService: mockHistoryService)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        mockHistoryService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testProcessFeedingEvents() {
        // Prepare
        let now = Date()
        let feedingEvent1 = FeedingEvent(id: UUID(),
                                         serverId: nil,
                                         timestamp: now,
                                         endTimestamp: nil,
                                         leftSeconds: 66, rightSeconds: 76,
                                         gAmount: nil,
                                         mlAmount: 180,
                                         source: nil,
                                         nourishment: nil,
                                         note: nil)
        
        let feedingEvent2 = FeedingEvent(id: UUID(),
                                         serverId: nil,
                                         timestamp: now.minusDay(),
                                         endTimestamp: nil,
                                         leftSeconds: 86, rightSeconds: 76,
                                         gAmount: nil,
                                         mlAmount: 120,
                                         source: nil,
                                         nourishment: nil,
                                         note: nil)
        
        // Execute
        let processedData = viewModel.processFeedingAmountEvents([feedingEvent1, feedingEvent2])
        
        // Assert
        XCTAssertEqual(processedData.count, 8)
        let calendar = Calendar.current
        let startOfDay1 = calendar.startOfDay(for: now)
        let startOfDay2 = calendar.startOfDay(for: now.minusDay())
        XCTAssertEqual(processedData.first(where: { $0.date == startOfDay1 })?.mlAmount, 180)
        XCTAssertEqual(processedData.first(where: { $0.date == startOfDay2 })?.mlAmount, 120)
        
        // Check that the other 6 days have a duration of 0
        let remainingDays = processedData.filter { $0.date != startOfDay1 && $0.date != startOfDay2 }
        XCTAssertEqual(remainingDays.count, 6)
        remainingDays.forEach { XCTAssertEqual($0.mlAmount, 0) }
        
    }
    
    func testMaxDuration() {
        // Prepare
        let now = Date()
        let feedingEvent1 = FeedingEvent(id: UUID(),
                                         serverId: nil,
                                         timestamp: now,
                                         endTimestamp: nil,
                                         leftSeconds: 66, rightSeconds: 76,
                                         gAmount: nil,
                                         mlAmount: 180,
                                         source: nil,
                                         nourishment: nil,
                                         note: nil)
        
        let feedingEvent2 = FeedingEvent(id: UUID(),
                                         serverId: nil,
                                         timestamp: now.minusDay(),
                                         endTimestamp: nil,
                                         leftSeconds: 86, rightSeconds: 76,
                                         gAmount: nil,
                                         mlAmount: 120,
                                         source: nil,
                                         nourishment: nil,
                                         note: nil)
        
        viewModel.processedData = viewModel.processFeedingAmountEvents([feedingEvent1, feedingEvent2])
        
        // Execute
        let maxAmount = viewModel.max()
        
        // Assert
        XCTAssertEqual(maxAmount, 180)
    }
    
}
