//
//  ReminderMO+CoreDataProperties.swift
//  FeedingEmma
//
//  Created by Justin on 4/4/23.
//
//

import Foundation
import CoreData


extension ReminderMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReminderMO> {
        return NSFetchRequest<ReminderMO>(entityName: "ReminderMO")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var recurring: Bool
    @NSManaged public var type: String?
    @NSManaged public var dueDate: Date?

}

extension ReminderMO : Identifiable {

}
