//
//  Baby.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/31/23.
//

import Foundation
import CoreData

struct Baby {
    var id: UUID
    
    var serverId: String?
        
    var birthday: Date?
    var firstName: String?
    var lastName: String?
    var gender: Gender
    
    var events: [any EventProtocol]
    
    init(id: UUID,
         serverId: String?,
         
         birthday: Date?,
         firstName: String?,
         lastName: String?,
         gender: Gender,
         events: [any EventProtocol]) {
        
        self.id = id
        
        self.serverId = serverId
        
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
        self.gender = gender
        
        self.events = events
    }
    
    init(firstName: String) {
        self.id = UUID()
        self.firstName = firstName
        self.birthday = Date() 
        self.gender = .unknown
        self.events = []
    }
}
