//
//  LoadingView.swift
//  FeedingEmma
//
//  Created by Justin on 4/11/23.
//

import SwiftUI

struct LoadingView: View {
    @Binding var show: Bool
    var body: some View {
        ZStack {
            
            if show {
                Group {
                    Rectangle()
                        .fill(.black.opacity(0.25))
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .padding(15)
                        .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
            
        }
        .animation(.easeOut(duration: 0.25), value: show)
    }
}
