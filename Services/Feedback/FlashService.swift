import AVFoundation

class FlashService: FlashLightable {
    static let shared = FlashService()
    
    var isAvailable: Bool {
        guard let device = AVCaptureDevice.default(for: .video) else { return false }
        return device.hasTorch
    }
    
    func flash(duration: TimeInterval = 0.1) {
        guard isAvailable else { return }
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        try? device.lockForConfiguration()
        device.torchMode = .on
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            device.torchMode = .off
            device.unlockForConfiguration()
        }
    }
    
    func stopFlashing() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        try? device.lockForConfiguration()
        device.torchMode = .off
        device.unlockForConfiguration()
    }
}