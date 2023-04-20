//
//  DaySummaryView.swift
//  FeedingEmma
//
//  Created by Justin on 4/11/23.
//

import SwiftUI

struct DaySummaryView: View {
    @State var numberOfFeedings: Int = 0
    @State var timeSlept: TimeInterval = 0
    @State var numberOfDiapers: Int = 0
    
    var body: some View {
        HStack(spacing: 0) { // set spacing to 0 to avoid gaps
            VStack(spacing: 8) {
                Text("\(numberOfFeedings)")
                Text("Feedings")
                    .font(.caption)
            }
            Spacer()
            VStack(spacing: 8) {
                Text("1:49")
                Text("Sleep")
                    .font(.caption2)
            }
            Spacer()
            
            VStack(spacing: 8) {
                Text("\(numberOfDiapers)")
                Text("Diapers")
                    .font(.caption2)
            }
        }
    }

}

struct DaySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DaySummaryView()
    }
}
