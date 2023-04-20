//
//  AccountStruct.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 4/1/23.
//

import Foundation
import CoreData

struct Account {
    var id: UUID
    var createDate: Date
    var serverId: String?
    
    var babies: [Baby]
    
    init(id: UUID,
         createDate: Date,
         serverId: String?,
         babies: [Baby]) {
        
        self.id = id
        self.createDate = createDate
        
        self.serverId = serverId
        
        self.babies = babies
    }
    
    init() {
        self.id = UUID()
        self.createDate = Date()
        self.babies = [] 
    }
}

//extension Account: Structable {    
//    func asStruct() -> AccountStruct {
//        // Required Attributes
//        guard let id = self.id,
//              let createDate = self.createDate else {
//            fatalError("Missing required attributes in Account")
//        }
//        
//        let serverId = self.serverId
//        
//        let babySet = self.babies?.allObjects as? [Baby] ?? []
//        let babyStructs = babySet.map { $0.asStruct() }
//        
//        return AccountStruct(id: id,
//                             createDate: createDate,
//                             serverId: serverId,
//                             babies: babyStructs)
//    }
//}


//extension Account {
//    convenience init(accountStruct: AccountStruct, context: NSManagedObjectContext) {
//         self.init(entity: Account.entity(), insertInto: context)
//         self.id = accountStruct.id
//         self.createDate = accountStruct.createDate
//         self.serverId = accountStruct.serverId
//         let babyEntities = accountStruct.babies.map { Baby(babyStruct: $0, context: context) }
//         self.babies = NSSet(array: babyEntities)
//     }
//}
