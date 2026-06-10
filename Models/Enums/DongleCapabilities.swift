import Foundation

struct DongleCapabilities: OptionSet, Codable {
    let rawValue: Int

    static let irTransmit = DongleCapabilities(rawValue: 1 << 0)
    static let irReceive = DongleCapabilities(rawValue: 1 << 1)
    static let rawMode = DongleCapabilities(rawValue: 1 << 2)
    static let learning = DongleCapabilities(rawValue: 1 << 3)

    static let all: DongleCapabilities = [.irTransmit, .irReceive, .rawMode, .learning]
}
