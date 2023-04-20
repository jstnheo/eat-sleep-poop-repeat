//
//  HistoryView.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/30/23.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel: HistoryViewModel
    @State var showFilter: Bool = false
    
    @State var editDiaper: DiaperEvent?
    @State var editFeeding: FeedingEvent?
    @State var editSleep: SleepEvent?
    
    var navigationTitle: String {
        if let filterBy = viewModel.filterBy {
            switch filterBy {
            case .feeding:
                return "Feeding History"
            case .diaper:
                return "Diaper History"
            case .sleep:
                return "Sleep History"
            }
        }
        
        return "History"
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    init(filterBy: EventType? = nil) {
        _viewModel = StateObject(wrappedValue: HistoryViewModel(filterBy: filterBy))
    }
    
    var body: some View {
        
        Group {
            if viewModel.events.keys.isEmpty {
                
                VStack {
                    VStack(spacing: 10) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color(.systemTeal))
                            .cornerRadius(30)
                        
                        Text("Tap the + button on the Home screen to add activity.")
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
                    
                    ForEach(viewModel.events.keys.sorted(by: >), id: \.self) { date in
                        
                        Section(header: Text(dateFormatter.string(from: date))) {
                            ForEach(viewModel.events[date] ?? [], id: \.id) { event in
                                timelineView(for: event)
                                .onTapGesture {
                                    handleTap(for: event)
                                }
                            }
                            .onDelete { indexes in
                                viewModel.deleteEvent(at: indexes, date: date)
                            }
                        }
                    }
               
                }
                
            }
        }
     
        .navigationTitle(navigationTitle)
        .navigationBarBackButtonHidden(true)
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
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showFilter = true
                } label: {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.icon, .primary)
                }
            }
        }
        .actionSheet(isPresented: $showFilter) {
            ActionSheet(title: Text("Filter by"), message: nil, buttons: [
                .default(Text("Feeding History")) { viewModel.filterBy = .feeding },
                .default(Text("Sleep History")) { viewModel.filterBy = .sleep },
                .default(Text("Diaper History")) { viewModel.filterBy = .diaper },
                .default(Text("All History")) { viewModel.filterBy = nil },
                .cancel()
            ])
        }
        .sheet(item: $editFeeding) { feeding in
            FeedingView(feedingToEdit: feeding)
        }
        .sheet(item: $editDiaper) { diaper in
            DiapersView(diaperToEdit: diaper)
        }
        .sheet(item: $editSleep) { sleep in
            SleepView(sleepToEdit: sleep)
        }
    }
    
    
    func handleTap(for event: any EventProtocol) {
        switch event {
        case let diaperEvent as DiaperEvent:
            editDiaper = diaperEvent
        case let feedingEvent as FeedingEvent:
            editFeeding = feedingEvent
        case let sleepEvent as SleepEvent:
            editSleep = sleepEvent
        default:
            fatalError("Unexpected Type in Events")
        }
    }
    
    func timelineView(for event: any EventProtocol) -> some View {
        switch event {
        case let diaperEvent as DiaperEvent:
            return AnyView(DiaperTimelineView(diaperEvent: diaperEvent))
        case let feedingEvent as FeedingEvent:
            return AnyView(FeedingTimelineView(feedingEvent: feedingEvent))
        case let sleepEvent as SleepEvent:
            return AnyView(SleepTimelineView(sleepEvent: sleepEvent))
        default:
            fatalError("Unexpected Type in Events")
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}

extension Date {
    func formatted(date style: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: self)
    }
}
