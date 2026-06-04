import SwiftUI

@main
struct IRRemoteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @StateObject private var themeManager = ThemeManager.shared

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            AppCoordinator(hasSeenOnboarding: hasSeenOnboarding)
                .environment(\.managedObjectContext, persistenceController.viewContext)
                .environmentObject(themeManager)
                .onAppear {
                    if hasSeenOnboarding {
                        applySavedTheme()
                    }
                }
        }
    }

    private func applySavedTheme() {
        let defaults = UserDefaults.standard
        if let themeName = defaults.string(forKey: "selectedTheme") {
            if let theme = themeManager.availableThemes.first(where: { $0.name == themeName }) {
                themeManager.applyTheme(theme)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        AppLogger.info("App launched", category: AppLogger.core)
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        PersistenceController.shared.save()
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        AppState.shared.orientationLock
    }
}
