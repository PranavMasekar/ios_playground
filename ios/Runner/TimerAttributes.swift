//
//  TimerAttributes.swift
//  Runner
//
//  Created by Pranav Masekar on 07/10/25.
//

import ActivityKit
import SwiftUI

struct TimerAttributes: ActivityAttributes {
    
    var timerName: String
    
    public struct ContentState : Codable, Hashable {
        var endTime: Date
    }
}
