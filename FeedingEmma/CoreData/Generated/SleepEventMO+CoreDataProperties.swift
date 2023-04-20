//
//  SleepEventMO+CoreDataProperties.swift
//  FeedingEmma
//
//  Created by Justin on 4/3/23.
//
//

import Foundation
import CoreData


extension SleepEventMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SleepEventMO> {
        return NSFetchRequest<SleepEventMO>(entityName: "SleepEventMO")
    }

    @NSManaged public var endTimestamp: Date?
    @NSManaged public var note: String?

}
