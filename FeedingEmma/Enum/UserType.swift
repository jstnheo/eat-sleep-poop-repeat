//
//  UserType.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/31/23.
//

import Foundation

enum UserType: String, CaseIterable {
    case parent
    case grandparent
    case caretaker
    case sibling
}

extension UserType {
    init?(rawValue: String) {
        switch rawValue {
        case "parent":
            self = .parent
        case "grandparent":
            self = .grandparent
        case "caretaker":
            self = .caretaker
        case "sibling":
            self = .sibling
        default:
            fatalError("Unexpected UserType")
        }
    }
}
