import SwiftUI

@main
struct IRRemoteApp: App {
    @StateObject private var appState = AppState.shared
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var onboardingCoordinator = OnboardingCoordinator()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Group {
                if !onboardingCoordinator.isCompleted {
                    OnboardingView()
                        .environmentObject(appState)
                        .environmentObject(onboardingCoordinator)
                } else {
                    MainTabView()
                        .environmentObject(appState)
                        .environmentObject(themeManager)
                        .environment(\.managedObjectContext, persistenceController.viewContext)
                }
            }
            .onAppear {
                applyTheme()
            }
            .onReceive(themeManager.themeChanged) { _ in
                applyTheme()
            }
        }
    }

    private func applyTheme() {
        let theme = themeManager.activeTheme
        let uiColor = UIColor(Color(hex: theme.colors.primary))

        UIView.appearance().tintColor = uiColor

        if theme.name == "Sombre" || theme.name == "Bleu Nuit" {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.overrideUserInterfaceStyle = .dark
            }
        } else {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.overrideUserInterfaceStyle = .light
            }
        }
    }
}
