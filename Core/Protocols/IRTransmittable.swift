import Foundation

protocol IRTransmittable {
    var id: String { get }
    var name: String { get }
    var manufacturer: String { get }
    var capabilities: DongleCapabilities { get }
    func connect() async throws
    func disconnect()
    func send(code: String, protocol: ProtocolType) async throws
    func startReceiving() -> AsyncStream<String>
    func stopReceiving()
}
