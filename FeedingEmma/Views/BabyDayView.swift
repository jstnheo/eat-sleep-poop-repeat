//
//  BabyDayView.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/30/23.
//

import SwiftUI

struct BabyDayView: View {
    
    @State var isToday: Bool = true
    
    @State private var scrollOffset: CGFloat = 0
    @State var feedingAction: Bool = false
    @State var sleepAction: Bool = false
    @State var diaperAction: Bool = false
    @State var reminderAction: Bool = false
    @State var showSettings: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                ScrollView {
                    
                    VStack {
                        
                        
                        HStack {
                            Text("Emma")
                                .font(.largeTitle)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue)
                            
                            Spacer()
                            
                            Button {
                                showSettings = true
                            } label: {
                                Image(systemName: "gearshape.fill")
                            }
                        }
                        
                        HStack {
                            Button {
                                isToday = true
                                scrollOffset = 0
                            } label: {
                                Text("Today")
                                    .foregroundColor(isToday ? .black : .gray)
                            }
                            
                            Button {
                                isToday = false
                                scrollOffset = UIScreen.main.bounds.width
                            } label: {
                                Text("Charts")
                                    .foregroundColor(isToday ? .gray : .black)
                            }
                            
                            Spacer()
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                
                                VStack {
                                    NavigationLink {
                                        FeedingView()
                                    } label: {
                                        Text("Daily Feeding Activity")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, minHeight: 100)
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                            .padding(.horizontal, 30)
                                    }
                                    
                                    NavigationLink {
                                        HistoryView()
                                    } label: {
                                        Text("Daily Diaper Activity")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, minHeight: 100)
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                            .padding(.horizontal, 30)
                                    }
                                    
                                    NavigationLink {
                                        HistoryView()
                                    } label: {
                                        Text("Daily Sleep Activity")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, minHeight: 100)
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                            .padding(.horizontal, 30)
                                    }
                                    
                                    NavigationLink {
                                        ActiveRemindersView()
                                    } label: {
                                        Text("Upcoming Reminders")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, minHeight: 100)
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                            .padding(.horizontal, 30)
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width)
                                
                                Rectangle()
                                    .foregroundColor(.yellow)
                                    .frame(maxWidth: .infinity, minHeight: 100)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 30)
                                    .frame(width: UIScreen.main.bounds.width)
                                
                            }
                            .offset(x: -scrollOffset, y: 0)
                            .animation(.default, value: scrollOffset)
                        }
                    }
                }
                
                FloatingButton(icon: "plus",
                               feedingAction: $feedingAction,
                               sleepAction: $sleepAction,
                               diaperAction: $diaperAction,
                               reminderAction: $reminderAction)
                
            }
            
        }
        .sheet(isPresented: $feedingAction) {
            FeedingView()
        }
        .sheet(isPresented: $sleepAction) {
            SleepView()
        }
        .sheet(isPresented: $diaperAction) {
            DiapersView()
        }
        .sheet(isPresented: $reminderAction) {
            ReminderView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

struct BabyDayView_Previews: PreviewProvider {
    static var previews: some View {
        BabyDayView()
    }
}
