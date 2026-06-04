import Foundation

class CSVImportService: Importable {
    typealias ResultType = [RemoteButtonDTO]
    var supportedExtensions: [String] { ["csv"] }
    
    func importFile(url: URL) async throws -> [RemoteButtonDTO] {
        return try CSVParser.parse(url: url)
    }
}