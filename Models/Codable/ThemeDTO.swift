import Foundation

struct ThemeDTO: Codable {
    let version: String
    let name: String
    let author: String?
    let colors: ThemeColors
    let fonts: ThemeFonts?
    let shapes: ThemeShapes?
    let animations: ThemeAnimations?

    struct ThemeColors: Codable {
        let primary: String
        let background: String
        let surface: String
        let text: String
        let buttonBackground: String
        let buttonText: String
        let buttonPressed: String
        let success: String
        let error: String
        let favorite: String
    }

    struct ThemeFonts: Codable {
        let regular: String
        let bold: String
        let size: FontSize?

        struct FontSize: Codable {
            let small: CGFloat
            let medium: CGFloat
            let large: CGFloat
        }
    }

    struct ThemeShapes: Codable {
        let buttonCornerRadius: CGFloat?
        let cardCornerRadius: CGFloat?
    }

    struct ThemeAnimations: Codable {
        let pressScale: Double?
        let pressDuration: Double?
    }
}
