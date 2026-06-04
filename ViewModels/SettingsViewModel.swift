import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var themeMode: ThemeMode = .system
    @Published var hapticIntensity: HapticIntensity = .medium
    @Published var flashEnabled = false
    @Published var soundEnabled = false
    @Published var buttonLayout: String = "3x3"
    @Published var language: Language = .french
    @Published var lockDelay: Int = 1

    @Published var isExporting = false
    @Published var showResetAlert = false

    let appVersion = "1.0.0"
    let dataVersion = "1.0"

    func exportBackup() async {
        isExporting = true
        defer { isExporting = false }
        do {
            let url = try await BackupService.shared.createBackup(includeHistory: true)
            await MainActor.run {
                let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let root = scene.windows.first?.rootViewController {
                    root.present(av, animated: true)
                }
            }
        } catch {
            AppLogger.error("Export failed: \(error)", category: AppLogger.core)
        }
    }

    func resetAllData() {
        let context = PersistenceController.shared.viewContext
        let entities = ["Remote", "Button", "Room", "Scenario", "ScenarioStep", "HistoryEvent"]
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try? context.execute(delete)
        }
        PersistenceController.shared.save()
    }
}
