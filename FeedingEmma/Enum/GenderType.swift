//
//  Gender.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/31/23.
//

import Foundation

enum Gender: String, CaseIterable {
    case female
    case male
    case other
    case unknown
}

extension Gender {
    init?(rawValue: String) {
        switch rawValue {
        case "female":
            self = .female
        case "male":
            self = .male
        case "other":
            self = .other
        case "unknown":
            self = .unknown
        default:
            fatalError("Unexpected Gender")
        }
    }
}
