import Foundation

struct ThemeDTO: Codable {
    let version: String
    let name: String
    let author: String?
    let description: String?
    let colors: ThemeColorsDTO
    let fonts: ThemeFontsDTO
    let shapes: ThemeShapesDTO
    let animations: ThemeAnimationsDTO
}

struct ThemeColorsDTO: Codable {
    let primary, secondary, background, surface: String
    let surfaceElevated, text, textSecondary, textDisabled: String
    let buttonBackground, buttonText, buttonPressed: String
    let success, error, warning, favorite: String
    let border, divider: String
    
    enum CodingKeys: String, CodingKey {
        case primary, secondary, background, surface
        case surfaceElevated, text, textSecondary, textDisabled
        case buttonBackground, buttonText, buttonPressed
        case success, error, warning, favorite
        case border, divider
    }
}

struct ThemeFontsDTO: Codable {
    let regular, bold, button: String
    let size: FontSizesDTO
}

struct FontSizesDTO: Codable {
    let small, medium, large, button: Double
}

struct ThemeShapesDTO: Codable {
    let buttonCornerRadius, cardCornerRadius: Double
    let buttonBorderWidth: Double
}

struct ThemeAnimationsDTO: Codable {
    let pressScale, pressDuration: Double
    let hapticIntensity: Float
}