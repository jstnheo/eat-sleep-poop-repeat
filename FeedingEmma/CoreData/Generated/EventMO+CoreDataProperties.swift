//
//  EventMO+CoreDataProperties.swift
//  FeedingEmma
//
//  Created by Justin on 4/3/23.
//
//

import Foundation
import CoreData


extension EventMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventMO> {
        return NSFetchRequest<EventMO>(entityName: "EventMO")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var serverId: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var baby: BabyMO?

}

extension EventMO : Identifiable {

}
