//
//  SyncManager.swift
//  FeedingEmma
//
//  Created by Justin on 4/11/23.
//

import Foundation

class SyncManager {
    private let dataManager: DataManager
    private let networkManager: NetworkManager
    
    init(dataManager: DataManager, networkManager: NetworkManager) {
        self.dataManager = dataManager
        self.networkManager = networkManager
        
        self.dataManager.delegate = self
    }

    // Sync methods will be added here
}

extension SyncManager: DataManagerDelegate {
    func dataManager(_ dataManager: DataManager, didSaveEvents events: [any EventProtocol]) {
        
        print("did save event \(events)")
        
        dataManager.updateSyncDate()
    }
    
    func dataManager(_ dataManager: DataManager, didUpdateEvents events: [any EventProtocol]) {
        print("did update event \(events)")
        
        dataManager.updateSyncDate()
    }
    
    func dataManager(_ dataManager: DataManager, didDeleteEvents serverIds: [String]) {
        
    }
    
}

extension SyncManager: NetworkManagerDelegate {
    func networkUpdate() {
        // we just pulled all the events and then parse then into EventProtocol
        // firebase items
        
        // let coreDataIdentifiers = self.dataManager.fetchAllEventIdentifiers()
        
        // let newItems = firebaseItems.filter { !coreDataIdentifiers.contains($0.identifier) }

    }
}

protocol DataManagerDelegate: AnyObject {
    func dataManager(_ dataManager: DataManager, didSaveEvents events: [any EventProtocol])
    func dataManager(_ dataManager: DataManager, didUpdateEvents events: [any EventProtocol])
    func dataManager(_ dataManager: DataManager, didDeleteEvents serverIds: [String])
    
//    func dataManager(_ dataManager: DataManager, didCreate serverIds: [String])
//    func dataManager(_ dataManager: DataManager, didDeleteEvents serverIds: [String])
//    func dataManager(_ dataManager: DataManager, didDeleteEvents serverIds: [String])

}

protocol NetworkManagerDelegate: AnyObject {
    
}
