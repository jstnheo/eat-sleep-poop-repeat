//
//  DateExtensionTests.swift
//  FeedingEmmaTests
//
//  Created by Justin on 4/5/23.
//

import XCTest
@testable import FeedingEmma

class DateExtensionsTests: XCTestCase {
    func testStartOfMonth() {
        let date = Date(timeIntervalSince1970: 1619149800) // 2021-04-23 16:30:00 UTC
        let startOfMonth = date.startOfMonth()
        let expectedStartOfMonth = Calendar.current.date(from: DateComponents(year: 2021, month: 4, day: 1))!
        
        XCTAssertEqual(startOfMonth, expectedStartOfMonth, "startOfMonth() returned unexpected result")
    }

}
