//
//  HistoryService.swift
//  FeedingEmma
//
//  Created by Justin on 4/10/23.
//

import Foundation
import Combine
import CoreData

protocol HistoryService {
    var eventsPublisher: AnyPublisher<[any EventProtocol], Never> { get }
    func deleteHistoryEvent(id: UUID)
}

extension DataManager: HistoryService {
    
    func deleteHistoryEvent(id: UUID) {
        let request: NSFetchRequest<EventMO> = EventMO.fetchRequest()
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
