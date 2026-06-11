import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            RemoteListView()
                .tabItem { Label("Télécommandes", systemImage: "remote") }
                .tag(0)

            ImportView()
                .tabItem { Label("Importer", systemImage: "square.and.arrow.down") }
                .tag(1)

            SettingsView()
                .tabItem { Label("Réglages", systemImage: "gearshape") }
                .tag(2)
        }
    }
}
