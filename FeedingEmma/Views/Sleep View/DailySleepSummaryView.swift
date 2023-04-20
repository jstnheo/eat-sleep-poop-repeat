//
//  DailySleepSummaryView.swift
//  FeedingEmma
//
//  Created by Justin on 4/16/23.
//

import SwiftUI

struct DailySleepSummaryView: View {
        
    @StateObject var viewModel = DailySleepSummaryViewModel()
    
    var body: some View {
        
        VStack(spacing: 16) {
            HStack {
                
                HStack {
                    Image("moon")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.theme.sleepPrimary)
                        .frame(width: 22, height: 22)
                    
                    Text("Sleep Activity")
                        .fontWeight(.bold)
                        .font(.title3)
                        .foregroundColor(Color.theme.sleepPrimary)
                    
                    Spacer()
                }
                                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 8, height: 12)
                    .foregroundColor(Color.theme.textSecondary)
            }
            
            if viewModel.isEmpty {
                
                Spacer()
                
                Text("No Sleeps Today")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.textSecondary)
                    .padding(.bottom, 12)
                
                Spacer()
                
            } else {
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    HStack {
                        
                        Text("Recent")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.theme.textPrimary)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        
                        Label(viewModel.recentTime, systemImage: "clock")
                            .font(.body)
                            .foregroundColor(Color.theme.sleepPrimary)
                    }
                    
                    Divider()
                        .padding(.top, 6)
                        .padding(.bottom, 8)
                                        
                    HStack {
                        
                        Text("Total")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.theme.textPrimary)
                        
                        Spacer()
                    }
                    
                    HStack {
                        
                        Spacer()
                        
                        Text(viewModel.totalCount)
                            .font(.body)
                            .foregroundColor(Color.theme.sleepPrimary)
                        
                    }
                    
                    HStack {
                        
                        Spacer()
                        
                        Text(viewModel.totalAmount)
                            .font(.body)
                            .foregroundColor(Color.theme.sleepPrimary)
                        
                    }
                    
                }
            }
        }
        .padding()
        
    }
}

struct DailySleepSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DailySleepSummaryView()
    }
}
