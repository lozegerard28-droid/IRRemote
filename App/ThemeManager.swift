import SwiftUI
import Combine
import OSLog

@MainActor
final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @Published var activeTheme: ThemeDTO
    var currentTheme: ThemeDTO { activeTheme }
    @Published var availableThemes: [ThemeDTO] = []

    let themeChanged = CurrentValueSubject<ThemeDTO, Never>(ThemeManager.defaultTheme)

    private static var defaultTheme: ThemeDTO {
        ThemeDTO(
            version: "1.0",
            name: "Clair",
            author: "IR Remote",
            colors: ThemeDTO.ThemeColors(
                primary: "#1A3C6E",
                background: "#FFFFFF",
                surface: "#F2F2F7",
                text: "#000000",
                buttonBackground: "#E5E5EA",
                buttonText: "#000000",
                buttonPressed: "#E50914",
                success: "#4CAF50",
                error: "#F44336",
                favorite: "#FFD700"
            ),
            fonts: ThemeDTO.ThemeFonts(
                regular: "SFProDisplay-Regular",
                bold: "SFProDisplay-Bold",
                size: ThemeDTO.ThemeFonts.FontSize(small: 12, medium: 16, large: 20)
            ),
            shapes: ThemeDTO.ThemeShapes(buttonCornerRadius: 12, cardCornerRadius: 16),
            animations: ThemeDTO.ThemeAnimations(pressScale: 0.92, pressDuration: 0.1)
        )
    }

    private init() {
        activeTheme = Self.defaultTheme
        availableThemes = [Self.defaultTheme, Self.darkTheme, Self.blueNightTheme]
    }

    func applyTheme(_ theme: ThemeDTO) {
        activeTheme = theme
        themeChanged.send(theme)
        Logger.app.info("Theme applied: \(theme.name)")
    }

    func importTheme(from url: URL) throws {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let theme = try decoder.decode(ThemeDTO.self, from: data)
        availableThemes.append(theme)
        Logger.app.info("Theme imported: \(theme.name)")
    }

    private static var darkTheme: ThemeDTO {
        ThemeDTO(
            version: "1.0",
            name: "Sombre",
            author: "IR Remote",
            colors: ThemeDTO.ThemeColors(
                primary: "#448AFF",
                background: "#121212",
                surface: "#1E1E1E",
                text: "#FFFFFF",
                buttonBackground: "#333333",
                buttonText: "#FFFFFF",
                buttonPressed: "#E50914",
                success: "#4CAF50",
                error: "#F44336",
                favorite: "#FFD700"
            ),
            fonts: nil,
            shapes: nil,
            animations: nil
        )
    }

    private static var blueNightTheme: ThemeDTO {
        ThemeDTO(
            version: "1.0",
            name: "Bleu Nuit",
            author: "IR Remote",
            colors: ThemeDTO.ThemeColors(
                primary: "#0D47A1",
                background: "#0A0E27",
                surface: "#151B3D",
                text: "#E0E0FF",
                buttonBackground: "#1A237E",
                buttonText: "#FFFFFF",
                buttonPressed: "#FF5252",
                success: "#69F0AE",
                error: "#FF5252",
                favorite: "#FFD700"
            ),
            fonts: nil,
            shapes: nil,
            animations: nil
        )
    }
}

// MARK: - Environment
private struct ThemeManagerKey: EnvironmentKey {
    static let defaultValue = ThemeManager.shared
}

extension EnvironmentValues {
    var themeManager: ThemeManager {
        get { self[ThemeManagerKey.self] }
        set { self[ThemeManagerKey.self] = newValue }
    }
}
