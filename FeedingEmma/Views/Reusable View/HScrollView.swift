//
//  HScrollView.swift
//  FeedingEmma
//
//  Created by Justin on 4/4/23.
//

import SwiftUI

struct ItemView<Item: Identifiable, Content: View>: View {
    var item: Item
    var content: (Item) -> Content
    
    var body: some View {
        content(item)
            .frame(width: 80, height: 120)
//            .cornerRadius(8)
    }
}

struct HScrollView<Item: Identifiable & Equatable, Content: View>: View {
    var items: [Item]
    var content: (Item) -> Content
    @Binding var selectedItem: Item?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 16) {
                ForEach(items) { item in
                    ItemView(item: item, content: content)
                        .background(item == selectedItem ? Color.red : Color.blue)
                        .cornerRadius(8)
                        .onTapGesture {
                            selectedItem = item
                        }
                }
            }
//            .padding()
        }
    }
}
