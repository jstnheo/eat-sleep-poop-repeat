//
//  ActiveRemindersViewModel.swift
//  FeedingEmma
//
//  Created by Justin on 4/6/23.
//

import Foundation
import Combine

class ActiveRemindersViewModel: ObservableObject {
    @Published private var service: ReminderService
    
    private var cancellables: Set<AnyCancellable> = []

    @Published var remindersByDate: [Date: [Reminder]] = [:]
    
    init(service: ReminderService = DataManager.shared) {
        self.service = service
        
        // Subscribe to changes in the reminder array
        self.service.reminderPublisher
               .map { reminders in
                   Dictionary(grouping: reminders) { reminder in
                       Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: reminder.dueDate))!
                   }
               }
               .assign(to: \.remindersByDate, on: self)
               .store(in: &cancellables)
        
        self.service.rescheduleAndCleanReminders()
    }
    
    func deleteReminder(at offsets: IndexSet, date: Date) {
        let indexes = offsets.map { $0 }
        let remindersToDelete = indexes.map { remindersByDate[date]![$0] }
        
        for reminder in remindersToDelete {
            service.deleteReminder(id: reminder.id)
        }
    }
}
