import UIKit
import AVFoundation

final class FlashService {
    static let shared = FlashService()

    private var isEnabled = false

    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }

    func flash() {
        guard isEnabled, let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = .on
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                device.torchMode = .off
                device.unlockForConfiguration()
            }
        } catch {
            Logger.app.error("Flash error: \(error.localizedDescription)")
        }
    }
}
