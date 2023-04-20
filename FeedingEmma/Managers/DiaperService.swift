//
//  DiaperService.swift
//  FeedingEmma
//
//  Created by Justin on 4/10/23.
//

import Foundation
import CoreData

protocol DiaperService {
    func createDiaperEvent(_ event: DiaperEvent)
    func updateDiaperEvent(_ event: DiaperEvent)
    func deleteDiaperEvent(id: UUID)
}

extension DataManager: DiaperService {
    
    func createDiaperEvent(_ event: DiaperEvent) {
        let eventMO = DiaperEventMO(context: managedObjectContext)
        eventMO.id = event.id
        eventMO.timestamp = event.timestamp
        eventMO.condition = event.condition.rawValue
        eventMO.messRating = Int16(event.messRating)
        eventMO.note = event.note
        
        assignToBaby(eventMO)
        
        saveData()
    }
    
    func updateDiaperEvent(_ event: DiaperEvent) {
        let request: NSFetchRequest<DiaperEventMO> = DiaperEventMO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", event.id as CVarArg)
        
        if let eventMO = try? managedObjectContext.fetch(request).first {
            eventMO.timestamp = event.timestamp
            eventMO.condition = event.condition.rawValue
            eventMO.messRating = Int16(event.messRating)
            eventMO.note = event.note

            saveData()
            
        } else {
            // throw error that this DiaperEventMO could not be found. This might be fatal
            fatalError("DiaperEventMO was not found in database")
        }
    }
    
    func deleteDiaperEvent(id: UUID) {
        let request: NSFetchRequest<DiaperEventMO> = DiaperEventMO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let event = try? managedObjectContext.fetch(request).first {
            managedObjectContext.delete(event)
            saveData()
        } else {
            // throw error that this Diaper could not be found. This might be fatal
            fatalError("DiaperEventMO was not found in database")
        }
    }
}
