//
//  AirplayImplementation.swift
//  Runner
//
//  Created by Pranav Masekar on 01/10/25.
//

import Foundation
import AVKit
import MediaPlayer
import UIKit

class AirplayImplementation: AirplayApi {
    
    private var routePickerView: AVRoutePickerView?
    
    func startAirplay() throws {
        DispatchQueue.main.async {
            // Setup audio session for AirPlay playback
            let session = AVAudioSession.sharedInstance()
            do {
                print("Setting audio session.....")
                try session.setCategory(.playback, mode: .default, options: [.allowAirPlay])
                try session.setActive(true)
            } catch {
                print("Failed to configure AVAudioSession: \(error)")
            }
            
            // Add AirPlay picker programmatically (hidden button)
            print("Showing Airplay Picker.....")
            let routePicker = AVRoutePickerView(frame: .zero)
            routePicker.isHidden = true // no visible UI
            UIApplication.shared.windows.first?.rootViewController?.view.addSubview(routePicker)
            
            self.routePickerView = routePicker
            
            // Programmatically trigger the AirPlay device selector
            if let button = routePicker.subviews.compactMap({ $0 as? UIButton }).first {
                button.sendActions(for: .touchUpInside)
            }
        }
    }
    
    func stopAirplay() throws {
        DispatchQueue.main.async {
            let session = AVAudioSession.sharedInstance()
            do {
                // Reset session so playback goes back to device speakers
                try session.setActive(false, options: [.notifyOthersOnDeactivation])
            } catch {
                print("Failed to stop AirPlay: \(error)")
            }
        }
    }
}

