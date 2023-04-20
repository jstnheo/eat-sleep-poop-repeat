//
//  TestView.swift
//  FeedingEmma
//
//  Created by Justin on 4/5/23.
//

import SwiftUI

enum BabyState: String, CaseIterable {
    case today
    case calendar
}

struct TimerManualView<FirstView: View, SecondView: View>: View {
    
    @State var babyState: BabyState = .today
    @State private var scrollOffset: CGFloat = 0
    
    let firstView: FirstView
    let secondView: SecondView
    
    init(firstView: FirstView, secondView: SecondView) {
        self.firstView = firstView
        self.secondView = secondView
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                HStack {
                    ForEach(BabyState.allCases, id: \.self) { state in
                        
                        Button {
                            
                            babyState = state
                            scrollOffset = state == .today ? 0 : UIScreen.main.bounds.width
                            
                        } label: {
                            Text(state.rawValue.capitalized)
                                .tag(state)
                                .foregroundColor(state == babyState ? .black : .gray)
                        }
                        
                    }
                    
                    Spacer()
                }
                
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            
                            firstView
//                                .cornerRadius(10)
//                                .padding(.horizontal, 10)
//                                .frame(height: 400)
                                .frame(width: geometry.size.width)
                            
                            secondView
//                                .cornerRadius(10)
//                                .padding(.horizontal, 10)
//                                .frame(height: 400)
                                .frame(width: geometry.size.width)
                            
                        }
                        .frame(width: geometry.size.width * 2)
                        .offset(x: -scrollOffset, y: 0)
                        .animation(.default, value: scrollOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let screenWidth = geometry.size.width
                                    let translation = value.translation.width
                                    
                                    if scrollOffset - translation >= 0 && scrollOffset - translation <= screenWidth {
                                        scrollOffset -= translation
                                    }
                                }
                                .onEnded { _ in
                                    let screenWidth = geometry.size.width
                                    
                                    if scrollOffset > screenWidth / 2 {
                                        babyState = .calendar
                                        scrollOffset = screenWidth
                                    } else {
                                        babyState = .today
                                        scrollOffset = 0
                                    }
                                }
                        )
                    }
                }
            }
        }
    }
}

//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView()
//    }
//}


struct TestCalendarView: View {
    let items = [
        PickerItem(title: "1"),
        PickerItem(title: "2"),
        PickerItem(title: "3"),
        PickerItem(title: "4"),
        PickerItem(title: "5"),
        PickerItem(title: "6"),
        PickerItem(title: "7"),
        PickerItem(title: "8"),
        PickerItem(title: "9"),
        PickerItem(title: "10"),
        PickerItem(title: "11"),
        PickerItem(title: "12"),
        PickerItem(title: "13"),
        PickerItem(title: "14")
    ]
    
    var body: some View {
        
        VStack {
            HorizontalPickerView(items: items, defaultSelectedItem: items[1])
            
            HorizontalPickerView(items: items, defaultSelectedItem: items[1])

        }
        
    }
}
