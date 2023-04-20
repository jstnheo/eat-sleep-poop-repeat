//
//  EventProtocol.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/31/23.
//

import Foundation

protocol EventProtocol: Identifiable, Hashable {
    var id: UUID { get set }
    var serverId: String? { get }
    var timestamp: Date { get set }
}

protocol Structable {
    associatedtype StructObject
    func asStruct() -> StructObject
}
