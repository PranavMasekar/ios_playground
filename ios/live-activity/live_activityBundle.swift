//
//  live_activityBundle.swift
//  live-activity
//
//  Created by Pranav Masekar on 07/10/25.
//

import WidgetKit
import SwiftUI

@main
struct live_activityBundle: WidgetBundle {
    var body: some Widget {
        if #available(iOS 16.2, *) {
            TimerLiveActivity()
        }
    }
}
