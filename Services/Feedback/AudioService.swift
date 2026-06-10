import UIKit
import AVFoundation

final class AudioService {
    static let shared = AudioService()

    private var isEnabled = false
    private var soundID: SystemSoundID = 0

    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }

    func setSound(_ url: URL) {
        AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
    }

    func play() {
        guard isEnabled else { return }
        if soundID != 0 {
            AudioServicesPlaySystemSound(soundID)
        } else {
            AudioServicesPlaySystemSound(1104)
        }
    }
}
