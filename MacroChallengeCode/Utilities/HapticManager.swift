import CoreHaptics

class HapticManager {
    static let shared = HapticManager()
    let hapticEngine: CHHapticEngine
    
    
    private init?() {
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
    
    
    func triggerHaptic() {
        
        do {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            let duration = 0.2 // Durata in secondi
            let pattern = try CHHapticPattern(events: [CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: duration)], parameters: [])
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: 0)
            hapticEngine.notifyWhenPlayersFinished { _ in
                return .stopEngine
            }
        } catch {
            print("Errore durante la riproduzione del feedback haptic: \(error.localizedDescription)")
        }
    }
    
    private func createHapticEvent() -> CHHapticEvent {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let duration = 0.2 // Durata in secondi
        
        return CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: duration)
    }
}
