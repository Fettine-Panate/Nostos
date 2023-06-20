import CoreHaptics

class HapticManager {
    private var hapticEngine: CHHapticEngine?
    
    init?() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return nil }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Errore durante l'avvio del motore haptic: \(error.localizedDescription)")
            return nil
        }
    }
    
    func triggerHaptic() {
        guard let engine = hapticEngine else { return }
        
        do {
            let pattern = try CHHapticPattern(events: [createHapticEvent()], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
            engine.notifyWhenPlayersFinished { _ in
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
