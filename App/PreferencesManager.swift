import Foundation

final class PreferencesManager {
    static let shared = PreferencesManager()
    private let defaults = UserDefaults.standard

    // General
    var language: String {
        get { defaults.string(forKey: "language") ?? "fr" }
        set { defaults.set(newValue, forKey: "language") }
    }

    var fontSize: String {
        get { defaults.string(forKey: "fontSize") ?? "Normal" }
        set { defaults.set(newValue, forKey: "fontSize") }
    }

    var temperatureUnit: String {
        get { defaults.string(forKey: "temperatureUnit") ?? "Celsius" }
        set { defaults.set(newValue, forKey: "temperatureUnit") }
    }

    // Behavior
    var hapticIntensity: String {
        get { defaults.string(forKey: "hapticIntensity") ?? "Medium" }
        set { defaults.set(newValue, forKey: "hapticIntensity") }
    }

    var soundEnabled: Bool {
        get { defaults.bool(forKey: "soundEnabled") }
        set { defaults.set(newValue, forKey: "soundEnabled") }
    }

    var flashEnabled: Bool {
        get { defaults.bool(forKey: "flashEnabled") }
        set { defaults.set(newValue, forKey: "flashEnabled") }
    }

    var repeatDelay: Double {
        get { defaults.double(forKey: "repeatDelay") }
        set { defaults.set(newValue, forKey: "repeatDelay") }
    }

    var autoLockDisabled: Bool {
        get { defaults.bool(forKey: "autoLockDisabled") }
        set { defaults.set(newValue, forKey: "autoLockDisabled") }
    }

    // Remote Defaults
    var defaultLayout: String {
        get { defaults.string(forKey: "defaultLayout") ?? "3x3" }
        set { defaults.set(newValue, forKey: "defaultLayout") }
    }

    var buttonSizePercent: Double {
        get { defaults.double(forKey: "buttonSizePercent") }
        set { defaults.set(newValue, forKey: "buttonSizePercent") }
    }

    var showButtonNames: Bool {
        get { defaults.bool(forKey: "showButtonNames") }
        set { defaults.set(newValue, forKey: "showButtonNames") }
    }

    var showButtonIcons: Bool {
        get { defaults.bool(forKey: "showButtonIcons") }
        set { defaults.set(newValue, forKey: "showButtonIcons") }
    }

    // Security
    var lockTimeout: String {
        get { defaults.string(forKey: "lockTimeout") ?? "1 min" }
        set { defaults.set(newValue, forKey: "lockTimeout") }
    }

    var hideIRCodes: Bool {
        get { defaults.bool(forKey: "hideIRCodes") }
        set { defaults.set(newValue, forKey: "hideIRCodes") }
    }

    // Theme
    var themeName: String {
        get { defaults.string(forKey: "themeName") ?? "Clair" }
        set { defaults.set(newValue, forKey: "themeName") }
    }

    func resetAll() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
    }
}
