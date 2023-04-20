//
//  UpcomingRemindersView.swift
//  FeedingEmma
//
//  Created by Justin on 4/16/23.
//

import SwiftUI

struct UpcomingRemindersView: View {
    
    @StateObject var viewModel = UpcomingRemindersViewModel()
    
    var body: some View {
        
        VStack(spacing: 16) {
            HStack {
                
                Label("Upcoming Reminders", systemImage: "alarm")
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.remindersPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 8, height: 12)
                    .foregroundColor(Color.theme.textSecondary)
            }
            
            if viewModel.todaysReminders.isEmpty {
                                
                Spacer()
                
                Text("No Reminders Today")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.textSecondary)
                    .padding(.bottom, 12)
                
                Spacer()
                
            } else {
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    ForEach(viewModel.todaysReminders, id: \.id) {
                        reminder in
                        
                        HStack {
                            Label(reminder.dueDate.time(), systemImage: "alarm")
                                .font(.body)
                                .foregroundColor(Color.theme.textSecondary)
                            
                            Spacer()
                            
                            Text(reminder.type.rawValue.capitalized)
                                .font(.body)
                                .foregroundColor(Color.theme.textSecondary)
                        }
                    }
                }
            }
        }
        .padding()
        
    }
}

struct UpcomingRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingRemindersView()
    }
}
