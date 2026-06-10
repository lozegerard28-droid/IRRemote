import Foundation

struct ButtonDTO: Codable {
    let name: String
    let code: String
    let `protocol`: String?
    let bits: Int?
    let category: String?
    let color: String?
    let row: Int?
    let col: Int?
}
