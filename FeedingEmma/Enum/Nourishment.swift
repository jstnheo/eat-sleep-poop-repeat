//
//  Nourishment.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/31/23.
//

import Foundation

enum Nourishment: String, CaseIterable {
    case breastMilk
    case formula
    
    var localizedString: String {
        switch self {
        case .breastMilk:
            return "breast milk"
        case .formula:
            return "formula"
        }
    }
}
