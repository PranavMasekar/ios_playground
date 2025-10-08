//
//  TimerView.swift
//  live-activityExtension
//
//  Created by Pranav Masekar on 07/10/25.
//

import SwiftUI
import ActivityKit
import WidgetKit

struct TimerView: View {
    
    let context: ActivityViewContext<TimerAttributes>
    
    var body: some View {
        ZStack {
            // Background with subtle gradient
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(.systemBackground),
                            Color(.systemBackground).opacity(0.95)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.systemGray4), lineWidth: 0.5)
                )
            
            VStack(spacing: 12) {
                // Timer name with modern typography
                HStack {
                    Image(systemName: "timer")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text(context.attributes.timerName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                
                // Main timer display
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(timerText)
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(timerColor)
                        .contentTransition(.numericText())
                    
                    Spacer()
                    
                    // Progress indicator
                    Circle()
                        .fill(timerColor.opacity(0.2))
                        .frame(width: 8, height: 8)
                        .overlay(
                            Circle()
                                .stroke(timerColor, lineWidth: 1.5)
                        )
                }
                
                // Status text
                HStack {
                    Text(statusText)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
    
    private var timerText: String {
        let now = Date()
        let endTime = context.state.endTime
        let timeRemaining = endTime.timeIntervalSince(now)
        
        if timeRemaining <= 0 {
            return "00:00"
        }
        
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private var timerColor: Color {
        let now = Date()
        let endTime = context.state.endTime
        let timeRemaining = endTime.timeIntervalSince(now)
        let totalTime: TimeInterval = 60 * 20 // 20 minutes
        
        if timeRemaining <= 0 {
            return .red
        } else if timeRemaining <= totalTime * 0.2 { // Last 20%
            return .orange
        } else if timeRemaining <= totalTime * 0.5 { // Last 50%
            return .yellow
        } else {
            return .green
        }
    }
    
    private var statusText: String {
        let now = Date()
        let endTime = context.state.endTime
        let timeRemaining = endTime.timeIntervalSince(now)
        
        if timeRemaining <= 0 {
            return "Timer completed"
        } else if timeRemaining <= 60 { // Less than 1 minute
            return "Almost done"
        } else if timeRemaining <= 300 { // Less than 5 minutes
            return "Almost there"
        } else {
            return "In progress"
        }
    }
}
