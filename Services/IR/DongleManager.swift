import Foundation
import Combine

@MainActor
final class DongleManager: ObservableObject {
    static let shared = DongleManager()

    @Published private(set) var connectedDongles: [IRTransmittable] = []
    @Published private(set) var activeDongle: IRTransmittable?
    @Published private(set) var isConnected = false

    private init() {}

    func scanForDongles() {
        // USB device discovery via IOKit / ExternalAccessory
        // Placeholder for actual implementation
        Logger.ir.info("Scanning for dongles...")
    }

    func selectDongle(_ dongle: IRTransmittable) async throws {
        try await dongle.connect()
        activeDongle = dongle
        isConnected = true
        await IRTransmitterService.shared.setDongle(dongle)
        await IRReceiverService.shared.setDongle(dongle)
        Logger.ir.info("Dongle selected: \(dongle.name)")
    }

    func disconnectDongle() {
        activeDongle?.disconnect()
        activeDongle = nil
        isConnected = false
        Logger.ir.info("Dongle disconnected")
    }
}
