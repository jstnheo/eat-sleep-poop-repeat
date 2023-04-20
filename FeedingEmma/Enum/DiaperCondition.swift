//
//  DiaperCondition.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/31/23.
//

import Foundation

enum DiaperCondition: String, CaseIterable {
    case clean
    case wet
    case dirty
    case both
}

extension DiaperCondition {
    init?(rawValue: String) {
        switch rawValue {
        case "clean":
            self = .clean
        case "wet":
            self = .wet
        case "dirty":
            self = .dirty
        case "both":
            self = .both
        default:
            fatalError("Unexpected DiaperCondition")
        }
    }
}
