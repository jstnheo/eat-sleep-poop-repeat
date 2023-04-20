//
//  SettingsView.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/30/23.
//

import SwiftUI

enum MeasurementUnit: String, CaseIterable {
    case ml
    case oz
}

enum MeasurementMethod: String, CaseIterable {
    case manual
    case timer
}


class SettingView: ObservableObject {
    @Published var measurementMethod = UserDefaults.standard.measurementMethod
    @Published var measurementUnit = UserDefaults.standard.measurementUnit
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = SettingView()
    
    @AppStorage("babyName") var babyName: String = "Emma"
    
    var body: some View {
        NavigationView {
            List {
                
                Section("Baby's Name") {
                    TextField("Emma", text: $babyName)
                        .onChange(of: babyName) { newValue in
                            babyName = newValue
                        }
                }
                
                Section("Defaults") {
                    
                    Picker("Timing", selection: $viewModel.measurementMethod) {
                        
                        ForEach(MeasurementMethod.allCases, id: \.self) { method in
                            Text(method.rawValue)
                                .tag(method)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: viewModel.measurementMethod) { newValue in
                        
                        UserDefaults.standard.measurementMethod = newValue
                        
                    }
                    
                    Picker("Unit", selection: $viewModel.measurementUnit) {
                        
                        ForEach(MeasurementUnit.allCases, id: \.self) { condition in
                            Text(condition.rawValue)
                                .tag(condition)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: viewModel.measurementUnit) { newValue in
                        
                        UserDefaults.standard.measurementUnit = newValue
                        
                    }
                    
                }
                
                Button {
                    print("export")
                } label: {
                    Text("Export Data")
                }
                
                Button {
                    print("export")
                } label: {
                    Text("Delete All Reminders")
                }
                
                Button {
                    print("delete")
                    
                    // Delete CoreData
                    // Reset User Defaults
                    // Cancel all scheduled notificaitons
                } label: {
                    Text("Delete All Data")
                        .foregroundColor(Color(.systemRed))
                }
                
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Close")
                            .foregroundColor(Color.icon)
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
