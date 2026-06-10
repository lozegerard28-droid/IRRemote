import Foundation

struct JSONParser: Importable {
    typealias ImportResult = RemoteDTO

    func validate(url: URL) throws -> Bool {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw AppError.fileInvalid("File not found")
        }
        guard url.pathExtension.lowercased() == "json" else {
            throw AppError.fileInvalid("Not a JSON file")
        }
        return true
    }

    func parse(url: URL) async throws -> RemoteDTO {
        try validate(url: url)
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let dto = try decoder.decode(RemoteDTO.self, from: data)
            return dto
        } catch {
            throw AppError.fileInvalid("JSON parsing error: \(error.localizedDescription)")
        }
    }
}
