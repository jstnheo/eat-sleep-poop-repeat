//
//  CTAButton.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 3/30/23.
//

import SwiftUI

struct CTAButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
        }
        .background(Color.icon)
        .cornerRadius(10)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}

struct CTAButton_Previews: PreviewProvider {
    static var previews: some View {
        CTAButton(title: "Save") {
            print("Test Save")
        }
    }
}
