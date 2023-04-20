//
//  DataManager.swift
//  FeedingEmma
//
//  Created by Justin on 4/3/23.
//

import Foundation
import CoreData
import Combine

enum DataManagerType {
    case testing
    case normal
    case preview
}

class DataManager: NSObject, ObservableObject {
    
    static let shared = DataManager(type: .normal)
    static let preview = DataManager(type: .preview)
    static let testing = DataManager(type: .testing)
    
    @Published var baby: BabyMO? //Maybe publish baby struct, maybe even keep this private?
    
    private let reminderSubject = CurrentValueSubject<[Reminder], Never>([])
    var reminderPublisher: AnyPublisher<[Reminder], Never> {
        return reminderSubject.eraseToAnyPublisher()
    }
    
    private let eventSubject = CurrentValueSubject<[any EventProtocol], Never>([])
    var eventsPublisher: AnyPublisher<[any EventProtocol], Never> {
        return eventSubject.eraseToAnyPublisher()
    }
    
    var managedObjectContext: NSManagedObjectContext
    
    private let eventsFRC: NSFetchedResultsController<EventMO>
    private let remindersFRC: NSFetchedResultsController<ReminderMO>
    
    private var cancellables: Set<AnyCancellable> = []
    
    weak var delegate: DataManagerDelegate?
    
    private init(type: DataManagerType) {
        switch type {
        case .normal:
            let persistentStore = PersistenceController()
            self.managedObjectContext = persistentStore.container.viewContext
        case .preview:
            let persistentStore = PersistenceController(inMemory: true)
            self.managedObjectContext = persistentStore.context
            
        case .testing:
            let persistentStore = PersistenceController(inMemory: true)
            self.managedObjectContext = persistentStore.context
        }
        
        
        let eventFR = EventMO.fetchRequest()
        eventFR.sortDescriptors = [NSSortDescriptor(keyPath: \EventMO.timestamp, ascending: false)]
        self.eventsFRC = NSFetchedResultsController(fetchRequest: eventFR,
                                                    managedObjectContext: managedObjectContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        
        let remindersFR = ReminderMO.fetchRequest()
        remindersFR.predicate = NSPredicate(format: "dueDate >= %@", Date() as NSDate)
        remindersFR.sortDescriptors = [NSSortDescriptor(keyPath: \ReminderMO.dueDate, ascending: true)]
        self.remindersFRC = NSFetchedResultsController(fetchRequest: remindersFR,
                                                       managedObjectContext: managedObjectContext,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: nil)
        
        super.init()
        
        // Initial fetch to populate array
        eventsFRC.delegate = self
        fetchEvents()
        
        remindersFRC.delegate = self
        fetchActiveReminders()
        
//        if type == .preview {
//            addMockData()
//            addMockReminders()
//        } else {
            checkOfAccountAndBabyCreate()
//        }
    }
    
    
    private func convert(_ eventMOs: [EventMO]) -> [any EventProtocol] {
        var eventsArray: [any EventProtocol] = []
        
        for event in eventMOs {
            switch event {
            case let diaperEvent as DiaperEventMO:
                eventsArray.append(diaperEvent.asStruct())
            case let feedingEvent as FeedingEventMO:
                eventsArray.append(feedingEvent.asStruct())
            case let sleepEvent as SleepEventMO:
                eventsArray.append(sleepEvent.asStruct())
            default:
                fatalError("Unexpected Type in Events")
            }
        }
        
        return eventsArray
    }
    
    private func checkOfAccountAndBabyCreate() {
        
        do {
            if let account = try managedObjectContext.fetch(AccountMO.fetchRequest()).first,
               let baby = account.babies?.allObjects.first as? BabyMO {
                
                print("Existng Account: \(String(describing: account.id))")
                print("Baby name: \(baby.name ?? "No Name")")
                
                self.baby = baby
                
            } else {
                print("New Account")
                let newAccount = AccountMO(context: managedObjectContext)
                newAccount.id = UUID()
                newAccount.serverId = nil
                newAccount.createDate = Date()
                
                let newBaby = BabyMO(context: managedObjectContext)
                newBaby.id = UUID()
                newBaby.name = "Emma"
                newBaby.serverId = nil
                newBaby.birthday = Date()
                newBaby.gender = "female"
                
                newAccount.addToBabies(newBaby)
                
                saveData()
            }
            
        } catch {
            print(error)
        }
        
    }
    
    func saveData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
    
    func assignToBaby(_ event: EventMO) {
        guard let baby = baby else {
            fatalError("Baby is missing")
        }
        
        baby.addToEvents(event)
    }
    
    func fetchActiveReminders() {
        
        try? remindersFRC.performFetch()
        
        if let fetchedReminders = remindersFRC.fetchedObjects {
            let reminderStructs = fetchedReminders.map { $0.asStruct() }
            self.reminderSubject.send(reminderStructs)
        }
    }
    
    func fetchEvents() {
        try? eventsFRC.performFetch()
        if let newEvents = eventsFRC.fetchedObjects {
            self.eventSubject.send(convert(newEvents))
        }
    }
    
    func updateSyncDate() {
        print("Update Sync Date")
    }
}

extension DataManager: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let newEvents = eventsFRC.fetchedObjects {
            self.eventSubject.send(convert(newEvents))
        } else if let reminders = remindersFRC.fetchedObjects {
            self.reminderSubject.send(reminders.map { $0.asStruct() })
        }
    }
}

