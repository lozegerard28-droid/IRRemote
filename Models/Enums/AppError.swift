import Foundation

enum AppError: LocalizedError {
    case fileInvalid(String)
    case fileEmpty
    case dongleNotConnected
    case dongleNotSupported
    case irSendFailed
    case protocolNotSupported(String)
    case biometricUnavailable
    case authenticationFailed
    case coreDataCorrupted
    case backupFailed(String)
    case themeInvalid(String)
    case permissionDenied(String)

    var errorDescription: String? {
        switch self {
        case .fileInvalid(let detail):
            return String(localized: "File invalid: \(detail)")
        case .fileEmpty:
            return String(localized: "The file is empty")
        case .dongleNotConnected:
            return String(localized: "No IR dongle connected")
        case .dongleNotSupported:
            return String(localized: "This dongle is not supported")
        case .irSendFailed:
            return String(localized: "Failed to send IR code")
        case .protocolNotSupported(let proto):
            return String(localized: "Protocol \(proto) is not supported by this dongle")
        case .biometricUnavailable:
            return String(localized: "Biometric authentication is not available on this device")
        case .authenticationFailed:
            return String(localized: "Authentication failed")
        case .coreDataCorrupted:
            return String(localized: "Database corrupted. Please reinstall the app.")
        case .backupFailed(let detail):
            return String(localized: "Backup failed: \(detail)")
        case .themeInvalid(let detail):
            return String(localized: "Theme invalid: \(detail)")
        case .permissionDenied(let detail):
            return String(localized: "Permission denied: \(detail)")
        }
    }
}
