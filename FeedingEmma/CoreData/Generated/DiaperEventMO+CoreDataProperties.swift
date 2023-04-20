//
//  DiaperEventMO+CoreDataProperties.swift
//  FeedingEmma
//
//  Created by Justin on 4/3/23.
//
//

import Foundation
import CoreData


extension DiaperEventMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaperEventMO> {
        return NSFetchRequest<DiaperEventMO>(entityName: "DiaperEventMO")
    }

    @NSManaged public var condition: String?
    @NSManaged public var messRating: Int16
    @NSManaged public var note: String?

}
