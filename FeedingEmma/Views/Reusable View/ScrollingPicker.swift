//
//  ScrollingPicker.swift
//  FeedingEmma
//
//  Created by Justin on 4/3/23.
//

import SwiftUI

struct PickerItem: Identifiable {
    let id = UUID()
    let title: String
}

extension PickerItem: Equatable {
    static func == (lhs: PickerItem, rhs: PickerItem) -> Bool {
        return lhs.id == rhs.id
    }
}

struct PickerItemView: View {
    let item: PickerItem
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Text(item.title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(width: 80, height: 120)
        .background(isSelected ? Color.red : Color.gray) // Change background color based on isSelected
        .cornerRadius(10)
    }
}

struct HorizontalPickerView: View {
    @State private var selectedItem: PickerItem
    let items: [PickerItem]

    init(items: [PickerItem], defaultSelectedItem: PickerItem? = nil) {
        self.items = items
        _selectedItem = State(initialValue: defaultSelectedItem ?? items.first!)
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 8) {
                    ForEach(items) { item in
                        PickerItemView(item: item, isSelected: item == selectedItem)
                            .id(item.id)
                            .onTapGesture {
                                selectedItem = item
                                print("Selected item: \(item.title)")
                            }
                    }
                }
//                .padding()
            }
            .onAppear {
                withAnimation {
                    proxy.scrollTo(selectedItem.id, anchor: .leading)
                }
            }
        }
    }
}


struct HorizontalPickerView_Previews: PreviewProvider {
    static var previews: some View {
        
        let items = [
            PickerItem(title: "Hi"),
            PickerItem(title: "Hello"),
            PickerItem(title: "Him"),
            PickerItem(title: "Hiss"),
            PickerItem(title: "Hia"),
            PickerItem(title: "Hidf"),
            PickerItem(title: "Hid")
        ]
        
        HorizontalPickerView(items: items, defaultSelectedItem: items[1])
    }
}
