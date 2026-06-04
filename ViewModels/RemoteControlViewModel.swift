import SwiftUI
import Combine

class RemoteControlViewModel: ObservableObject {
    @Published var currentRemote: Remote?
    @Published var buttons: [Button] = []
    @Published var isSending = false
    @Published var lastSentCode: String?
    @Published var orientation: UIDeviceOrientation = .portrait

    private let irService = IRTransmitterService.shared
    private let hapticService = HapticService.shared
    private let flashService = FlashService.shared
    private let historyService = HistoryService.shared
    private var cancellables = Set<AnyCancellable>()

    func loadRemote(_ remote: Remote) {
        currentRemote = remote
        if let buttonsSet = remote.buttons {
            buttons = buttonsSet.sorted { $0.sortOrder < $1.sortOrder }
        }
    }

    func sendCommand(button: Button) async {
        guard !isSending else { return }
        isSending = true
        defer { isSending = false }

        let code = button.irCode
        let proto = IRProtocol(rawValue: button.protocolType ?? "NEC") ?? .nec
        let bits = button.bitCount

        await MainActor.run { hapticService.playPressFeedback() }

        do {
            try await irService.send(code: code, protocolType: proto, bits: Int(bits))
            await MainActor.run {
                lastSentCode = code
                flashService.flash()
                historyService.recordEvent(
                    remoteName: currentRemote?.name ?? "",
                    buttonName: button.name,
                    irCode: code,
                    success: true
                )
            }
        } catch {
            await MainActor.run {
                hapticService.playErrorFeedback()
                historyService.recordEvent(
                    remoteName: currentRemote?.name ?? "",
                    buttonName: button.name,
                    irCode: code,
                    success: false
                )
            }
        }
    }

    func toggleOrientation() {
        orientation = orientation == .portrait ? .landscapeRight : .portrait
    }
}
