//
//  DaySummaryCardView.swift
//  FeedingEmma
//
//  Created by Justin on 4/10/23.
//

import SwiftUI

struct DaySummaryCardView: View {
    var daySummary: DaySummary
    
    var body: some View {
        HStack {
            
            VStack {
                
                Text("\(daySummary.title)")
                
                Text("\(daySummary.type.rawValue)")

            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(daySummary.cardColor, in: RoundedRectangle(cornerRadius: 10))
    }
}

struct DaySummaryCardView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
