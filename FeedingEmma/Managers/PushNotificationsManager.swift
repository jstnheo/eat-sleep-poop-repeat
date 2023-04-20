//
//  PushNotificationsManager.swift
//  FeedingEmma
//
//  Created by Justin on 4/6/23.
//

import Foundation
import UserNotifications

class PushNotificationManager {
    
    static let shared = PushNotificationManager()
        
    let notificationCenter = UNUserNotificationCenter.current()

    private init() {}

    
    // Request authorization to display local notifications
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    // Schedule a new local notification
    func scheduleNotification(identifier: String, title: String, body: String, date: Date, repeats: Bool) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    // Edit an existing local notification
    func editNotification(identifier: String, title: String, body: String, date: Date, repeats: Bool) {
        // Cancel the existing notification
        cancelNotification(identifier: identifier)
        
        // Schedule a new notification with updated details
        scheduleNotification(identifier: identifier, title: title, body: body, date: date, repeats: repeats)
    }
    
    // Cancel a pending local notification
    func cancelNotification(identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    // Cancel all pending local notifications
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
