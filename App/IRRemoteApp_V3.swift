import SwiftUI

@main
struct IRRemoteApp: App {
    @StateObject private var appState = AppState.shared
    @StateObject private var themeManager = ThemeManager.shared
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appState)
                .environmentObject(themeManager)
                .environment(\.managedObjectContext, persistenceController.viewContext)
                .onAppear { applyTheme() }
                .onReceive(themeManager.themeChanged) { _ in applyTheme() }
        }
    }

    private func applyTheme() {
        let theme = themeManager.activeTheme
        UIView.appearance().tintColor = UIColor(Color(hex: theme.colors.primary))
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.windows.first?.overrideUserInterfaceStyle = theme.name == "Sombre" || theme.name == "Bleu Nuit" ? .dark : .light
        }
    }
}
