//
//  FeedingEventMO+CoreDataProperties.swift
//  FeedingEmma
//
//  Created by Justin on 4/4/23.
//
//

import Foundation
import CoreData


extension FeedingEventMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedingEventMO> {
        return NSFetchRequest<FeedingEventMO>(entityName: "FeedingEventMO")
    }

    @NSManaged public var endTimestamp: Date?
    @NSManaged public var gramAmount: Float
    @NSManaged public var mlAmount: Float
    @NSManaged public var note: String?
    @NSManaged public var nourishment: String?
    @NSManaged public var source: String?
    @NSManaged public var rightSeconds: Double
    @NSManaged public var leftSeconds: Double

}
