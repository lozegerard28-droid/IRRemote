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
        case .dongleNotConnected: return "Aucun dongle connect\u{00e9}"
        case .dongleNotSupported: return "Dongle non support\u{00e9}"
        case .irSendFailed: return "\u{00c9}chec d'envoi du code IR"
        case .protocolNotSupported(let p): return "Protocole non support\u{00e9} : \(p)"
        case .biometricUnavailable: return "Biom\u{00e9}trie non disponible"
        case .authenticationFailed: return "Authentification \u{00e9}chou\u{00e9}e"
        case .coreDataCorrupted: return "Base de donn\u{00e9}es corrompue"
        case .backupFailed(let d): return "Sauvegarde \u{00e9}chou\u{00e9}e : \(d)"
        case .restoreFailed(let d): return "Restauration \u{00e9}chou\u{00e9}e : \(d)"
        case .themeInvalid(let d): return "Th\u{00e8}me invalide : \(d)"
        case .permissionDenied(let d): return "Permission refus\u{00e9}e : \(d)"
        case .importFailed(let d): return "Import \u{00e9}chou\u{00e9} : \(d)"
        case .unknown(let d): return "Erreur inconnue : \(d)"
        }
    }
}
