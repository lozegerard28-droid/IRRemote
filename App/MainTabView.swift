import SwiftUI

struct MainTabView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            HomeView()
                .tabItem {
                    Label("Accueil", systemImage: "house")
                }
                .tag(AppCoordinator.Tab.home)

            HistoryView()
                .tabItem {
                    Label("Historique", systemImage: "clock")
                }
                .tag(AppCoordinator.Tab.history)

            SettingsView()
                .tabItem {
                    Label("Paramètres", systemImage: "gearshape")
                }
                .tag(AppCoordinator.Tab.settings)
        }
        .environmentObject(coordinator)
    }
}
