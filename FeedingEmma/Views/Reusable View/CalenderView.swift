//
//  CalenderView.swift
//  FeedingEmma
//
//  Created by Justin on 4/4/23.
//

import SwiftUI

struct SampleItem: Identifiable, Equatable {
    var id: Int
    var title: String
    var subtitle: String?
}

struct CalenderView: View {
    var items: [SampleItem] = [
        SampleItem(id: 1, title: "Item 1"),
        SampleItem(id: 2, title: "Item 2"),
        SampleItem(id: 3, title: "Item 3"),
        SampleItem(id: 4, title: "Item 4"),
        SampleItem(id: 5, title: "Item 5"),
        SampleItem(id: 6, title: "Item 6"),
        SampleItem(id: 7, title: "Item 7"),
        SampleItem(id: 8, title: "Item 8"),
    ]
    
    @State private var selectedItem: SampleItem? = nil
    
    var body: some View {
        HScrollView(items: items, content: { item in
            VStack {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }, selectedItem: $selectedItem)
    }
}

struct CalenderView_Previews: PreviewProvider {
    static var previews: some View {
        CalenderView()
    }
}
