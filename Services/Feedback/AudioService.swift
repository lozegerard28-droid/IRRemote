import AVFoundation

class AudioService: AudioPlayable {
    static let shared = AudioService()
    private var player: AVAudioPlayer?
    
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
        guard let url = Bundle.main.url(forResource: named, withExtension: "wav") else { return }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.play()
    }
}