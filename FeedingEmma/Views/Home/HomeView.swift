//
//  HomeView.swift
//  FeedingEmma
//
//  Created by Justin on 4/10/23.
//

import SwiftUI

struct HomeView: View {
    @Namespace var animatedID
    @State var currentTab = "Today"
    
    @State var feedingAction: Bool = false
    @State var sleepAction: Bool = false
    @State var diaperAction: Bool = false
    @State var reminderAction: Bool = false
    @State var showSettings: Bool = false
    
    @StateObject var viewModel = HomeViewModel()
    
    @AppStorage("babyName") var babyName: String = "Emma"
    

    var body: some View {
        
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 4) {
                    
                        VStack(alignment: .leading) {
                            //Title
                            Text("Feeding \(babyName)")
                                .font(.title)
                                .bold()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Custom Segemented Tab
                        HStack(spacing: 16) {
                            ForEach(["Today", "Charts"], id: \.self) { tab in
                                TabButton(currentTab: $currentTab, title: tab, animateID: animatedID)
                            }
                            
                            Spacer()
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        
                        // Cards
                        
                        if currentTab == "Today" {
                        
                            VStack(spacing: 18) {
                                NavigationLink {
                                    HistoryView(filterBy: .feeding)
                                } label: {
                                    DailyFeedingSummaryView()
                                        .frame(maxWidth: .infinity, minHeight: 90)
                                        .cardBackground()
                                        .padding(.horizontal, 8)
                                }
                                
                                
                                NavigationLink {
                                    HistoryView(filterBy: .sleep)
                                } label: {
                                    DailySleepSummaryView()
                                        .frame(maxWidth: .infinity, minHeight: 90)
                                        .cardBackground()
                                        .padding(.horizontal, 8)
                                }
                                
                                NavigationLink {
                                    HistoryView(filterBy: .diaper)
                                } label: {
                                    DailyDiaperSummaryView()
                                        .frame(maxWidth: .infinity, minHeight: 90)
                                        .cardBackground()
                                        .padding(.horizontal, 8)
                                }
                                
                                NavigationLink {
                                    ActiveRemindersView()
                                } label: {
                                    UpcomingRemindersView()
                                        .frame(maxWidth: .infinity, minHeight: 90)
                                        .cardBackground()
                                        .padding(.horizontal, 8)
                                }
                            }
                            
                            
                        } else {
                            VStack(spacing: 18) {
                                
                                FeedingAmountChart()
                                    .cardBackground()
                                    .padding(.horizontal, 8)

//                                FeedingDurationChartView()
                                
//                                FeedingTimeChart(feedData: feedDatum)
//                                    .cardBackground()
//                                
//                                ChartsView()
//                                    .cardBackground()
                            }
                        }
                        
                    }
                    .padding()
                    
                }
                
                FloatingButton(icon: "plus",
                               feedingAction: $feedingAction,
                               sleepAction: $sleepAction,
                               diaperAction: $diaperAction,
                               reminderAction: $reminderAction)
                
                
            }
            .background(Color.systemBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.icon, .primary)
                    }
                }
            }
         
        }
        .navigationViewStyle(.stack)
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct TabButton: View {
    @Binding var currentTab: String
    var title: String
    
    var animateID: Namespace.ID
    
    var body: some View {
        Button {
            
            withAnimation(.spring()) {
                currentTab = title
            }
            
        } label: {
            VStack {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(currentTab == title ? Color(.label) : .gray)
                
                if currentTab == title {
                    Rectangle()
                        .fill(Color(.label))
                        .matchedGeometryEffect(id: "TAB", in: animateID)
                        .frame(width: 50, height: 1)
                } else {
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 50, height: 1)
                }
            }
        }
    }
}


struct DaySummary: Identifiable {
    var id = UUID().uuidString
    var title: String
    var date: Date
    var cardColor = Color.blue
    
    var type: EventType
}
