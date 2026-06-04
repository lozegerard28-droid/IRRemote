import Foundation

protocol Importable {
    associatedtype ResultType
    func importFile(url: URL) async throws -> ResultType
}

protocol Exportable {
    associatedtype ExportType
    func export(data: ExportType) throws -> URL
    var supportedExtensions: [String] { get }
}
