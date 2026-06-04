import SwiftUI

struct AppCoordinator: View {
    let hasSeenOnboarding: Bool
    @ObservedObject private var appState = AppState.shared

    var body: some View {
        if hasSeenOnboarding {
            MainTabView()
                .transition(.opacity)
        } else {
            OnboardingView()
                .transition(.opacity)
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Accueil", systemImage: "house.fill")
                }
                .tag(0)

            ScenarioListView()
                .tabItem {
                    Label("Scénarios", systemImage: "play.rectangle.fill")
                }
                .tag(1)

            HistoryView()
                .tabItem {
                    Label("Historique", systemImage: "clock.fill")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Label("Paramètres", systemImage: "gear")
                }
                .tag(3)
        }
        .accentColor(themeManager.currentTheme.colors.primary)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(themeManager.currentTheme.colors.surface)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
