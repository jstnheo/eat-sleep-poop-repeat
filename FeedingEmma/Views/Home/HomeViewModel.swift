//
//  HomeViewModel.swift
//  FeedingEmma
//
//  Created by Justin on 4/10/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var babyName: String = "Emma"
    
    init() {
        babyName = UserDefaults.standard.babyName
    }
    
    @Published var summaries: [DaySummary] = [
        DaySummary(title: "This is for Food",
                   date: Date(),
                   cardColor: .blue,
                   type: .feeding),
        DaySummary(title: "This is for Diapers",
                   date: Date(),
                   cardColor: .blue,
                   type: .diaper),
        DaySummary(title: "This is for Sleep",
                   date: Date(),
                   cardColor: .blue,
                   type: .sleep),
        DaySummary(title: "This is for Reminders",
                   date: Date(),
                   cardColor: .blue,
                   type: .diaper),
        
    ]
}
