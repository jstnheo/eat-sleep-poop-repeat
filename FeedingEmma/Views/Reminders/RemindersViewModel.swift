//
//  RemindersViewModel.swift
//  FeedingEmma
//
//  Created by Justin on 4/4/23.
//

import Foundation
import Combine

class RemindersViewModel: ObservableObject {
    @Published private var service: ReminderService
    
    @Published var triggerDate = Date().addMinutes(5)    
    @Published var isRecurring = false
    @Published var type: EventType = .feeding
    
    var reminderToEdit: Reminder?
    var isEditMode: Bool {
        return reminderToEdit != nil 
    }
        
    init(service: ReminderService = DataManager.shared, reminderToEdit: Reminder? = nil) {
        self.service = service
        self.reminderToEdit = reminderToEdit

        if let reminderToEdit = reminderToEdit {
            triggerDate = reminderToEdit.dueDate
            isRecurring = reminderToEdit.isRecurring
        }
        
        PushNotificationManager.shared.requestAuthorization()
    }
    
    func save() {
        if let reminderToEdit = reminderToEdit {
            
            service.editReminder(id: reminderToEdit.id,
                                     dueDate: triggerDate,
                                     type: type,
                                     isRecurring: isRecurring)
            
            PushNotificationManager.shared.editNotification(identifier: reminderToEdit.id.uuidString,
                                                            title: "Reminder",
                                                            body: "It's time for your reminder",
                                                            date: triggerDate,
                                                            repeats: isRecurring)
            
        } else {
            let reminderId = service.createReminder(dueDate: triggerDate,
                                                      type: type,
                                                      isRecurring: isRecurring)
            
            PushNotificationManager.shared.scheduleNotification(identifier: reminderId.uuidString,
                                                                title: "Reminder",
                                                                body: "It's time for your reminder",
                                                                date: triggerDate,
                                                                repeats: isRecurring)
        }
    }
    
    func delete() {
        guard let reminderToEdit = reminderToEdit else { return }
        
        PushNotificationManager.shared.cancelNotification(identifier: reminderToEdit.id.uuidString)
        
        service.deleteReminder(id: reminderToEdit.id)
        
    }
}
