import Foundation

class BackupService: Backupable {
    static let shared = BackupService()
    
    func createBackup(includeHistory: Bool = true) async throws -> URL {
        // Gather all data
        let backup = BackupDTO(
            version: "1.0",
            createdAt: ISO8601DateFormatter().string(from: Date()),
            appVersion: "1.0.0",
            deviceName: UIDevice.current.name,
            remotes: [],
            rooms: [],
            scenarios: [],
            history: includeHistory ? [] : nil,
            settings: SettingsDTO(themeName: nil, hapticIntensity: nil, flashEnabled: nil, soundEnabled: nil, buttonLayout: nil, lockDelay: nil, language: nil)
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(backup)
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("IRRemote_Backup_\(Date().timeIntervalSince1970)")
            .appendingPathExtension("irbackup")
        try data.write(to: url)
        AppLogger.info("Backup created at \(url.lastPathComponent)", category: AppLogger.core)
        return url
    }
    
    func restoreBackup(url: URL) async throws {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let backup = try decoder.decode(BackupDTO.self, from: data)
        AppLogger.info("Restoring backup from \(backup.createdAt)", category: AppLogger.core)
        // Restore logic here
    }
}