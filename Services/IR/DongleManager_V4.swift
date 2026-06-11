import Foundation
import Combine

enum V4IRProtocol: String, Codable, CaseIterable {
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
    @Published var esp32Address: String {
        didSet { UserDefaults.standard.set(esp32Address, forKey: "esp32_address") }
    }

    private init() {
        esp32Address = UserDefaults.standard.string(forKey: "esp32_address") ?? ""
    }

    func scanForDongles() async {
        var list: [DongleInfo] = []
        if !esp32Address.isEmpty {
            list.append(DongleInfo(id: "esp32", name: "ESP32 IR (\(esp32Address))", manufacturer: "ESP32", hasTX: true, hasRX: false))
        }
        list.append(DongleInfo(id: "generic_ir", name: "Générique USB IR", manufacturer: "AliExpress", hasTX: true, hasRX: false))
        availableDongles = list
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
        guard let dongle = connectedDongle else { throw DongleError.notConnected }

        if dongle.id == "esp32" {
            try await sendViaESP32(code: code)
        } else {
            throw DongleError.notConnected
        }
    }

    private func sendViaESP32(code: String) async throws {
        guard !esp32Address.isEmpty else { throw DongleError.invalidAddress }
        let cleaned = code.hasPrefix("0x") ? String(code.dropFirst(2)) : code
        guard let url = URL(string: "http://\(esp32Address)/ir?code=\(cleaned)") else {
            throw DongleError.invalidAddress
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw DongleError.sendFailed
        }
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
    case invalidAddress
    case sendFailed

    var errorDescription: String? {
        switch self {
        case .notConnected: return "Dongle non connecté"
        case .invalidAddress: return "Adresse ESP32 invalide. Configure-la dans Réglages."
        case .sendFailed: return "Échec d'envoi du signal IR"
        }
    }
}
