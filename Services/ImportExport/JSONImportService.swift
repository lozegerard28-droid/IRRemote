import Foundation

class JSONImportService: Importable {
    typealias ResultType = RemoteDTO
    var supportedExtensions: [String] { ["json", "irremote"] }
    
    func importFile(url: URL) async throws -> RemoteDTO {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(RemoteDTO.self, from: data)
    }
}