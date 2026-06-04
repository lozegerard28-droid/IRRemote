import Foundation

protocol IRTransmittable {
    func send(code: String, protocolType: IRProtocol, bits: Int) async throws
    func sendRaw(data: Data) async throws
}

protocol IRReceivable {
    func startReceiving() -> AsyncStream<ReceivedIRCode>
    func stopReceiving()
}

struct ReceivedIRCode {
    let code: String
    let protocolType: IRProtocol
    let bits: Int
    let quality: Float
}
