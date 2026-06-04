import Foundation

protocol DongleDriver: AnyObject {
    var id: String { get }
    var name: String { get }
    var manufacturer: String { get }
    var capabilities: DongleCapabilities { get }
    func connect() async throws
    func disconnect()
    func send(code: String, protocolType: IRProtocol) async throws
    func startReceiving() -> AsyncStream<ReceivedIRCode>
    func stopReceiving()
}

struct DongleCapabilities: OptionSet {
    let rawValue: Int
    static let transmit = DongleCapabilities(rawValue: 1 << 0)
    static let receive = DongleCapabilities(rawValue: 1 << 1)
    static let learning = DongleCapabilities(rawValue: 1 << 2)
    static let rawMode = DongleCapabilities(rawValue: 1 << 3)
}
