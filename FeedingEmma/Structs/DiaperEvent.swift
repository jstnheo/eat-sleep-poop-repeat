//
//  DiaperEvent.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/31/23.
//

import Foundation
import CoreData

struct DiaperEvent: EventProtocol {
    var id: UUID
    var serverId: String?
    
    var timestamp: Date
        
    var condition: DiaperCondition
    var messRating: Int
    var note: String?
    
    init(id: UUID,
         serverId: String?,
         timestamp: Date,
         condition: DiaperCondition,
         messRating: Int,
         note: String?) {
        
        self.id = id
        self.serverId = serverId
        self.timestamp = timestamp
        self.condition = condition
        self.messRating = messRating
        self.note = note
    }
    
    init(timestamp: Date, condition: DiaperCondition, messRating: Int) {
        self.id = UUID()
        self.timestamp = timestamp
        self.condition = condition
        self.messRating = messRating
    }
}

extension DiaperEventMO: Structable {
    func asStruct() -> DiaperEvent {
        // Required Attributes
        guard let id = self.id,
              let timeStamp = self.timestamp else {
            fatalError("Missing required attributes in DiaperEntry")
        }

        let serverId = self.serverId
        let condition = DiaperCondition(rawValue: self.condition ?? "") ?? .wet
        let messRating = Int(self.messRating)
        let note = self.note
        
        return DiaperEvent(id: id,
                                 serverId: serverId,
                                 timestamp: timeStamp,
                                 condition: condition,
                                 messRating: messRating,
                                 note: note)
    }
}
