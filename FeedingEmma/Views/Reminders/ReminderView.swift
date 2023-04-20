//
//  RemindersView.swift
//  FeedingEmma
//
//  Created by Justin on 4/4/23.
//

import SwiftUI

struct ReminderView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: RemindersViewModel
        
    init(reminderToEdit: Reminder? = nil) {
        self._viewModel = StateObject(wrappedValue: RemindersViewModel(reminderToEdit: reminderToEdit))
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                ScrollView {
                    VStack(spacing: 16) {
                        
                        VStack {
                            HStack {
                                Text("Time")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.theme.textPrimary)

                                Spacer()
                            }
                            
                            HStack {
                                Spacer()
                                
                                DatePicker(
                                    "",
                                    selection: $viewModel.triggerDate,
                                    displayedComponents: [.date, .hourAndMinute]
                                )
                                .labelsHidden()
                            }
                
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .cardBackground()
                        
                        Toggle(isOn: $viewModel.isRecurring) {
                            Text("Repeat Daily")
                                .fontWeight(.bold)
                                .foregroundColor(Color.theme.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .cardBackground()
                        
                        
                        VStack {
                            
                            HStack {
                                Text("Reminder Type")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.theme.textPrimary)
                                Spacer()
                            }
                            
        
                            Picker("Select Reminder Type", selection: $viewModel.type) {
                                ForEach(EventType.allCases, id: \.self) { event in
                                    Text(event.rawValue.capitalized)
                                        .tag(event)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding()
                        .cardBackground()
                        
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                }
                
                CTAButton(title: "Save") {
                    viewModel.save()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Reminder")
            .foregroundColor(Color.theme.remindersPrimary)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Close")
                            .foregroundColor(Color.icon)
                    }
                }
                
                if viewModel.isEditMode {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.delete()
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Delete")
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
            }
        }
    }
}

struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView()
    }
}
