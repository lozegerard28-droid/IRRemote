import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var preferences = PreferencesManager.shared
    @Published var themeManager = ThemeManager.shared
    @Published var showResetConfirmation = false
    @Published var showOnboarding = false

    func resetApp() {
        preferences.resetAll()
        let context = PersistenceController.shared.viewContext
        let entities = ["Remote", "Button", "Room", "Scenario", "ScenarioStep", "HistoryEvent", "ThemeEntity"]
        for entity in entities {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let delete = NSBatchDeleteRequest(fetchRequest: fetch)
            try? context.execute(delete)
        }
        try? context.save()
        Logger.app.info("App reset completed")
    }

    func exportBackup() -> URL? {
        try? BackupService.shared.createBackup(context: PersistenceController.shared.viewContext)
    }

    func importBackup(url: URL) {
        try? BackupService.shared.restoreBackup(url: url, context: PersistenceController.shared.viewContext)
    }

    func exportHistory() -> URL {
        HistoryService.shared.exportToCSV(context: PersistenceController.shared.viewContext)
    }

    func clearHistory() {
        HistoryService.shared.clearAll(context: PersistenceController.shared.viewContext)
    }
}
