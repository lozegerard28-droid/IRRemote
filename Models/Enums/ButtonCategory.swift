import Foundation

enum ButtonCategory: String, Codable, CaseIterable, Identifiable {
    case power, volume, channel, navigation, input, menu, media, app, number, function, custom
    var id: String { rawValue }
    var displayName: String {
        switch self { case .power: return "Alimentation"; case .volume: return "Volume"
        case .channel: return "Cha\u00eene"; case .navigation: return "Navigation"
        case .input: return "Entr\u00e9e"; case .menu: return "Menu"; case .media: return "M\u00e9dia"
        case .app: return "Application"; case .number: return "Chiffre"
        case .function: return "Fonction"; case .custom: return "Personnalis\u00e9" }
    }
}
