import AVFoundation

class FlashService: FlashLightable {
    static let shared = FlashService()
    private let queue = DispatchQueue(label: "com.irremote.flash", qos: .userInitiated)

    var isAvailable: Bool {
        guard let device = AVCaptureDevice.default(for: .video) else { return false }
        return device.hasTorch
    }

    func flash(duration: TimeInterval = 0.1) {
        queue.async { [weak self] in
            guard let self = self else { return }
            guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
            do {
                try device.lockForConfiguration()
                device.torchMode = .on
                self.queue.asyncAfter(deadline: .now() + duration) {
                    device.torchMode = .off
                    device.unlockForConfiguration()
                }
            } catch {}
        }
    }

    func stopFlashing() {
        queue.async {
            guard let device = AVCaptureDevice.default(for: .video) else { return }
            do {
                try device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
            } catch {}
        }
    }
}
