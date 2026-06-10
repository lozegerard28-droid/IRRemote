import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {
    static let shared = AppState()

    @Published var selectedRoom: Room?
    @Published var selectedRemote: Remote?
    @Published var selectedScenario: Scenario?
    @Published var isPresented: Bool = false
    @Published var activeScenario: Scenario?
    @Published var currentTheme: ThemeDTO?
    @Published var securityState: SecurityState = .unlocked
    @Published var dongleConnected: Bool = false
    @Published var showOnboarding: Bool = false

    enum SecurityState {
        case locked
        case unlocked
        case authenticating
    }

    private let defaults = UserDefaults.standard

    private init() {
        showOnboarding = !defaults.bool(forKey: "onboarding.completed")
    }

    func completeOnboarding() {
        showOnboarding = false
        defaults.set(true, forKey: "onboarding.completed")
    }

    func resetOnboarding() {
        defaults.set(false, forKey: "onboarding.completed")
        showOnboarding = true
    }
}
