import Foundation

struct RemoteDTO: Codable {
    let version: String
    let remote: RemoteContent
    let metadata: Metadata?

    struct RemoteContent: Codable {
        let name: String
        let icon: String
        let category: String?
        let manufacturer: String?
        let model: String?
        let layout: Layout?
        let buttons: [ButtonDTO]
    }

    struct Layout: Codable {
        let columns: Int
        let rows: Int
    }

    struct Metadata: Codable {
        let exportedAt: Date
        let appVersion: String
    }
}
