//
//  ContentView.swift
//  FeedingEmma
//
//  Created by Justin on 4/2/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false

    var body: some View {
        
        if logStatus {
            Text("Main View")
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Tab: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var tabName: String
    var tabColor: Color
}

var sampleTabs: [Tab] = [
    .init(tabName: "Today", tabColor: .green),
    .init(tabName: "Charts", tabColor: .yellow)
]
