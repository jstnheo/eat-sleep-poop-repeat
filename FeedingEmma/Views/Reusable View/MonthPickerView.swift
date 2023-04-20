//
//  MonthPickerView.swift
//  FeedingEmma
//
//  Created by Justin on 4/4/23.
//

import SwiftUI

struct MonthItem: Identifiable, Equatable {
    var id: Int
    var month: Int
    var year: Int

    static func ==(lhs: MonthItem, rhs: MonthItem) -> Bool {
        return lhs.id == rhs.id && lhs.month == rhs.month && lhs.year == rhs.year
    }
}

struct MonthView<Item: Identifiable, Content: View>: View {
    var item: Item
    var content: (Item) -> Content
    
    var body: some View {
        content(item)
            .padding()
            .cornerRadius(8)
    }
}

struct MonthScrollView<Item: Identifiable & Equatable, Content: View>: View {
    var items: [Item]
    var content: (Item) -> Content
    @Binding var selectedItem: Item?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 16) {
                ForEach(items) { item in
                    
                    MonthView(item: item, content: content)
                        .background(item == selectedItem ? Color.red : Color.blue)
                        .onTapGesture {
                            selectedItem = item
                        }
                }
            }
            .padding()
        }
    }
}

struct MonthPickerView: View {
//    let startDate: Date
//    let endDate: Date
//
//    var monthsInRange: [Date] {
//        var date = startDate.startOfMonth()
//        var result = [date]
//
//        while date < endDate {
//            guard let newDate = Calendar.current.date(byAdding: .month, value: 1, to: date) else { break }
//            date = newDate
//            result.append(date)
//        }
//
//        return result
//    }
    
    var items: [SampleItem] = [
        SampleItem(id: 1, title: "April"),
        SampleItem(id: 2, title: "March"),
        SampleItem(id: 3, title: "Feb"),
        SampleItem(id: 4, title: "Jan"),
        SampleItem(id: 5, title: "Dec"),
        SampleItem(id: 6, title: "Nov"),
        SampleItem(id: 7, title: "Oct"),
        SampleItem(id: 8, title: "Sept"),
    ]
    
    @State private var selectedItem: SampleItem? = nil
    
    var body: some View {
        MonthScrollView(items: items, content: { item in
            VStack {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }, selectedItem: $selectedItem)
    }
}

struct MonthPickerView_Previews: PreviewProvider {
    static var previews: some View {
        MonthPickerView()
    }
}
