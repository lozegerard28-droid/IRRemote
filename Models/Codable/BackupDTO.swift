import Foundation

struct BackupDTO: Codable {
    let version: String
    let createdAt: String
    let appVersion: String
    let deviceName: String?
    let remotes: [RemoteDTO]
    let rooms: [RoomDTO]
    let scenarios: [ScenarioDTO]
    let history: [HistoryEventDTO]?
    let settings: SettingsDTO?
}

struct RoomDTO: Codable {
    let id: String
    let name: String
    let icon: String?
    let sortOrder: Int16
    let isLocked: Bool
    let remoteIDs: [String]
}

struct ScenarioDTO: Codable {
    let id: String
    let name: String
    let icon: String?
    let steps: [ScenarioStepDTO]
}

struct ScenarioStepDTO: Codable {
    let remoteID: String
    let buttonID: String
    let delay: Double
    let sortOrder: Int16
}

struct HistoryEventDTO: Codable {
    let timestamp: String
    let remoteName: String
    let buttonName: String
    let irCode: String
    let success: Bool
}

struct SettingsDTO: Codable {
    let themeName: String?
    let hapticIntensity: String?
    let flashEnabled: Bool?
    let soundEnabled: Bool?
    let buttonLayout: String?
    let lockDelay: Int?
    let language: String?
}