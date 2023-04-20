//
//  CounterView.swift
//  FeedDiaperSleepRepeat
//
//  Created by Justin on 4/1/23.
//

import SwiftUI

struct CounterView: View {
    @Binding var count: Int
    let title: String
    
    var body: some View {
        HStack {
            Button(action: { self.count -= 1 }) {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text("-")
                            .font(.system(size: 44, weight: .bold))
                            .foregroundColor(.white)
                    )
            }
            
            VStack {
                Text("\(count)")
                    .font(.system(size: 24, weight: .semibold))
                    .frame(width: 80)
                
                Text(title)
            }
            
            
            
            Button(action: { self.count += 1 }) {
                Circle()
                    .foregroundColor(.green)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text("+")
                            .font(.system(size: 44, weight: .bold))
                            .foregroundColor(.white)
                    )
            }
        }
        .padding()
        
    }
}

//struct CounterView_Previews: PreviewProvider {
//    static var previews: some View {
//        CounterView(title: "Test")
//    }
//}
