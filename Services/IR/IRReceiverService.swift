import Foundation

actor IRReceiverService {
    static let shared = IRReceiverService()

    private var activeDongle: IRTransmittable?
    private var receiveTask: Task<Void, Never>?

    func setDongle(_ dongle: IRTransmittable) {
        activeDongle = dongle
    }

    func startReceiving() -> AsyncStream<String> {
        guard let dongle = activeDongle else {
            return AsyncStream { $0.finish() }
        }
        return dongle.startReceiving()
    }

    func stopReceiving() {
        activeDongle?.stopReceiving()
    }
}
