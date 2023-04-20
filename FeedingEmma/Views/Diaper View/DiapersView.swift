//
//  DiapersView.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/29/23.
//

import SwiftUI
import Combine

struct DiapersView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: DiapersViewModel
  
    init(diaperToEdit: DiaperEvent? = nil) {
        _viewModel = StateObject(wrappedValue: DiapersViewModel(diaperToEdit: diaperToEdit))
    }
    
    var body: some View {
        NavigationView {
            
            ZStack {
//                Color("Baby Blue").ignoresSafeArea()
                
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
                            
                            CardView(title: "Diaper Condition") {
                                Picker("Select Diaper Condition", selection: $viewModel.diaperCondition) {
                                    
                                    ForEach(DiaperCondition.allCases, id: \.self) { condition in
                                        Text(condition.rawValue.capitalized)
                                            .tag(condition)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            
                            CardView(title: "Messiness Rating") {
                                    
                                Slider(value: $viewModel.messyRating, in: 0...10, step: 1)

                                HStack {
                                    Spacer()
                                    
                                    Text("\(Int(viewModel.messyRating)) mess")
                                        .foregroundColor(.gray)

                                }
                            }
                            
                            CardView(title: "Notes") {
                                TextField("", text: $viewModel.notes)
                            }

                            Spacer()
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    
                    CTAButton(title: "Save") {
                        self.viewModel.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }

                }
            }
            .navigationTitle("Diapers")
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

struct DiapersView_Previews: PreviewProvider {
    static var previews: some View {
        DiapersView()
    }
}
