//
//  StreakTimelineProvider.swift
//  home_widgetExtension
//
//  Created by Pranav Masekar on 01/10/25.
//

import Foundation
import WidgetKit

struct StreakTimelineProvider: TimelineProvider {
    
    typealias Entry = StreakEntry
    
    private func getStreakCount() -> StreakEntry {
        let userDefaults = UserDefaults(suiteName: "group.streaks")
        let count = userDefaults?.integer(forKey: "streak_counter") ?? 0
        
        return StreakEntry(count: count)
    }
    
    func placeholder(in context: Context) -> StreakEntry {
        return getStreakCount()
    }
    
    func getSnapshot(in context: Context, completion: @escaping @Sendable (StreakEntry) -> Void) {
        return completion(getStreakCount())
    }
    
    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<StreakEntry>) -> Void) {
        let timeline = Timeline(entries: [getStreakCount()], policy: .never)
        
        return completion(timeline)
    }
}
