import Foundation

struct BackupDTO: Codable {
    let manifest: Manifest
    let remotes: [RemoteDTO.RemoteContent]?
    let rooms: [RoomDTO]?
    let scenarios: [ScenarioDTO]?
    let settings: [String: String]?

    struct Manifest: Codable {
        let version: String
        let exportedAt: Date
        let appVersion: String
        let entityCount: Int
    }

    struct RoomDTO: Codable {
        let name: String
        let icon: String
        let sortOrder: Int
        let isLocked: Bool
    }

    struct ScenarioDTO: Codable {
        let name: String
        let icon: String
        let isFavorite: Bool
        let steps: [ScenarioStepDTO]
    }

    struct ScenarioStepDTO: Codable {
        let remoteName: String
        let buttonName: String
        let delay: Double
        let sortOrder: Int
    }
}
