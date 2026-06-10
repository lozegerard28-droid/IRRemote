import Foundation

final class CSVImportService {
    static let shared = CSVImportService()
    private let parser = CSVParser()

    func importFrom(url: URL) async throws -> [CSVRow] {
        try await parser.parse(url: url)
    }
}
