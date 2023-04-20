//
//  MockHistoryService.swift
//  FeedingEmmaTests
//
//  Created by Justin on 4/20/23.
//

import XCTest
@testable import FeedingEmma
import Combine

class MockHistoryService: HistoryService {
    let _eventsPublisher = PassthroughSubject<[any EventProtocol], Never>()
    var eventsPublisher: AnyPublisher<[any EventProtocol], Never> {
        return _eventsPublisher.eraseToAnyPublisher()
    }

    func deleteHistoryEvent(id: UUID) {
        // You can implement the delete logic here or leave it empty if not needed for your tests.
    }
}
