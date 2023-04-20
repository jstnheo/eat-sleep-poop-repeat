//
//  UserMO+CoreDataProperties.swift
//  FeedingEmma
//
//  Created by Justin on 4/3/23.
//
//

import Foundation
import CoreData


extension UserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "UserMO")
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastName: String?
    @NSManaged public var serverId: String?

}

extension UserMO : Identifiable {

}
