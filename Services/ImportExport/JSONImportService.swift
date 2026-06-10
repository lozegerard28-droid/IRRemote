import Foundation

final class JSONImportService {
    static let shared = JSONImportService()
    private let parser = JSONParser()

    func importFrom(url: URL) async throws -> RemoteDTO {
        try await parser.parse(url: url)
    }
}
