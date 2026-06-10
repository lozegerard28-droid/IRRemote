import SwiftUI
import Combine

@MainActor
final class RemoteControlViewModel: ObservableObject {
    @Published var remote: Remote?
    @Published var isSending = false
    @Published var isLandscape = false
    @Published var isLocked = false
    @Published var showEdit = false
    @Published var lastSentButton: String?

    private var repeatTask: Task<Void, Never>?

    func loadRemote(_ remote: Remote) {
        self.remote = remote
        isLocked = remote?.room?.isLocked ?? false
    }

    func sendIR(button: Button) {
        guard !isSending else { return }
        isSending = true
        lastSentButton = button.name

        HapticService.shared.play()
        FlashService.shared.flash()
        AudioService.shared.play()

        Task {
            defer {
                isSending = false
            }
            do {
                let proto = ProtocolType(rawValue: button.irProtocol ?? "NEC") ?? .nec
                try await IRTransmitterService.shared.send(code: button.irCode, protocol: proto)
                HistoryService.shared.recordEvent(
                    remoteName: remote?.name ?? "",
                    buttonName: button.name,
                    irCode: button.irCode,
                    roomName: remote?.room?.name,
                    context: PersistenceController.shared.viewContext
                )
            } catch {
                Logger.ir.error("Send failed: \(error.localizedDescription)")
            }
        }
    }

    func startRepeat(button: Button) {
        let interval = PreferencesManager.shared.repeatDelay > 0 ? PreferencesManager.shared.repeatDelay : 0.3
        repeatTask = Task {
            while !Task.isCancelled {
                sendIR(button: button)
                try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            }
        }
    }

    func stopRepeat() {
        repeatTask?.cancel()
        repeatTask = nil
    }

    func toggleFavorite() {
        guard let remote = remote else { return }
        remote.isFavorite.toggle()
        PersistenceController.shared.save()
    }

    func authenticateIfNeeded() async {
        guard isLocked else { return }
        do {
            let success = try await BiometricService.shared.authenticate()
            if success { isLocked = false }
        } catch {
            Logger.security.error("Auth failed: \(error.localizedDescription)")
        }
    }

    deinit {
        repeatTask?.cancel()
    }
}
