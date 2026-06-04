import Foundation

struct RemoteDTO: Codable {
    let version: String
    let remote: RemoteData
    let metadata: ExportMetadata?
    
    struct RemoteData: Codable {
        let name: String
        let icon: String?
        let category: String?
        let manufacturer: String?
        let model: String?
        let deviceType: String?
        let layout: RemoteLayout?
        let buttons: [RemoteButtonDTO]
    }
    
    struct RemoteLayout: Codable {
        let columns: Int?
        let rows: Int?
        let buttonSpacing: Double?
        let buttonSize: String?
    }
}

struct ExportMetadata: Codable {
    let exportedAt: String
    let appVersion: String
    let deviceModel: String?
    let iOSVersion: String?
}