//
//  StreakWidget.swift
//  home_widgetExtension
//
//  Created by Pranav Masekar on 01/10/25.
//

import Foundation
import WidgetKit
import SwiftUI

struct StreakWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "com.example.streakWidget",
            provider: StreakTimelineProvider()
        ) { entry in
            if #available(iOS 17.0, *) {
                StreakView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                StreakView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Streak Widget")
        .description("Widget to show current streak")
    }
}

#Preview(as: .systemMedium) {
    StreakWidget()
} timeline: {
    StreakEntry(count: 9)
}
