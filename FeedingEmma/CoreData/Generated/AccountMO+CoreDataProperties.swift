//
//  AccountMO+CoreDataProperties.swift
//  FeedingEmma
//
//  Created by Justin on 4/3/23.
//
//

import Foundation
import CoreData


extension AccountMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountMO> {
        return NSFetchRequest<AccountMO>(entityName: "AccountMO")
    }

    @NSManaged public var createDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var serverId: String?
    @NSManaged public var babies: NSSet?

}

// MARK: Generated accessors for babies
extension AccountMO {

    @objc(addBabiesObject:)
    @NSManaged public func addToBabies(_ value: BabyMO)

    @objc(removeBabiesObject:)
    @NSManaged public func removeFromBabies(_ value: BabyMO)

    @objc(addBabies:)
    @NSManaged public func addToBabies(_ values: NSSet)

    @objc(removeBabies:)
    @NSManaged public func removeFromBabies(_ values: NSSet)

}

extension AccountMO : Identifiable {

}
