//
//  FeedingAmountChart.swift
//  FeedingEmma
//
//  Created by Justin on 4/18/23.
//

import SwiftUI
import Charts

struct FeedingDurationChartView: View {
    
    @State var viewModel = FeedingDurationChartViewModel()
        
    var body: some View {
        Chart(viewModel.processedData) { item in
            BarMark(
                x: .value("Day", item.date, unit: .day),
                y: .value("Duration", item.duration)
            )
            .foregroundStyle(Color.blue.gradient)
        }
        .chartYScale(domain: 0...(viewModel.max() + 120))
        .frame(height: 250)
    }
}

//struct FeedingAmountChart_Previews: PreviewProvider {
//    static var previews: some View {
//          FeedingAmountChartView()
//      }
//}
