//
//  CardBackground.swift
//  FeedingEmma
//
//  Created by Justin on 4/11/23.
//

import SwiftUI

// view modifier
struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.cardBackground)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 4)
    }
}

// view extension for better modifier access
extension View {
    func cardBackground() -> some View {
        modifier(CardBackground())
    }
}

struct CardBackground_View: View {
    var body: some View {
        
        VStack {
            Text("Hello, World!")
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .cardBackground()
                .padding()
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .cardBackground()
                .padding()
        }
    }
}

struct CardBackground_View_Previews: PreviewProvider {
    static var previews: some View {
        CardBackground_View()
    }
}
