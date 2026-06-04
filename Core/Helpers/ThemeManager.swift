import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    @Published var currentTheme: IRTheme = .default
    @Published var availableThemes: [IRTheme] = IRTheme.builtInThemes
    
    func applyTheme(_ theme: IRTheme) {
        currentTheme = theme
        objectWillChange.send()
    }
    
    func importTheme(url: URL) throws {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let themeDTO = try decoder.decode(ThemeDTO.self, from: data)
        let theme = IRTheme(from: themeDTO)
        availableThemes.append(theme)
        applyTheme(theme)
    }
}

struct IRTheme: Identifiable, Equatable {
    let id: UUID
    var name: String
    var isBuiltIn: Bool
    var colors: ThemeColors
    var fonts: ThemeFonts
    var shapes: ThemeShapes
    var animations: ThemeAnimations
    
    static let `default` = IRTheme(
        id: UUID(), name: "Clair", isBuiltIn: true,
        colors: ThemeColors(
            primary: Color(hex: "#1A3C6E"), secondary: Color(hex: "#E50914"),
            background: Color(hex: "#F5F5F5"), surface: Color(hex: "#FFFFFF"),
            surfaceElevated: Color(hex: "#FFFFFF"), text: Color(hex: "#212121"),
            textSecondary: Color(hex: "#757575"), textDisabled: Color(hex: "#BDBDBD"),
            buttonBackground: Color(hex: "#E0E0E0"), buttonText: Color(hex: "#212121"),
            buttonPressed: Color(hex: "#1A3C6E"), success: Color(hex: "#4CAF50"),
            error: Color(hex: "#F44336"), warning: Color(hex: "#FF9800"),
            favorite: Color(hex: "#FFD700"), border: Color(hex: "#E0E0E0"),
            divider: Color(hex: "#EEEEEE")
        ),
        fonts: ThemeFonts(regular: "SFProDisplay-Regular", bold: "SFProDisplay-Bold", button: "SFProRounded-Bold", size: FontSizes(small: 12, medium: 16, large: 20, button: 14)),
        shapes: ThemeShapes(buttonCornerRadius: 12, cardCornerRadius: 16, buttonBorderWidth: 0),
        animations: ThemeAnimations(pressScale: 0.92, pressDuration: 0.1, hapticIntensity: 0.7)
    )
    
    static let builtInThemes: [IRTheme] = [
        .default,
        IRTheme(id: UUID(), name: "Sombre", isBuiltIn: true,
            colors: ThemeColors(
                primary: Color(hex: "#4A90D9"), secondary: Color(hex: "#FF6B6B"),
                background: Color(hex: "#121212"), surface: Color(hex: "#1E1E1E"),
                surfaceElevated: Color(hex: "#2C2C2C"), text: Color(hex: "#FFFFFF"),
                textSecondary: Color(hex: "#AAAAAA"), textDisabled: Color(hex: "#666666"),
                buttonBackground: Color(hex: "#333333"), buttonText: Color(hex: "#FFFFFF"),
                buttonPressed: Color(hex: "#4A90D9"), success: Color(hex: "#66BB6A"),
                error: Color(hex: "#EF5350"), warning: Color(hex: "#FFA726"),
                favorite: Color(hex: "#FFD700"), border: Color(hex: "#333333"),
                divider: Color(hex: "#2A2A2A")
            ),
            fonts: ThemeFonts(regular: "SFProDisplay-Regular", bold: "SFProDisplay-Bold", button: "SFProRounded-Bold", size: FontSizes(small: 12, medium: 16, large: 20, button: 14)),
            shapes: ThemeShapes(buttonCornerRadius: 12, cardCornerRadius: 16, buttonBorderWidth: 0),
            animations: ThemeAnimations(pressScale: 0.92, pressDuration: 0.1, hapticIntensity: 0.7)
        ),
        IRTheme(id: UUID(), name: "Bleu Nuit", isBuiltIn: true,
            colors: ThemeColors(
                primary: Color(hex: "#FFD700"), secondary: Color(hex: "#4A90D9"),
                background: Color(hex: "#0A0E27"), surface: Color(hex: "#141838"),
                surfaceElevated: Color(hex: "#1C2150"), text: Color(hex: "#FFFFFF"),
                textSecondary: Color(hex: "#8899CC"), textDisabled: Color(hex: "#445577"),
                buttonBackground: Color(hex: "#1C2150"), buttonText: Color(hex: "#FFFFFF"),
                buttonPressed: Color(hex: "#FFD700"), success: Color(hex: "#00C853"),
                error: Color(hex: "#FF1744"), warning: Color(hex: "#FFD600"),
                favorite: Color(hex: "#FFD700"), border: Color(hex: "#2A3060"),
                divider: Color(hex: "#1A1E45")
            ),
            fonts: ThemeFonts(regular: "SFProDisplay-Regular", bold: "SFProDisplay-Bold", button: "SFProRounded-Bold", size: FontSizes(small: 12, medium: 16, large: 20, button: 14)),
            shapes: ThemeShapes(buttonCornerRadius: 16, cardCornerRadius: 20, buttonBorderWidth: 1),
            animations: ThemeAnimations(pressScale: 0.9, pressDuration: 0.15, hapticIntensity: 0.8)
        )
    ]
    
