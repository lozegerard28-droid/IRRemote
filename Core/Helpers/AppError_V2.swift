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
    case restoreFailed(String)
    case themeInvalid(String)
    case permissionDenied(String)
    case importFailed(String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .fileInvalid(let detail): return "Fichier invalide : \(detail)"
        case .fileEmpty: return "Le fichier est vide"
        case .dongleNotConnected: return "Aucun dongle connect\u00e9"
        case .dongleNotSupported: return "Dongle non support\u00e9"
        case .irSendFailed: return "\u00c9chec d'envoi du code IR"
        case .protocolNotSupported(let p): return "Protocole non support\u00e9 : \(p)"
        case .biometricUnavailable: return "Biom\u00e9trie non disponible"
        case .authenticationFailed: return "Authentification \u00e9chou\u00e9e"
        case .coreDataCorrupted: return "Base de donn\u00e9es corrompue"
        case .backupFailed(let d): return "Sauvegarde \u00e9chou\u00e9e : \(d)"
        case .restoreFailed(let d): return "Restauration \u00e9chou\u00e9e : \(d)"
        case .themeInvalid(let d): return "Th\u00e8me invalide : \(d)"
        case .permissionDenied(let d): return "Permission refus\u00e9e : \(d)"
        case .importFailed(let d): return "Import \u00e9chou\u00e9 : \(d)"
        case .unknown(let d): return "Erreur inconnue : \(d)"
        }
    }
}
