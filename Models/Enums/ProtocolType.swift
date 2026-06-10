import Foundation

enum ProtocolType: String, Codable, CaseIterable {
    case nec = "NEC"
    case sonySIRC = "SIRC"
    case rc5 = "RC5"
    case rc6 = "RC6"
    case panasonic = "Panasonic"
    case jvc = "JVC"
    case samsung = "Samsung"
    case raw = "Raw"

    var defaultFrequency: Int {
        switch self {
        case .nec, .samsung, .panasonic, .jvc: return 38000
        case .sonySIRC: return 40000
        case .rc5, .rc6: return 36000
        case .raw: return 38000
        }
    }
}
