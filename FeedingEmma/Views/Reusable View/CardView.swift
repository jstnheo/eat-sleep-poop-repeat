//
//  CardView.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/30/23.
//

import SwiftUI

struct CardView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color.theme.textPrimary)
            
            content
            
        }
        .padding()
        .cardBackground()
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(title: "Test") {
            Text("Hello World")
        }
    }
}
