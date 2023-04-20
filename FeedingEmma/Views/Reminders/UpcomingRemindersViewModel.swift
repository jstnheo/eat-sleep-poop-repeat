//
//  UpcomingRemindersViewModel.swift
//  FeedingEmma
//
//  Created by Justin on 4/17/23.
//

import Foundation
import Combine

class UpcomingRemindersViewModel: ObservableObject {
    @Published private var service: ReminderService
    
    @Published var todaysReminders: [Reminder] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(service: ReminderService = DataManager.shared) {
        self.service = service
        
        updateEvents()
    }
    
    private func updateEvents() {
        self.service.reminderPublisher
            .map { reminders in
                reminders.filter { reminder in
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year, .month, .day], from: reminder.dueDate)
                    let reminderDate = calendar.date(from: components)
                    let currentDate = calendar.startOfDay(for: Date())
                    
                    return reminderDate == currentDate
                }
            }
            .sink { [weak self] reminders in
                guard let strongSelf = self else { return }
                                
                DispatchQueue.main.async {
                    strongSelf.todaysReminders = reminders.compactMap { $0 }
                }
                
            }
            .store(in: &cancellables)
    }
}
