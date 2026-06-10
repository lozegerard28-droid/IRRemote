import Foundation

protocol Exportable {
    associatedtype ExportData
    func export(data: ExportData) throws -> URL
    func fileExtension() -> String
}
