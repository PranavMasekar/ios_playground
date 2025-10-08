//
//  TimerLiveActivity.swift
//  live-activityExtension
//
//  Created by Pranav Masekar on 07/10/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            TimerView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded state - full Dynamic Island
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Image(systemName: "timer")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Text(context.attributes.timerName)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        Text(expandedTimerText(context: context))
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(expandedTimerColor(context: context))
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 4) {
                        // Progress ring
                        ZStack {
                            Circle()
                                .stroke(Color(.systemGray5), lineWidth: 3)
                                .frame(width: 32, height: 32)
                            
                            Circle()
                                .trim(from: 0, to: progressValue(context: context))
                                .stroke(expandedTimerColor(context: context), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                .frame(width: 32, height: 32)
                                .rotationEffect(.degrees(-90))
                        }
                        
                        Text(expandedStatusText(context: context))
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 8) {
                        Text("Timer Active")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text(expandedStatusText(context: context))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Spacer()
                        
                        Text("Tap to view details")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                }
            } compactLeading: {
                // Compact leading - left side of Dynamic Island
                HStack(spacing: 4) {
                    Image(systemName: "timer")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(compactTimerColor(context: context))
                    
                    Text(compactTimerText(context: context))
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(compactTimerColor(context: context))
                }
            } compactTrailing: {
                // Compact trailing - right side of Dynamic Island
                HStack(spacing: 2) {
                    // Progress dots
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(index < compactProgressDots(context: context) ? compactTimerColor(context: context) : Color(.systemGray4))
                            .frame(width: 4, height: 4)
                    }
                }
            } minimal: {
                // Minimal state - smallest Dynamic Island
                HStack(spacing: 3) {
                    Image(systemName: "timer")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(minimalTimerColor(context: context))
                    
                    Text(minimalTimerText(context: context))
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(minimalTimerColor(context: context))
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func expandedTimerText(context: ActivityViewContext<TimerAttributes>) -> String {
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
    
    private func expandedTimerColor(context: ActivityViewContext<TimerAttributes>) -> Color {
        let now = Date()
        let endTime = context.state.endTime
        let timeRemaining = endTime.timeIntervalSince(now)
        let totalTime: TimeInterval = 60 * 20
        
        if timeRemaining <= 0 {
            return .red
        } else if timeRemaining <= totalTime * 0.2 {
            return .orange
        } else if timeRemaining <= totalTime * 0.5 {
            return .yellow
        } else {
            return .green
        }
    }
    
    private func expandedStatusText(context: ActivityViewContext<TimerAttributes>) -> String {
        let now = Date()
        let endTime = context.state.endTime
        let timeRemaining = endTime.timeIntervalSince(now)
        
        if timeRemaining <= 0 {
            return "Completed"
        } else if timeRemaining <= 60 {
            return "Final minute"
        } else if timeRemaining <= 300 {
            return "Almost done"
        } else {
            return "Running"
        }
    }
    
    private func progressValue(context: ActivityViewContext<TimerAttributes>) -> Double {
        let now = Date()
        let endTime = context.state.endTime
        let timeRemaining = endTime.timeIntervalSince(now)
        let totalTime: TimeInterval = 60 * 20
        
        if timeRemaining <= 0 {
            return 1.0
        }
        
        return max(0, 1.0 - (timeRemaining / totalTime))
    }
    
    private func compactTimerText(context: ActivityViewContext<TimerAttributes>) -> String {
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
    
    private func compactTimerColor(context: ActivityViewContext<TimerAttributes>) -> Color {
        return expandedTimerColor(context: context)
    }
    
    private func compactProgressDots(context: ActivityViewContext<TimerAttributes>) -> Int {
        let now = Date()
        let endTime = context.state.endTime
        let timeRemaining = endTime.timeIntervalSince(now)
        let totalTime: TimeInterval = 60 * 20
        
        if timeRemaining <= 0 {
            return 3
        }
        
        let progress = 1.0 - (timeRemaining / totalTime)
        return min(3, Int(progress * 3) + 1)
    }
    
    private func minimalTimerText(context: ActivityViewContext<TimerAttributes>) -> String {
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
    
    private func minimalTimerColor(context: ActivityViewContext<TimerAttributes>) -> Color {
        return expandedTimerColor(context: context)
    }
}
