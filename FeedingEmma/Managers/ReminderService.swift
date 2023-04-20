//
//  ReminderService.swift
//  FeedingEmma
//
//  Created by Justin on 4/10/23.
//

import Foundation
import CoreData
import Combine

protocol ReminderService {
    var reminderPublisher: AnyPublisher<[Reminder], Never> { get }

    func createReminder(dueDate: Date, type: EventType, isRecurring: Bool) -> UUID
    func editReminder(id: UUID, dueDate: Date, type: EventType, isRecurring: Bool)
    func deleteReminder(id: UUID)
    func rescheduleAndCleanReminders()
    func fetchReminderActivity() -> [Reminder]
}

extension DataManager: ReminderService {

    func createReminder(dueDate: Date, type: EventType, isRecurring: Bool) -> UUID {
        let id = UUID()
        
        let reminderMO = ReminderMO(context: managedObjectContext)
        reminderMO.id = id
        reminderMO.dueDate = dueDate
        reminderMO.type = type.rawValue
        reminderMO.recurring = isRecurring
        
        saveData()
        fetchActiveReminders()
        
        return id
    }
    
    func editReminder(id: UUID, dueDate: Date, type: EventType, isRecurring: Bool) {
        let request: NSFetchRequest<ReminderMO> = ReminderMO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let reminderMO = try? managedObjectContext.fetch(request).first {
            reminderMO.dueDate = dueDate
            reminderMO.type = type.rawValue
            reminderMO.recurring = isRecurring

            saveData()
            fetchActiveReminders()

        } else {
            // throw error that this reminder could not be found. This might be fatal
            fatalError("Reminder was not found in database")
        }
    }
    
    func deleteReminder(id: UUID) {
        let request: NSFetchRequest<ReminderMO> = ReminderMO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let reminderMO = try? managedObjectContext.fetch(request).first {
            managedObjectContext.delete(reminderMO)
            saveData()
            fetchActiveReminders()
        } else {
            // throw error that this reminder could not be found. This might be fatal
            fatalError("Reminder was not found in database")
        }
    }
    
    /**
     Checks for reminders that have a due date that is older than or equal to the current date and time, and deletes them if they are not recurring. If a reminder is recurring, its due date is updated using the `calculateNewDueDate` function.

     This function assumes that the reminders are managed by a Core Data managed object context, and that the active reminders are stored in the `activeReminders` array. After the function completes, it saves the changes to the managed object context and refetches the active reminders.
    */
    func rescheduleAndCleanReminders() {
        // Older Reminders
        let request: NSFetchRequest<ReminderMO> = ReminderMO.fetchRequest()
        request.predicate = NSPredicate(format: "dueDate =< %@", Date() as NSDate)
        
        do {
    
            for reminderMO in try managedObjectContext.fetch(request) {
                if reminderMO.recurring {
                    reminderMO.dueDate = Reminder.calculateNewDueDate(dueDate: reminderMO.dueDate ?? Date())
                } else {
                    if let uuidString = reminderMO.id?.uuidString {
                        PushNotificationManager.shared.cancelNotification(identifier: uuidString)
                    }
                    managedObjectContext.delete(reminderMO)
                }
            }
            
            saveData()
            fetchActiveReminders()
            
        } catch {
            print("Error fetching reminder by ID: \(error.localizedDescription)")
        }
    }
    
    func fetchReminderActivity() -> [Reminder] {
        let request: NSFetchRequest<ReminderMO> = ReminderMO.fetchRequest()
        let today = Date()
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: today)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
        let predicate = NSPredicate(format: "endTimestamp >= %@ AND endTimestamp < %@", startDate as NSDate, endDate! as NSDate)
        request.predicate = predicate

        do {
            let results = try managedObjectContext.fetch(request)
            return results.map { $0.asStruct() }
        } catch let error as NSError {
            // handle the error
            fatalError("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}
