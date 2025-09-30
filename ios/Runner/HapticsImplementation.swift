//
//  HapticsImplementation.swift
//  Runner
//
//  Created by Pranav Masekar on 30/09/25.
//

import Foundation

class HapticsImplementation: HapticsApi {
    func triggerHapticFeedback(type: String) {
        let impactStyle: UIImpactFeedbackGenerator.FeedbackStyle
        
        switch type {
        case "Light":
            impactStyle = .light
        case "Medium":
            impactStyle = .medium
        case "Heavy":
            impactStyle = .heavy
        default:
            impactStyle = .medium
        }
        
        let generator = UIImpactFeedbackGenerator(style: impactStyle)
        generator.impactOccurred()
    }
}
