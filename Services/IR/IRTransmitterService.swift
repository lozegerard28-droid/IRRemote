import Foundation
import Combine

actor IRTransmitterService {
    static let shared = IRTransmitterService()

    private var activeDongle: IRTransmittable?
    @Published private(set) var isSending = false

    func setDongle(_ dongle: IRTransmittable) {
        activeDongle = dongle
    }

    func send(code: String, protocol: ProtocolType) async throws {
        guard let dongle = activeDongle else {
            throw AppError.dongleNotConnected
        }
        isSending = true
        defer { isSending = false }
        try await dongle.send(code: code, protocol: `protocol`)
    }

    func sendRepeated(code: String, protocol: ProtocolType, interval: TimeInterval) -> AsyncStream<Void> {
        AsyncStream { continuation in
            Task {
                while !Task.isCancelled {
                    do {
                        try await send(code: code, protocol: `protocol`)
                        try await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
                        continuation.yield()
                    } catch {
                        continuation.finish()
                    }
                }
            }
        }
    }
}
