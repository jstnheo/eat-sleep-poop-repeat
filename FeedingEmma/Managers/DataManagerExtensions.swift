//
//  DataManagerExtensions.swift
//  FeedingEmma
//
//  Created by Justin on 4/3/23.
//

import Foundation
import CoreData

// Mock Data for Previews

extension DataManager {
    func addMockData() {
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
        
        let diaperEvent = DiaperEventMO(context: managedObjectContext)
        diaperEvent.id = UUID()
        diaperEvent.timestamp = Date()
        diaperEvent.serverId = nil
        diaperEvent.messRating = Int16(4)
        diaperEvent.condition = "wet"
        diaperEvent.note = "Hello World"
        
        newBaby.addToEvents(diaperEvent)
        
        let diaperEvent1 = DiaperEventMO(context: managedObjectContext)
        diaperEvent1.id = UUID()
        diaperEvent1.timestamp = Date().subtractRandomInterval()
        diaperEvent1.serverId = nil
        diaperEvent1.messRating = Int16(2)
        diaperEvent1.condition = "dirty"
        diaperEvent1.note = nil
        
        newBaby.addToEvents(diaperEvent1)
        
        let diaperEvent2 = DiaperEventMO(context: managedObjectContext)
        diaperEvent2.id = UUID()
        diaperEvent2.timestamp = Date().subtractRandomInterval()
        diaperEvent2.serverId = nil
        diaperEvent2.messRating = Int16(8)
        diaperEvent2.condition = "both"
        diaperEvent2.note = "Hello World!!! this is a note"
        
        newBaby.addToEvents(diaperEvent2)
        
        let feedEvent = FeedingEventMO(context: managedObjectContext)
        feedEvent.id = UUID()
        feedEvent.timestamp = Date().subtractRandomInterval()
        feedEvent.serverId = nil
        feedEvent.source = "bottle"
        feedEvent.endTimestamp = Date().subtractRandomInterval().addRandomInterval()
        feedEvent.nourishment = "formula"
        feedEvent.note = nil
        
        newBaby.addToEvents(feedEvent)
        
        let date1 = Date().subtractRandomInterval()
        let sleepEvent = SleepEventMO(context: managedObjectContext)
        sleepEvent.id = UUID()
        sleepEvent.timestamp = date1
        sleepEvent.endTimestamp = date1.addRandomInterval()
        sleepEvent.note = "This is another note."
        
        newBaby.addToEvents(sleepEvent)
        
        let date2 = Date().subtractRandomInterval()
        let sleepEvent1 = SleepEventMO(context: managedObjectContext)
        sleepEvent1.id = UUID()
        sleepEvent1.timestamp = date2
        sleepEvent1.endTimestamp = date2.addRandomInterval()
        sleepEvent1.note = nil
        
        newBaby.addToEvents(sleepEvent1)
        
        saveData()
    }
    
    func addMockReminders() {
        
        //        let reminder = ReminderMO(context: managedObjectContext)
        //        reminder.dueDate = Date().addDay()
        //        reminder.type = "feed"
        //        reminder.recurring = true
        //
        //        let reminder1 = ReminderMO(context: managedObjectContext)
        //        reminder1.dueDate = Date().addMinutes(10)
        //        reminder1.type = "sleep"
        //        reminder1.recurring = false
        
        saveData()
    }
    
}

struct SampleData {
    var sleepEvents: [SleepEvent] = []
    var feedingEvents: [FeedingEvent] = []
    var diaperEvents: [DiaperEvent] = []

    let startDate = Date(timeIntervalSince1970: 1649088000)
    let endDate = Date(timeIntervalSince1970: 1670640000)
    let numberOfDays: Int

    init() {
    
        numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!
    
        for _ in 0..<numberOfDays {
            for _ in 0..<Int.random(in: 3...5) {
                sleepEvents.append(createRandomSleepEvent())
                feedingEvents.append(createRandomFeedingEvent())
                diaperEvents.append(createRandomDiaperEvent())
            }
        }
    }
    
    func createRandomSleepEvent() -> SleepEvent {
        let id = UUID()
        let timestamp = Date(timeIntervalSince1970: Double.random(in: 1649088000...1670640000))
        let endTimestamp = Date(timeInterval: Double.random(in: 0...18000), since: timestamp)
        let note = Bool.random() ? "Good night sleep" : nil
        
        return SleepEvent(id: id, serverId: nil, timestamp: timestamp, endTimestamp: endTimestamp, note: note)
    }
    
    func createRandomFeedingEvent() -> FeedingEvent {
        let id = UUID()
        let timestamp = Date(timeIntervalSince1970: Double.random(in: 1649088000...1670640000))
        let endTimestamp = Date(timeInterval: Double.random(in: 0...3600), since: timestamp)
        let leftSeconds = Int.random(in: 120...3600)
        let rightSeconds = Int.random(in: 120...3600)
        let gAmount = Float.random(in: 50...150)
        let mlAmount = Float.random(in: 30...100)
        let source = FeedingSource.allCases.randomElement()!
        let nourishment = Nourishment.allCases.randomElement()!
        let note = Bool.random() ? "He drank well" : nil
        
        return FeedingEvent(id: id, serverId: nil, timestamp: timestamp, endTimestamp: endTimestamp, leftSeconds: TimeInterval(leftSeconds), rightSeconds: TimeInterval(rightSeconds), gAmount: gAmount, mlAmount: mlAmount, source: source, nourishment: nourishment, note: note)
    }
    
    
    func createRandomDiaperEvent() -> DiaperEvent {
        let id = UUID()
        let timestamp = Date(timeIntervalSince1970: Double.random(in: 1649088000...1670640000))
        let condition = DiaperCondition.allCases.randomElement()!
        let messRating = Int.random(in: 1...5)
        let note = Bool.random() ? "Lots of mess" : nil
        
        return DiaperEvent(id: id, serverId: nil, timestamp: timestamp, condition: condition, messRating: messRating, note: note)
    }
    
}
