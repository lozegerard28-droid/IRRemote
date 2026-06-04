import Foundation

struct RemoteButtonDTO: Codable {
    let name: String
    let code: String
    let protocolType: String?
    let bits: Int16?
    let category: String?
    let colorHex: String?
    
    enum CodingKeys: String, CodingKey {
        case name, code, bits, category, colorHex
        case protocolType = "protocol"
    }
}