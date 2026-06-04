import AVFoundation

class AudioService: AudioPlayable {
    static let shared = AudioService()
    private let queue = DispatchQueue(label: "com.irremote.audio", qos: .userInitiated)
    
    func playSendSound() {
        playSound(named: "click")
    }
    
    func playSuccessSound() {
        playSound(named: "success")
    }
    
    func playErrorSound() {
        playSound(named: "error")
    }
    
    private func playSound(named: String) {
        queue.async { [weak self] in
            guard let self else { return }
            guard let url = Bundle.main.url(forResource: named, withExtension: "wav") else { return }
            guard let player = try? AVAudioPlayer(contentsOf: url) else { return }
            player.prepareToPlay()
            player.play()
        }
    }
}
