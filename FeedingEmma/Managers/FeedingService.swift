//
//  FeedingService.swift
//  FeedingEmma
//
//  Created by Justin on 4/10/23.
//

import Foundation
import CoreData

protocol FeedingService {
    func createFeedingEvent(_ event: FeedingEvent)
    func updateFeedingEvent(_ event: FeedingEvent)
    func deleteFeedingEvent(id: UUID)
}

extension DataManager: FeedingService {
    
    func createFeedingEvent(_ event: FeedingEvent) {
        let eventMO = FeedingEventMO(context: managedObjectContext)
        eventMO.id = event.id
        eventMO.timestamp = event.timestamp
        eventMO.endTimestamp = event.endTimestamp
        
        eventMO.leftSeconds = event.leftSeconds ?? 0
        eventMO.rightSeconds = event.rightSeconds ?? 0
        
        eventMO.gramAmount = event.gAmount ?? 0
        eventMO.mlAmount = event.mlAmount ?? 0
    
        eventMO.nourishment = event.nourishment.rawValue
        eventMO.source = event.source.rawValue
                
        eventMO.note = event.note
        
        assignToBaby(eventMO)
        
        saveData()
    }
    
    func updateFeedingEvent(_ event: FeedingEvent) {
        let request: NSFetchRequest<FeedingEventMO> = FeedingEventMO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", event.id as CVarArg)
        
        if let eventMO = try? managedObjectContext.fetch(request).first {
            
            eventMO.timestamp = event.timestamp
            eventMO.endTimestamp = event.endTimestamp
            
            eventMO.leftSeconds = event.leftSeconds ?? 0
            eventMO.rightSeconds = event.rightSeconds ?? 0
            
            eventMO.gramAmount = event.gAmount ?? 0
            eventMO.mlAmount = event.mlAmount ?? 0
            
            eventMO.nourishment = event.nourishment.rawValue
            eventMO.source = event.source.rawValue
                    
            eventMO.note = event.note
            
            saveData()
            
        } else {
            // throw error that this DiaperEventMO could not be found. This might be fatal
            fatalError("DiaperEventMO was not found in database")
        }
   
    }
    
    func deleteFeedingEvent(id: UUID) {
        let request: NSFetchRequest<FeedingEventMO> = FeedingEventMO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let eventMO = try? managedObjectContext.fetch(request).first {
            managedObjectContext.delete(eventMO)
            saveData()
        } else {
            // throw error that this Feeding Devent could not be found. This might be fatal
            fatalError("FeedingEventMO was not found in database")
        }
    }
}
