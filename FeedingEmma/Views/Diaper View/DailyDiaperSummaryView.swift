//
//  DailyDiaperSummaryView.swift
//  FeedingEmma
//
//  Created by Justin on 4/16/23.
//

import SwiftUI

struct DailyDiaperSummaryView: View {
    
    @StateObject var viewModel = DailyDiaperSummaryViewModel()
    
    var body: some View {
        
        VStack(spacing: 16) {
            HStack {
                
                HStack {
                    Image("diaper")
                        .resizable()
                        .renderingMode(.template)
                        .tint(Color.theme.diaperPrimary)
                        .frame(width: 22, height: 22)
                    
                    Text("Diaper Activity")
                        .fontWeight(.bold)
                        .font(.title3)
                        .foregroundColor(Color.theme.diaperPrimary)
                    
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
                
                Text("No Diapers Today")
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
                            .foregroundColor(Color.theme.diaperPrimary)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Text(viewModel.recentCondition)
                            .font(.body)
                            .foregroundColor(Color.theme.diaperPrimary)
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
                            .foregroundColor(Color.theme.diaperPrimary)
                        
                    }
                    
                    HStack {
                        
                        Spacer()
                        
                        Text(viewModel.totalAmounts)
                            .font(.body)
                            .foregroundColor(Color.theme.diaperPrimary)
                        
                    }
                    
                }
            }
        }
        .padding()
        
    }
}

struct DailyDiaperSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DailyDiaperSummaryView()
    }
}
