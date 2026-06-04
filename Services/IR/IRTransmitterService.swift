import Foundation

class IRTransmitterService: IRTransmittable {
    static let shared = IRTransmitterService()
    private var isSending = false
    
    func send(code: String, protocolType: IRProtocol, bits: Int) async throws {
        guard !isSending else { throw AppError.irSendFailed }
        isSending = true
        defer { isSending = false }
        guard DongleManager.shared.isConnected else {
            throw AppError.dongleNotConnected
        }
        try await DongleManager.shared.sendIR(code: code, protocolType: protocolType)
    }
    
    func sendRaw(data: Data) async throws {
        guard DongleManager.shared.isConnected else {
            throw AppError.dongleNotConnected
        }
        // Raw IR sending
        try await Task.sleep(nanoseconds: 100_000)
    }
}