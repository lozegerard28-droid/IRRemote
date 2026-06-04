import Foundation

class IRReceiverService: IRReceivable {
    static let shared = IRReceiverService()
    private var isReceiving = false
    
    func startReceiving() -> AsyncStream<ReceivedIRCode> {
        AsyncStream { continuation in
            isReceiving = true
            Task {
                while isReceiving {
                    if let code = await listenForIR() {
                        continuation.yield(code)
                    }
                    try? await Task.sleep(nanoseconds: 50_000_000)
                }
                continuation.finish()
            }
        }
    }
    
    func stopReceiving() {
        isReceiving = false
    }
    
    private func listenForIR() async -> ReceivedIRCode? {
        // Hardware-specific reception
        try? await Task.sleep(nanoseconds: 100_000_000)
        return nil
    }
}