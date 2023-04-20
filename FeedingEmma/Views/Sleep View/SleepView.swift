//
//  SleepView.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/29/23.
//

import SwiftUI

struct SleepView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel: SleepViewModel
    
    init(sleepToEdit: SleepEvent? = nil) {
        _viewModel = StateObject(wrappedValue: SleepViewModel(sleepToEdit: sleepToEdit))
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
//                Color("Lavender").ignoresSafeArea()
                
                VStack {
                    ScrollView {
                        VStack(spacing: 16) {
                            
                            CardView(title: "Start Time") {
                                HStack {
                                    Spacer()
                                    DatePicker(
                                        "",
                                        selection: $viewModel.startTime,
                                        displayedComponents: [.date, .hourAndMinute]
                                    )
                                    .labelsHidden()
                                }
                            }
                            
                            VStack {
                                TimerManualPicker(measurementMethod: $viewModel.measurementMethod)
                                
                                VStack {
                                    HStack {
                                        Text(viewModel.measurementMethod == .timer ? "Sleep Timer" : "End Time")
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.theme.textPrimary)

                                        Spacer()
                                    }
                                    
                                    switch viewModel.measurementMethod {
                                    case .manual:
                                        endTimeView
                                    case .timer:
                                        TimerView(elapsedTime: $viewModel.elapsedTime, timeFormat: .hoursMinutesSeconds)
                                    }
                        
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .cardBackground()
            
                            }

                            CardView(title: "Notes") {
                                TextField("", text: $viewModel.notes)
                            }

                            Spacer()
                        }
                        .padding()
                        
                        Spacer()
                    }
                    
                    CTAButton(title: "Save") {
                        self.viewModel.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Sleep")
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
    
    var endTimeView: some View {
        HStack {
            Spacer()
            DatePicker("",
                       selection: $viewModel.endTime,
                       displayedComponents: [.date, .hourAndMinute]
            )
            .labelsHidden()
        }
    }
}

struct SleepView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SleepView()
                .previewDisplayName("Light Mode")
            
            SleepView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
