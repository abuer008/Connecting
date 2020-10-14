//
//  HapticEffect.swift
//  Connecting
//
//  Created by bowei xiao on 25.09.20.
//

import SwiftUI

class HapticEffect {
    
    static func hapticFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
    
    static func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle, intensity: CGFloat) {
        UIImpactFeedbackGenerator(style: style).impactOccurred(intensity: intensity)
    }
}
