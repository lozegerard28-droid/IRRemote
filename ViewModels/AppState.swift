import SwiftUI
import Combine

class AppState: ObservableObject {
    static let shared = AppState()

    @Published var selectedRoom: Room?
    @Published var selectedRemote: Remote?
    @Published var activeViewController: ActiveView = .home
    @Published var isPresented = false
    @Published var activeScenario: Scenario?
    @Published var currentTheme: IRTheme = .default
    @Published var securityState: SecurityState = .unlocked
    @Published var dongleState: DongleConnectionState = .disconnected
    @Published var orientationLock: UIInterfaceOrientationMask = .all

    enum ActiveView { case home, remote, settings, history, scenarios }
    enum SecurityState { case locked, unlocked, authenticating }
    enum DongleConnectionState { case disconnected, connecting, connected, error(String) }

    func navigateToRemote(_ remote: Remote) {
        selectedRemote = remote
        activeViewController = .remote
        isPresented = true
    }

    func navigateToHome() {
        selectedRemote = nil
        activeViewController = .home
        isPresented = false
    }

    func lockRoom(_ room: Room) {
        if room.isLocked { securityState = .locked }
    }

    func unlockRoom() async -> Bool {
        securityState = .authenticating
        do {
            let success = try await BiometricService.shared.authenticate(reason: "Déverrouiller la pièce")
            securityState = success ? .unlocked : .locked
            return success
        } catch {
            securityState = .locked
            return false
        }
    }
}
