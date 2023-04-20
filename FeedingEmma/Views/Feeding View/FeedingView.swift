//
//  FeedingView.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/29/23.
//

import SwiftUI

struct FeedingView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: FeedingViewModel
        
    init(feedingToEdit: FeedingEvent? = nil) {
        _viewModel = StateObject(wrappedValue: FeedingViewModel(feedingToEdit: feedingToEdit))
    }
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
//                Color("Mint Green").ignoresSafeArea()
                
                VStack {
                    ScrollView {
                        VStack(spacing: 16) {
                            
                            CardView(title: "Start Time") {
                                HStack {
                                    Spacer()
                                    DatePicker("",
                                               selection: $viewModel.startTime,
                                               displayedComponents: [.date, .hourAndMinute]
                                    )
                                    .labelsHidden()
                                }
                            }
                            
                            CardView(title: "Feeding Type") {
                                Picker("Select Feeding Type", selection: $viewModel.feedingSource) {
                                    
                                    ForEach(FeedingSource.allCases, id: \.self) { condition in
                                        Text(condition.rawValue.capitalized)
                                            .tag(condition)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            
                            switch viewModel.feedingSource {
                            case .bottle, .solid:
                
                                VStack {

                                    TimerManualPicker(measurementMethod: $viewModel.measurementMethod)
                                    
                                    switch viewModel.measurementMethod {
                                    case .manual:
                                        endTimeView
                                    case .timer:
                                        TimerView(elapsedTime: $viewModel.elapsedTime, timeFormat: .minutesSeconds)
                                            .padding()
                                    }
                                }
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                                .padding(.vertical, 8)
                                
                            case .breast:
                                
                                VStack {

                                    TimerManualPicker(measurementMethod: $viewModel.measurementMethod)

                                    switch viewModel.measurementMethod {
                                    case .manual:
                                        endTimeView
                                    case .timer:
                                        breastTimeView
                                    }
                                }
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                                .padding(.vertical, 8)
                                
                            }
                            
                            if viewModel.feedingSource == .bottle {
                                CardView(title: "Nourishment") {
                                    Picker("Select Nourishment", selection: $viewModel.nourishment) {
                                        
                                        ForEach(Nourishment.allCases, id: \.self) { condition in
                                            Text(condition.rawValue.capitalized)
                                                .tag(condition)
                                        }
                                    }
                                    .pickerStyle(.segmented)
                                }
                                
                                CardView(title: "Amount") {
                                    
                                    switch UserDefaults.standard.measurementUnit {
                                    case .oz:
                                        
                                        VStack {
                                            Slider(value: $viewModel.amountOZ, in: 0...10, step: 0.1)

                                            HStack {
                                                Spacer()
                                                
                                                Text(String(format: "%.1f", viewModel.amountOZ) + " oz")
                                            }
                                        }
                                        
                                    case .ml:
                                        
                                        VStack {
                                            Slider(value: $viewModel.amountML, in: 0...300, step: 1)
                                            
                                            HStack {
                                                Spacer()
                                                
                                                Text("\(Int(viewModel.amountML)) ml")
                                            }
                                        }
                                        
                                    }
                                    
                                }
                            }
                            
                            if viewModel.feedingSource == .solid {
                                
                                CardView(title: "Amount") {
                                    VStack {
                                        Slider(value: $viewModel.amountTS, in: 0...10, step: 1)
                                        
                                        HStack {
                                            Spacer()
                                            
                                            Text("\(Int(viewModel.amountTS)) tablespoons")
                                        }
                                    }
                                }
        
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
            .navigationTitle("Feeding")
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
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
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
        .padding()
    }
    
    var breastTimeView: some View {
        HStack {
            TimerView(elapsedTime: $viewModel.elapsedLeftTime, timeFormat: .minutesSeconds)

            Divider()

            TimerView(elapsedTime: $viewModel.elapsedRightTime, timeFormat: .minutesSeconds)
        }
        .padding()
    }
}

struct FeedingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FeedingView()
                .previewDisplayName("Light Mode")
            
            FeedingView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}

struct TimerManualPicker: View {
    
    @Binding var measurementMethod: MeasurementMethod

    var body: some View {

        HStack {
            ForEach(MeasurementMethod.allCases, id: \.self) { state in
                Button {
                    measurementMethod = state
                } label: {
                    Text(state.rawValue.capitalized)
                        .tag(state)
                        .foregroundColor(state == measurementMethod ? .black : .gray)
                }
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        
    }
}
