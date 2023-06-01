//
//  HapticManager.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 30/05/23.
//

import Foundation
import CoreHaptics
import AVFAudio

class HapticManager {
    let hapticEngine: CHHapticEngine
    
    
    init?() {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        guard hapticCapability.supportsHaptics else {
            return nil
        }
        
        do {
            hapticEngine = try CHHapticEngine()
        } catch let error {
            print("Haptic engine Creation Error: \(error)")
            return nil
        }
        do {
            try hapticEngine.start()
        } catch let error {
            print("Haptic failed to start Error: \(error)")
        }
        hapticEngine.isAutoShutdownEnabled = true
        
    }
    
    func playFeedback() {
        self.playSample(samples: [1.0])
    }
    
    
    private func playSample(samples: [Float]) {
        createSample(samples: samples)
    }
    
    
    private func playHapticFromPattern(_ pattern: CHHapticPattern) throws {
        try hapticEngine.start()
        let player = try hapticEngine.makePlayer(with: pattern)
        try player.start(atTime: CHHapticTimeImmediate)
    }
    
    func stopHapticFeedback() {
        try hapticEngine.stop()
    }
    
    private func createSample(samples: [Float]){
        let count = samples.count
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        let totalDuration: TimeInterval = Double(count) * 0.1
        
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0, duration: totalDuration)
        
        do {
            try hapticEngine.start()
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print(error.localizedDescription)
        }
    }
}



