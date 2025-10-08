//
//  LiveActivityImplementation.swift
//  Runner
//
//  Created by Pranav Masekar on 07/10/25.
//

import SwiftUI
import ActivityKit

class LiveActivityImplementation: LiveActivityApi {
    
    private var activity: Activity<TimerAttributes>? = nil
    private var updateTimer: Timer? = nil
    private var originalEndTime: Date? = nil
    
    func startLiveActivity() throws {
        
        print("Starting Live Activity")
        
        let attributes = TimerAttributes(timerName: "Timer One")
        
        originalEndTime = Date().addingTimeInterval(60 * 20)
        
        let state = TimerAttributes.ContentState(
            endTime: originalEndTime!
        )
        
        let content = ActivityContent(state: state, staleDate: nil)
        
        do {
            activity = try Activity<TimerAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
            print("Live Activity created successfully: \(activity?.id ?? "No ID")")
            
            startUpdatingLiveActivity()
        } catch {
            print("Failed to create Live Activity: \(error.localizedDescription)")
            print("Error details: \(error)")
        }
    }
    
    func stopLiveActivity() throws {
        updateTimer?.invalidate()
        updateTimer = nil
        
        let state = TimerAttributes.ContentState(endTime: .now)
        let content = ActivityContent(state: state, staleDate: nil)
        
        Task {
            await activity?.end(content, dismissalPolicy: .immediate)
        }
    }
    
    private func startUpdatingLiveActivity() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateLiveActivity()
        }
    }
    
    private func updateLiveActivity() {
        guard let activity = activity, let originalEndTime = originalEndTime else { return }
        
        let currentTime = Date()
        
        // Check if timer has expired
        if currentTime >= originalEndTime {
            try? self.stopLiveActivity()
            
            return
        }
        
        // Update with the original end time (the TimerView will calculate the remaining time)
        let state = TimerAttributes.ContentState(endTime: originalEndTime)
        let content = ActivityContent(state: state, staleDate: nil)
        
        Task {
            await activity.update(content)
        }
    }
}
