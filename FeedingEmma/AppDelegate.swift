//
//  AppDelegate.swift
//  FeedingEmma
//
//  Created by Justin on 4/4/23.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    let dataManager = DataManager.shared
    let networkManager = NetworkManager.shared
    let pushNotifManager = PushNotificationManager.shared
    
    var syncManager: SyncManager!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Did Finish Launching!")
                
        pushNotifManager.notificationCenter.delegate = self
        
        syncManager = SyncManager(dataManager: dataManager, networkManager: networkManager)
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                
        completionHandler([.banner, .sound, .badge])
    }
}
