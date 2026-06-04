import Foundation

enum IRProtocol: String, Codable, CaseIterable, Identifiable {
    case nec = "NEC"
    case sony12 = "Sony12"
    case sony15 = "Sony15"
    case sony20 = "Sony20"
    case rc5 = "RC5"
    case rc6 = "RC6"
    case rcmm = "RC-MM"
    case samsung = "Samsung"
    case jvc = "JVC"
    case panasonic = "Panasonic"
    case sharp = "Sharp"
    case raw = "Raw"
    
    var id: String { rawValue }
    var frequency: Int {
        switch self { case .nec, .rcmm, .samsung, .jvc, .sharp: return 38000
        case .sony12, .sony15, .sony20: return 40000
        case .rc5, .rc6: return 36000
        case .panasonic: return 56700
        case .raw: return 0 }
    }
    var defaultBits: Int {
        switch self { case .nec: return 32; case .sony12: return 12; case .sony15: return 15
        case .sony20: return 20; case .rc5: return 14; case .rc6: return 20
        case .rcmm: return 16; case .samsung: return 32; case .jvc: return 16
        case .panasonic: return 48; case .sharp: return 15; case .raw: return 0 }
    }
}
