//
//  BabyMO+CoreDataProperties.swift
//  FeedingEmma
//
//  Created by Justin on 4/3/23.
//
//

import Foundation
import CoreData


extension BabyMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BabyMO> {
        return NSFetchRequest<BabyMO>(entityName: "BabyMO")
    }

    @NSManaged public var birthday: Date?
    @NSManaged public var gender: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var serverId: String?
    @NSManaged public var account: AccountMO?
    @NSManaged public var events: NSSet?

}

// MARK: Generated accessors for events
extension BabyMO {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: EventMO)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: EventMO)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

extension BabyMO : Identifiable {

}
