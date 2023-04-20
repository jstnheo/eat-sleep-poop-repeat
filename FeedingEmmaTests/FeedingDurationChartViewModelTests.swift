//
//  FeedingDurationChartViewModelTests.swift
//  FeedingEmmaTests
//
//  Created by Justin on 4/19/23.
//

import XCTest
@testable import FeedingEmma
import Combine

final class FeedingDurationChartViewModelTests: XCTestCase {
    
    var mockHistoryService: MockHistoryService!
    var viewModel: FeedingDurationChartViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockHistoryService = MockHistoryService()
        viewModel = FeedingDurationChartViewModel(historyService: mockHistoryService)
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
                                        mlAmount: nil,
                                        source: nil,
                                        nourishment: nil,
                                        note: nil)
        
        let feedingEvent2 = FeedingEvent(id: UUID(),
                                        serverId: nil,
                                        timestamp: now.minusDay(),
                                        endTimestamp: nil,
                                        leftSeconds: 86, rightSeconds: 76,
                                        gAmount: nil,
                                        mlAmount: nil,
                                        source: nil,
                                        nourishment: nil,
                                        note: nil)

        // Execute
        let processedData = viewModel.processFeedingEvents([feedingEvent1, feedingEvent2])

        // Assert
        XCTAssertEqual(processedData.count, 8)
        let calendar = Calendar.current
        let startOfDay1 = calendar.startOfDay(for: now)
        let startOfDay2 = calendar.startOfDay(for: now.minusDay())
        XCTAssertEqual(processedData.first(where: { $0.date == startOfDay1 })?.duration, 142)
        XCTAssertEqual(processedData.first(where: { $0.date == startOfDay2 })?.duration, 162)
        
        // Check that the other 6 days have a duration of 0
        let remainingDays = processedData.filter { $0.date != startOfDay1 && $0.date != startOfDay2 }
        XCTAssertEqual(remainingDays.count, 6)
        remainingDays.forEach { XCTAssertEqual($0.duration, 0) }

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
                                        mlAmount: nil,
                                        source: nil,
                                        nourishment: nil,
                                        note: nil)
        
        let feedingEvent2 = FeedingEvent(id: UUID(),
                                        serverId: nil,
                                        timestamp: now.minusDay(),
                                        endTimestamp: nil,
                                        leftSeconds: 86, rightSeconds: 76,
                                        gAmount: nil,
                                        mlAmount: nil,
                                        source: nil,
                                        nourishment: nil,
                                        note: nil)
        
        viewModel.processedData = viewModel.processFeedingEvents([feedingEvent1, feedingEvent2])
        
        // Execute
        let maxDuration = viewModel.max()
        
        // Assert
        XCTAssertEqual(maxDuration, 162)
    }
    
    func testProcessedDataUpdates() {
        // Prepare
        let now = Date()
        let feedingEvent1 = FeedingEvent(id: UUID(),
                                        serverId: nil,
                                        timestamp: now,
                                        endTimestamp: nil,
                                        leftSeconds: 66, rightSeconds: 76,
                                        gAmount: nil,
                                        mlAmount: nil,
                                        source: nil,
                                        nourishment: nil,
                                        note: nil)
        
        let feedingEvent2 = FeedingEvent(id: UUID(),
                                        serverId: nil,
                                        timestamp: now.minusDay(),
                                        endTimestamp: nil,
                                        leftSeconds: 86, rightSeconds: 76,
                                        gAmount: nil,
                                        mlAmount: nil,
                                        source: nil,
                                        nourishment: nil,
                                        note: nil)
        
        let expectation = XCTestExpectation(description: "Processed data updates")

        viewModel.$processedData
            .sink { processedData in
                
                print(processedData)

                
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Execute
        mockHistoryService._eventsPublisher.send([feedingEvent1, feedingEvent2])

        // Assert
        wait(for: [expectation], timeout: 1.0)
    }
}