    init(from dto: ThemeDTO) {
        self.id = UUID()
        self.name = dto.name
        self.isBuiltIn = false
        self.colors = ThemeColors(from: dto.colors)
        self.fonts = ThemeFonts(from: dto.fonts)
        self.shapes = ThemeShapes(from: dto.shapes)
        self.animations = ThemeAnimations(from: dto.animations)
    }
    
    init(id: UUID, name: String, isBuiltIn: Bool, colors: ThemeColors, fonts: ThemeFonts, shapes: ThemeShapes, animations: ThemeAnimations) {
        self.id = id; self.name = name; self.isBuiltIn = isBuiltIn
        self.colors = colors; self.fonts = fonts; self.shapes = shapes; self.animations = animations
    }
}

struct ThemeColors {
    var primary: Color; var secondary: Color; var background: Color; var surface: Color
    var surfaceElevated: Color; var text: Color; var textSecondary: Color; var textDisabled: Color
    var buttonBackground: Color; var buttonText: Color; var buttonPressed: Color
    var success: Color; var error: Color; var warning: Color; var favorite: Color
    var border: Color; var divider: Color
    init(from dto: ThemeColorsDTO) {
        self.primary = Color(hex: dto.primary); self.secondary = Color(hex: dto.secondary)
        self.background = Color(hex: dto.background); self.surface = Color(hex: dto.surface)
        self.surfaceElevated = Color(hex: dto.surfaceElevated); self.text = Color(hex: dto.text)
        self.textSecondary = Color(hex: dto.textSecondary); self.textDisabled = Color(hex: dto.textDisabled)
        self.buttonBackground = Color(hex: dto.buttonBackground); self.buttonText = Color(hex: dto.buttonText)
        self.buttonPressed = Color(hex: dto.buttonPressed); self.success = Color(hex: dto.success)
        self.error = Color(hex: dto.error); self.warning = Color(hex: dto.warning)
        self.favorite = Color(hex: dto.favorite); self.border = Color(hex: dto.border)
        self.divider = Color(hex: dto.divider)
    }
    init(primary: Color, secondary: Color, background: Color, surface: Color, surfaceElevated: Color, text: Color, textSecondary: Color, textDisabled: Color, buttonBackground: Color, buttonText: Color, buttonPressed: Color, success: Color, error: Color, warning: Color, favorite: Color, border: Color, divider: Color) {
        self.primary = primary; self.secondary = secondary; self.background = background
        self.surface = surface; self.surfaceElevated = surfaceElevated; self.text = text
        self.textSecondary = textSecondary; self.textDisabled = textDisabled
        self.buttonBackground = buttonBackground; self.buttonText = buttonText
        self.buttonPressed = buttonPressed; self.success = success; self.error = error
        self.warning = warning; self.favorite = favorite; self.border = border; self.divider = divider
    }
}
struct ThemeFonts { var regular, bold, button: String; var size: FontSizes
    init(from dto: ThemeFontsDTO) { self.regular = dto.regular; self.bold = dto.bold; self.button = dto.button; self.size = FontSizes(from: dto.size) }
    init(regular: String, bold: String, button: String, size: FontSizes) { self.regular = regular; self.bold = bold; self.button = button; self.size = size }
}
struct FontSizes { var small, medium, large, button: CGFloat
    init(from dto: FontSizesDTO) { self.small = CGFloat(dto.small); self.medium = CGFloat(dto.medium); self.large = CGFloat(dto.large); self.button = CGFloat(dto.button) }
    init(small: CGFloat, medium: CGFloat, large: CGFloat, button: CGFloat) { self.small = small; self.medium = medium; self.large = large; self.button = button }
}
struct ThemeShapes { var buttonCornerRadius, cardCornerRadius: CGFloat; var buttonBorderWidth: CGFloat
    init(from dto: ThemeShapesDTO) { self.buttonCornerRadius = CGFloat(dto.buttonCornerRadius); self.cardCornerRadius = CGFloat(dto.cardCornerRadius); self.buttonBorderWidth = CGFloat(dto.buttonBorderWidth) }
    init(buttonCornerRadius: CGFloat, cardCornerRadius: CGFloat, buttonBorderWidth: CGFloat) { self.buttonCornerRadius = buttonCornerRadius; self.cardCornerRadius = cardCornerRadius; self.buttonBorderWidth = buttonBorderWidth }
}
struct ThemeAnimations { var pressScale: Double; var pressDuration: Double; var hapticIntensity: Float
    init(from dto: ThemeAnimationsDTO) { self.pressScale = dto.pressScale; self.pressDuration = dto.pressDuration; self.hapticIntensity = dto.hapticIntensity }
    init(pressScale: Double, pressDuration: Double, hapticIntensity: Float) { self.pressScale = pressScale; self.pressDuration = pressDuration; self.hapticIntensity = hapticIntensity }
}
