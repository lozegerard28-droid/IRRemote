import SwiftUI

@MainActor
final class OnboardingCoordinator: ObservableObject {
    @Published var isCompleted: Bool {
        didSet {
            UserDefaults.standard.set(isCompleted, forKey: "onboarding.completed")
        }
    }

    init() {
        isCompleted = UserDefaults.standard.bool(forKey: "onboarding.completed")
    }

    func complete() {
        isCompleted = true
    }

    func reset() {
        isCompleted = false
    }
}
