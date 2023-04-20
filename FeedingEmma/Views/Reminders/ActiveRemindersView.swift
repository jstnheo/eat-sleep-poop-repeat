//
//  ActiveRemindersView.swift
//  FeedingEmma
//
//  Created by Justin on 4/6/23.
//

import SwiftUI

struct ActiveRemindersView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel = ActiveRemindersViewModel()
    @State var reminderToEdit: Reminder? = nil
    
    var body: some View {
        
        Group {
            if viewModel.remindersByDate.keys.isEmpty {
                
                VStack {
                    VStack(spacing: 10) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color(.systemTeal))
                            .cornerRadius(30)
                        
                        Text("Tap the + button on the Home screen to add reminders.")
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cardBackground()
                    .padding()
                    
                    Spacer()
                }
                
            } else {
                List {
                    ForEach(viewModel.remindersByDate.keys.sorted(), id: \.self) { date in
                        Section(header: Text(dateFormatter.string(from: date))) {
                            ForEach(viewModel.remindersByDate[date] ?? []) { reminder in
                                HStack {
                                    Image(systemName: reminder.isRecurring ? "repeat" : "calendar")
                                        .foregroundColor(.blue)
                                    VStack(alignment: .leading) {
                                        Text(reminder.type.rawValue)
                                            .font(.headline)
                                        Text("\(reminder.dueDate, formatter: timeFormatter)")
                                            .font(.subheadline)
                                    }
                                }
                                .onTapGesture {
                                    reminderToEdit = reminder
                                }
                            }
                            .onDelete { indexes in
                                viewModel.deleteReminder(at: indexes, date: date)
                            }

                        }
                    }
                }
            }
        }
        .navigationTitle("Reminders")
        .navigationBarHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.icon, .primary)
                }
            }
        }
        
        .sheet(item: $reminderToEdit) { reminder in
            ReminderView(reminderToEdit: reminder)
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}


struct ActiveRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveRemindersView()
    }
}
