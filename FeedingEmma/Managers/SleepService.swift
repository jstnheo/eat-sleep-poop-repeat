//
//  SleepService.swift
//  FeedingEmma
//
//  Created by Justin on 4/10/23.
//

import Foundation
import CoreData

protocol SleepService {
    func create(_ event: SleepEvent)
    func update(_ event: SleepEvent)
    func delete(id: UUID)
}

extension DataManager: SleepService {
    func create(_ event: SleepEvent) {
        let eventMO = SleepEventMO(context: managedObjectContext)
        eventMO.id = event.id
        
        eventMO.timestamp = event.timestamp
        eventMO.endTimestamp = event.endTimestamp
        
        eventMO.note = event.note
        
        assignToBaby(eventMO)
        
        saveData()
    }
    
    func update(_ event: SleepEvent) {
        let request: NSFetchRequest<SleepEventMO> = SleepEventMO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", event.id as CVarArg)

        if let eventMO = try? managedObjectContext.fetch(request).first {

            eventMO.timestamp = event.timestamp
            eventMO.endTimestamp = event.endTimestamp
            
            eventMO.note = event.note

            saveData()

        } else {
            // throw error that this SleepEventMO could not be found. This might be fatal
            fatalError("SleepEventMO was not found in database")
        }
    }
    
    func delete(id: UUID) {
        let request: NSFetchRequest<SleepEventMO> = SleepEventMO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        if let eventMO = try? managedObjectContext.fetch(request).first {
            managedObjectContext.delete(eventMO)
            saveData()
        } else {
            // throw error that this SleepEventMO could not be found. This might be fatal
            fatalError("SleepEventMO was not found in database")
        }
    }
}
