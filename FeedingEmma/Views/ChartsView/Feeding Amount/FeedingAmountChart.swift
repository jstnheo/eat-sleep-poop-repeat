//
//  FeedingAmountChart.swift
//  FeedingEmma
//
//  Created by Justin on 4/19/23.
//

import SwiftUI
import Charts

struct FeedingAmountChart: View {
    @State var viewModel = FeedingAmountViewModel()
    @State var isLineGraph = false
    
    @State var currentActiveItem: ProcessedFeedingAmountData?
    @State var plotWidth: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                
                Text(UserDefaults.standard.measurementUnit.rawValue.uppercased())
                    .fontWeight(.semibold)
                
                Spacer()
                
//                Toggle("Line Graph", isOn: $isLineGraph)
            }
            
            Text(String(format: "%.1f", viewModel.totalAmount))
                .font(.largeTitle.bold() )
            
            Chart(viewModel.processedData) { item in
                BarMark(
                    x: .value("Day", item.date, unit: .day),
                    y: .value("Amount", item.mlAmount)
                )
                .foregroundStyle(Color.blue.gradient)
                

                // MARK: Rule Mark
                if let currentActiveItem, currentActiveItem.id == item.id {
                    RuleMark(x: .value("day", currentActiveItem.date))

                    // MARK: Dotted line
                        .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                    
                    // MARK: Setting in middle of plot
                        .offset(x: (plotWidth / CGFloat(viewModel.processedData.count)) / 2)
                        .annotation(position: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("ML")
                                    .font(.caption)
                                    .foregroundColor(Color.theme.textSecondary)

                                Text(String(format: "%.1f", currentActiveItem.mlAmount))
                                    .font(.title3.bold())
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(Color.cardBackground.shadow(.drop(radius: 2)))
                            }
                        }
                }
                
            }
            .chartYScale(domain: 0...(viewModel.max() + 60))
            .chartOverlay(content: { proxy in
                GeometryReader { innerProxy in
                    Rectangle()
                        .fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    
                                    let location = value.location
                                    if let date: Date = proxy.value(atX: location.x) {
                                        
                                        let calendar = Calendar.current
                                        let day = calendar.component(.day, from: date)
                                        
                                        if let currentItem = viewModel.processedData.first(where: { item in
                                            calendar.component(.day, from: item.date) == day
                                        }) {
                                            self.currentActiveItem = currentItem
                                            self.plotWidth = proxy.plotAreaSize.width
                                        }
                                    }
                                }
                                .onEnded { value in
                                    self.currentActiveItem = nil
                                }
                        )
                }
            })
            
            .padding()
            .frame(height: 250)
        
            
            
        }
        .padding()
    }
}

struct FeedingAmountChart_Previews: PreviewProvider {
    static var previews: some View {
        FeedingAmountChart()
    }
}
