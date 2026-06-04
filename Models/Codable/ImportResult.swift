import Foundation

struct ImportResult {
    let remoteName: String
    let roomName: String?
    let buttons: [RemoteButtonDTO]
    let errors: [String]
    let warnings: [String]
    
    var hasErrors: Bool { !errors.isEmpty }
    var hasWarnings: Bool { !warnings.isEmpty }
    var buttonCount: Int { buttons.count }
}