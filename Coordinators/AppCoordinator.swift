import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var selectedTab: Tab = .home

    enum Tab {
        case home
        case history
        case settings
    }

    func navigateToRemote(_ remote: Remote) {
        path.append(remote)
    }

    func navigateToSettings() {
        selectedTab = .settings
    }

    func showImport() {
        // Handled via sheets in HomeView
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
