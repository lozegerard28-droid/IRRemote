import Foundation
import Combine

enum V3IRProtocol: String, Codable, CaseIterable {
    case nec = "NEC"
    case sony = "Sony"
    case rc5 = "RC5"
    case rc6 = "RC6"
}

@MainActor
class DongleManager: ObservableObject {
    static let shared = DongleManager()

    @Published var connectedDongle: DongleInfo?
    @Published var availableDongles: [DongleInfo] = []
    @Published var isConnected = false

    func scanForDongles() async {
        availableDongles = [
            DongleInfo(id: "generic_ir", name: "Générique USB IR", manufacturer: "AliExpress", hasTX: true, hasRX: false),
        ]
    }

    func connect(to dongleID: String) {
        guard let dongle = availableDongles.first(where: { $0.id == dongleID }) else { return }
        connectedDongle = dongle
        isConnected = true
    }

    func disconnect() {
        connectedDongle = nil
        isConnected = false
    }

    func sendIR(code: String) async throws {
        guard isConnected else { throw DongleError.notConnected }
        // Placeholder: actual USB communication will be implemented with IOKit
        print("Send IR code: \(code)")
    }
}

struct DongleInfo: Identifiable, Equatable {
    let id: String
    let name: String
    let manufacturer: String
    let hasTX: Bool
    let hasRX: Bool
}

enum DongleError: LocalizedError {
    case notConnected
    case sendFailed

    var errorDescription: String? {
        switch self {
        case .notConnected: return "Dongle non connecté"
        case .sendFailed: return "Échec d'envoi du signal IR"
        }
    }
}
