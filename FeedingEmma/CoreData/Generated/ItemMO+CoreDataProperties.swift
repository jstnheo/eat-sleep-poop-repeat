//
//  ItemMO+CoreDataProperties.swift
//  FeedingEmma
//
//  Created by Justin on 4/3/23.
//
//

import Foundation
import CoreData


extension ItemMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemMO> {
        return NSFetchRequest<ItemMO>(entityName: "ItemMO")
    }

    @NSManaged public var timestamp: Date?

}

extension ItemMO : Identifiable {

}
