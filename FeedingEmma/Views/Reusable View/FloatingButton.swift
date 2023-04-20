//
//  FloatingButton.swift
//  FeedingEmma
//
//  Created by Justin on 4/9/23.
//

import SwiftUI

struct ActionFloatingButton: View {
    let icon: String
    let title: String
    let color: Color
    var offset: CGSize = CGSize.zero
    
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            
            HStack {
                
                Spacer()
                
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.textInverse)
                    .padding(15)
                    .background(color)
                    .cornerRadius(30)
                
                Image(icon)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color.theme.textInverse)
                    .padding(15)
                    .background(color)
                    .frame(width: 60, height: 60)
                    .cornerRadius(30)
            }
            
            
        }
        .offset(offset)
    }
}

struct FloatingButton: View {
    let icon: String
    
    private let actionButtonOffset: CGFloat = 20
    
    @State private var showActionButtons = false
    
    @Binding var feedingAction: Bool
    @Binding var sleepAction: Bool
    @Binding var diaperAction: Bool
    @Binding var reminderAction: Bool
    
    var body: some View {
        ZStack {
            if showActionButtons {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showActionButtons.toggle()
                        }
                    }
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    if showActionButtons {
                        VStack {
                            ActionFloatingButton(icon: "bottle",
                                                 title: "Feeding",
                                                 color: Color.theme.feedingPrimary,
                                                 offset: CGSize(width: 0, height: -4 * actionButtonOffset)) {
                                feedingAction.toggle()
                                showActionButtons.toggle()
                            }
                            
                            ActionFloatingButton(icon: "moon",
                                                 title: "Sleep",
                                                 color: Color.theme.sleepPrimary,
                                                 offset: CGSize(width: 0, height: -3 * actionButtonOffset)) {
                                sleepAction.toggle()
                                showActionButtons.toggle()
                                
                            }
                            
                            ActionFloatingButton(icon: "diaper",
                                                 title: "Diaper",
                                                 color: Color.theme.diaperPrimary,
                                                 offset: CGSize(width: 0, height: -2 * actionButtonOffset)) {
                                diaperAction.toggle()
                                showActionButtons.toggle()
                                
                            }
                            
                            ActionFloatingButton(icon: "alarm",
                                                 title: "Reminder",
                                                 color: Color.theme.remindersPrimary,
                                                 offset: CGSize(width: 0, height: -actionButtonOffset)) {
                                reminderAction.toggle()
                                showActionButtons.toggle()
                                
                            }
                        }
                        .animation(.spring(), value: showActionButtons)
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            showActionButtons.toggle()
                        }
                    }) {
                        Image(systemName: icon)
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                            .rotationEffect(Angle(degrees: showActionButtons ? 45 : 0))
                        
                    }
                    .frame(width: 60, height: 60)
                    .background(Color(.systemTeal))
                    .cornerRadius(30)
                    .shadow(radius: 10)
                }
            }
            .padding(.trailing, 25)
            .padding(.bottom, 10)
        }
    }
}

