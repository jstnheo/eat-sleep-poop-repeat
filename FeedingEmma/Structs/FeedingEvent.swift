//
//  FeedingEvent.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/31/23.
//

import Foundation
import CoreData

struct FeedingEvent: EventProtocol {
    var id: UUID
    var serverId: String?
    
    var timestamp: Date
    var endTimestamp: Date?
    
    var leftSeconds: TimeInterval?
    var rightSeconds: TimeInterval?
    
    var gAmount: Float?
    var mlAmount: Float?
    
    var source: FeedingSource
    var nourishment: Nourishment
    
    var note: String?
    
    var duration: TimeInterval {
        if let end = endTimestamp, end.addMinutes(1) > timestamp {
            return end.timeIntervalSince(timestamp)
        } else if let left = leftSeconds, let right = rightSeconds {
            return left + right
        } else {
            return 0
        }
    }
    
    init(id: UUID,
         serverId: String?,
         timestamp: Date,
         endTimestamp: Date?,
         leftSeconds: TimeInterval?,
         rightSeconds: TimeInterval?,
         gAmount: Float?,
         mlAmount: Float?,
         source: FeedingSource?,
         nourishment: Nourishment?,
         note: String?) {
        
        self.id = id
        self.serverId = serverId
        self.timestamp = timestamp
        self.endTimestamp = endTimestamp
        self.leftSeconds = leftSeconds
        self.rightSeconds = rightSeconds
        self.gAmount = gAmount
        self.mlAmount = mlAmount
        self.source = source ?? .bottle
        self.nourishment = nourishment ?? .formula
        self.note = note
    }
}

extension FeedingEventMO: Structable {
    func asStruct() -> FeedingEvent {
        // Required Attributes
        guard let id = self.id,
              let timeStamp = self.timestamp else {
            fatalError("Missing required attributes in DiaperEntry")
        }
        
        let serverId = self.serverId
        let endTimestamp = self.endTimestamp
        
        let lSeconds = self.leftSeconds
        let rSeconds = self.rightSeconds
        
        let gAmount = Float(self.gramAmount)
        let mlAmount = Float(self.mlAmount)
        
        let source = FeedingSource(rawValue: self.source ?? "") ?? .bottle
        let nourishment = Nourishment(rawValue: self.nourishment ?? "") ?? .formula
        
        let note = self.note
        
        return FeedingEvent(id: id,
                            serverId: serverId,
                            timestamp: timeStamp,
                            endTimestamp: endTimestamp,
                            leftSeconds: lSeconds,
                            rightSeconds: rSeconds,
                            gAmount: gAmount,
                            mlAmount: mlAmount,
                            source: source,
                            nourishment: nourishment,
                            note: note)
    }
}
