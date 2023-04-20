//
//  ColorExtensions.swift
//  FeedingEmma
//
//  Created by Justin on 4/10/23.
//

import SwiftUI

extension Color {
    static let cardBackground = Color("Card Background")
    static let background = Color("Background")
    static let icon = Color("Icon")
    static let text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
    
    
    static let theme = ColorTheme()
}

struct ColorTheme {
    let feedingPrimary = Color("Mint Green")
    let diaperPrimary = Color("Baby Blue")
    let sleepPrimary = Color("Lavender")
    let remindersPrimary = Color("Yellow")
    
    let textPrimary = Color("Text Primary")
    let textSecondary = Color("Text Secondary")
    let textTertiary = Color("Text Tertiary")
    let textInverse = Color("Inverse Text")
}
