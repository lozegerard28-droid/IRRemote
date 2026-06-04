import Foundation

enum ThemeMode: String, Codable, CaseIterable {
    case system, light, dark
}
enum ButtonSize: String, Codable, CaseIterable {
    case small, medium, large, adaptive
}
enum HapticIntensity: String, Codable, CaseIterable {
    case off, light, medium, strong
}
enum Language: String, Codable, CaseIterable {
    case french, english
}
