//
//  ChartsView.swift
//  FeedingEmma
//
//  Created by Justin on 4/10/23.
//

import SwiftUI
import Charts


struct ChartsView: View {
    
    @State var sampleAnalytics: [SiteView] = sample_analytics
    
    @State var currentTab: String = "7 Days"
    
    @State var currentActiveItem: SiteView?
    
    @State var plotWidth: CGFloat = 0
    
    @State var isLineGraph: Bool = false
    
    var body: some View {
       
        NavigationStack {
            VStack {
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    HStack {
                        
                        Text("Views")
                            .fontWeight(.semibold)
                        
                        Picker("", selection: $currentTab) {
                            Text("7 Days")
                                .tag("7 Days")

                            Text("Week")
                                .tag("Week")

                            Text("Month")
                                .tag("Month")

                        }
                        .pickerStyle(.segmented)
                        .padding(.leading, 80)
                        
                    }
                    
                    let totalValue = sampleAnalytics.reduce(0.0) {
                        partialResults, item in
                        item.views + partialResults
                    }
                    
                    Text(totalValue.stringFormat)
                        .font(.largeTitle.bold() )
                    
                
                    AnimatedChart()

                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white.shadow(.drop(radius: 2)))
                }
                
                Toggle("Line Graph", isOn: $isLineGraph)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationTitle("Swift Charts")
            .onChange(of: currentTab) { newValue in
                sampleAnalytics = sample_analytics
                if newValue != "7 Days" {
                    for(index, _) in sampleAnalytics.enumerated() {
                        sampleAnalytics[index].views = .random(in: 1500...10000)
                    }
                }
                
                animateGraph(fromChange: true)
            }
        }
    }
    
    @ViewBuilder
    func AnimatedChart() -> some View {
        
        let max = sampleAnalytics.max { item1, item2 in
            item2.views > item1.views
        }?.views ?? 0
        
        Chart {
            ForEach(sampleAnalytics) {
                item in
                // MARK: Bar Graph
                // MARK: Animating Graph
                
                if isLineGraph {
                    LineMark(
                        x: .value("Hour", item.hour, unit: .hour),
                        y: .value("Views", item.animate ? item.views : 0)
                    )
                    
                    .foregroundStyle(Color.blue.gradient)
                    .interpolationMethod(.catmullRom)
                } else {
                    BarMark(
                        x: .value("Hour", item.hour, unit: .hour),
                        y: .value("Views", item.animate ? item.views : 0)
                    )
                    
                    .foregroundStyle(Color.blue.gradient)
                }
                
                if isLineGraph {
                    AreaMark(
                        x: .value("Hour", item.hour, unit: .hour),
                        y: .value("Views", item.animate ? item.views : 0)
                    )
                    
                    .foregroundStyle(Color.blue.opacity(0.1).gradient)
                    .interpolationMethod(.catmullRom)
                }
                
                // MARK: Rule Mark
                if let currentActiveItem, currentActiveItem.id == item.id {
                    RuleMark(x: .value("hour", currentActiveItem.hour))
                    
                    // MARK: Dotted line
                        .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                    // MARK: Setting in middle of plot
                        .offset(x: (plotWidth / CGFloat(sampleAnalytics.count)) / 2)
                        .annotation(position: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Views")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Text(currentActiveItem.views.stringFormat)
                                    .font(.title3.bold())
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(.white.shadow(.drop(radius: 2)))
                            }
                        }
                }
                
            }
        }
        
        //
        .chartYScale(domain: 0...(max + 5000))
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
                                    let hour = calendar.component(.hour, from: date)
                                    
                                    if let currentItem = sampleAnalytics.first(where: { item in
                                        calendar.component(.hour, from: item.hour) == hour
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
        .frame(height: 250)
        .onAppear {
            animateGraph()
        }
    }
    
    func animateGraph(fromChange: Bool = false) {
        for (index, _) in sampleAnalytics.enumerated() {
            
            withAnimation(fromChange ? .easeInOut(duration: 0.8).delay(Double(index) * 0.05) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                sampleAnalytics[index].animate = true
            }
        }
    }
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView()
    }
}

struct SiteView: Identifiable {
    var id = UUID().uuidString
    var hour: Date
    var views: Double
    var animate: Bool = false
}

extension Date {
    func updateHour(value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: value, minute: 0, second: 0, of: self) ?? .now
    }
}

var sample_analytics: [SiteView] = [
    SiteView(hour: Date().updateHour(value: 8), views: 2346),
    SiteView(hour: Date().updateHour(value: 9), views: 2352),
    SiteView(hour: Date().updateHour(value: 10), views: 3421),
    SiteView(hour: Date().updateHour(value: 11), views: 5342),
    SiteView(hour: Date().updateHour(value: 12), views: 6543),
    SiteView(hour: Date().updateHour(value: 13), views: 5432),
    SiteView(hour: Date().updateHour(value: 14), views: 4325),
    SiteView(hour: Date().updateHour(value: 15), views: 2353),
    SiteView(hour: Date().updateHour(value: 16), views: 3425),
    SiteView(hour: Date().updateHour(value: 17), views: 7653),
    SiteView(hour: Date().updateHour(value: 18), views: 3421),
    SiteView(hour: Date().updateHour(value: 19), views: 4563),
    SiteView(hour: Date().updateHour(value: 20), views: 2543)
]

extension Double {
    var stringFormat: String {
        if self >= 10000 && self < 999999 {
            return String(format: "%.1fK", self/1000).replacingOccurrences(of: ".0", with: "")
        }
        
        if self > 999999 {
            return String(format: "%.1fM", self/1000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.0f", self)
    }
}
