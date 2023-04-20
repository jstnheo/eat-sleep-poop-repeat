//
//  SleepEvent.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/31/23.
//

import Foundation
import CoreData

struct SleepEvent: EventProtocol {
    var id: UUID
    var serverId: String?
    
    var timestamp: Date
    var endTimestamp: Date?
    var note: String?
    
    var duration: TimeInterval {
        if let end = endTimestamp {
            return end.timeIntervalSince(timestamp)
        } else {
            return 0
        }
    }
    
    init(id: UUID,
         serverId: String?,
         timestamp: Date,
         endTimestamp: Date?,
         note: String?) {
        
        self.id = id
        self.serverId = serverId
        self.timestamp = timestamp
        self.endTimestamp = endTimestamp
        self.note = note
    }
    
    init() {
        id = UUID()
        timestamp = Date()
    }
}

extension SleepEventMO: Structable {
    func asStruct() -> SleepEvent {
        // Required Attributes
        guard let id = self.id,
              let timeStamp = self.timestamp else {
            fatalError("Missing required attributes in SleepEntry")
        }

        let serverId = self.serverId
        let endTimestamp = endTimestamp
        let note = self.note
        
        return SleepEvent(id: id,
                                 serverId: serverId,
                                 timestamp: timeStamp,
                                 endTimestamp: endTimestamp,
                                 note: note)
    }
}
