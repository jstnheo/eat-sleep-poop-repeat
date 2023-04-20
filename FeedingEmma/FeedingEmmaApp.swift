//
//  FeedingEmmaApp.swift
//  FeedingEmma
//
//  Created by Justin on 4/2/23.
//

import SwiftUI

@main
struct FeedingEmmaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("log_status") var logStatus: Bool = false

    var body: some Scene {
        WindowGroup {
           
            HomeView()
            
//            ChartsView()
            
        }
    }
}

