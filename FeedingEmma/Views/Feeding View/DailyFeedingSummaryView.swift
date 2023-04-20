//
//  DailyFeedingSummaryView.swift
//  FeedingEmma
//
//  Created by Justin on 4/16/23.
//

import SwiftUI

struct DailyFeedingSummaryView: View {
        
    @StateObject var viewModel = DailyFeedingSummaryViewModel()
    
    var body: some View {
        
        VStack(spacing: 16) {
            HStack {
                
                HStack {
                    Image("bottle")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.theme.feedingPrimary)
                        .frame(width: 22, height: 22)
                    
                    Text("Feeding Activity")
                        .fontWeight(.bold)
                        .font(.title3)
                        .foregroundColor(Color.theme.feedingPrimary)
                    
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
                
                Text("No Feedings Today")
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
                            .foregroundColor(Color.theme.feedingPrimary)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Text(viewModel.recentSource)
                            .font(.body)
                            .foregroundColor(Color.theme.feedingPrimary)
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
                            .foregroundColor(Color.theme.feedingPrimary)
                        
                    }
                    
                    HStack {
                        
                        Spacer()
                        
                        Text(viewModel.totalTimeAndAmount)
                            .font(.body)
                            .foregroundColor(Color.theme.feedingPrimary)
                        
                    }
                    
                }
            }
        }
        .padding()
        
    }
   
}

struct DailyFeedingSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack {
            DailyFeedingSummaryView()
            
            DailyFeedingSummaryView()
        }
        
    }
}
