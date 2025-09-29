//
//  AppUsageImplementation.swift
//  Runner
//
//  Created by Pranav Masekar on 29/09/25.
//

import Foundation

class AppUsageImplementation: AppUsageApi {
    
    func getPlatformVersion(completion: @escaping (Result<String?, Error>) -> Void) {
        let version = UIDevice.current.systemVersion
        completion(.success(version))
    }
    
    func getApps(completion: @escaping (Result<[UsedApp], Error>) -> Void) {
        let dummyApps = [
            UsedApp(id: "com.apple.mobilesafari", name: "Safari", minutesUsed: 120),
            UsedApp(id: "com.apple.mobilemail", name: "Mail", minutesUsed: 45),
            UsedApp(id: "com.apple.MobileSMS", name: "Messages", minutesUsed: 90),
            UsedApp(id: "com.apple.mobileslideshow", name: "Photos", minutesUsed: 30),
            UsedApp(id: "com.apple.mobilecal", name: "Calendar", minutesUsed: 15),
            UsedApp(id: "com.spotify.client", name: "Spotify", minutesUsed: 180),
            UsedApp(id: "com.netflix.Netflix", name: "Netflix", minutesUsed: 240),
            UsedApp(id: "com.instagram.ios", name: "Instagram", minutesUsed: 95),
            UsedApp(id: "com.facebook.Facebook", name: "Facebook", minutesUsed: 60),
            UsedApp(id: "com.twitter.ios", name: "Twitter", minutesUsed: 75)
        ]
        completion(.success(dummyApps))
    }
    
    func setAppTimeLimit(appId: String, minutesUsed: Int64, completion: @escaping (Result<StateResult, Error>) -> Void) {
        // Simulate different responses based on appId
        let appName = getAppName(from: appId)
        let result = StateResult(
            state: .success,
            message: "Time limit of \(minutesUsed) minutes set successfully for \(appName)"
        )
        completion(.success(result))
    }
    
    private func getAppName(from appId: String) -> String {
        switch appId {
        case "com.apple.mobilesafari":
            return "Safari"
        case "com.apple.mobilemail":
            return "Mail"
        case "com.apple.MobileSMS":
            return "Messages"
        case "com.apple.mobileslideshow":
            return "Photos"
        case "com.apple.mobilecal":
            return "Calendar"
        case "com.spotify.client":
            return "Spotify"
        case "com.netflix.Netflix":
            return "Netflix"
        case "com.instagram.ios":
            return "Instagram"
        case "com.facebook.Facebook":
            return "Facebook"
        case "com.twitter.ios":
            return "Twitter"
        default:
            return "Unknown App"
        }
    }
}
