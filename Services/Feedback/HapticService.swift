import UIKit

final class HapticService {
    static let shared = HapticService()

    enum Intensity {
        case light, medium, strong, off
    }

    private var intensity: Intensity = .medium

    func setIntensity(_ intensity: Intensity) {
        self.intensity = intensity
    }

    func play() {
        guard intensity != .off else { return }
        let feedback: UIImpactFeedbackGenerator.FeedbackStyle
        switch intensity {
        case .light: feedback = .light
        case .medium: feedback = .medium
        case .strong: feedback = .heavy
        case .off: return
        }
        let generator = UIImpactFeedbackGenerator(style: feedback)
        generator.prepare()
        generator.impactOccurred()
    }

    func playSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }

    func playError() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
    }
}
