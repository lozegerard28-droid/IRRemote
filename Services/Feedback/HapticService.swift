import UIKit

class HapticService: HapticFeedable {
    static let shared = HapticService()
    var intensity: Float = 0.7
    
    func playPressFeedback(intensity: Float = 0.7) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred(intensity: intensity)
    }
    
    func playSuccessFeedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    func playErrorFeedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    func playLightPress() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}