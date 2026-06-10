import Foundation

protocol Importable {
    associatedtype ImportResult
    func validate(url: URL) throws -> Bool
    func parse(url: URL) async throws -> ImportResult
}
