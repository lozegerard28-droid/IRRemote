import Foundation
import Combine

class DongleManager: ObservableObject {
    static let shared = DongleManager()
    
    @Published var connectedDongle: DongleInfo?
    @Published var availableDongles: [DongleInfo] = []
    @Published var isConnected = false
    
    private var drivers: [String: DongleDriver] = [:]
    private var activeDriver: DongleDriver?
    
    func scanForDongles() async {
        // Scan for connected USB dongles
        // Platform-specific implementation needed (IOKit / ExternalAccessory)
        await MainActor.run {
            self.availableDongles = [
                DongleInfo(id: "generic_ir", name: "Générique USB IR", manufacturer: "AliExpress", hasTX: true, hasRX: false),
                DongleInfo(id: "ir_toy_v2", name: "USB IR Toy v2", manufacturer: "Dangerous Prototypes", hasTX: true, hasRX: true),
            ]
        }
    }
    
    func connect(to dongleID: String) async throws {
        guard let dongle = availableDongles.first(where: { $0.id == dongleID }) else {
            throw AppError.dongleNotSupported
        }
        // Connection logic
        await MainActor.run {
            self.connectedDongle = dongle
            self.isConnected = true
        }
    }
    
    func disconnect() {
        activeDriver?.disconnect()
        activeDriver = nil
        Task { @MainActor in
            self.connectedDongle = nil
            self.isConnected = false
        }
    }
    
    func sendIR(code: String, protocolType: IRProtocol) async throws {
        guard isConnected, let driver = activeDriver else {
            throw AppError.dongleNotConnected
        }
        try await driver.send(code: code, protocolType: protocolType)
    }
}

struct DongleInfo: Identifiable, Equatable {
    let id: String
    let name: String
    let manufacturer: String
    let hasTX: Bool
    let hasRX: Bool
}