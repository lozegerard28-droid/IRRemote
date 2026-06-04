import Foundation
import UIKit
import CoreData

class BackupService: Backupable {
    static let shared = BackupService()

    func createBackup(includeHistory: Bool = true) async throws -> URL {
        let context = PersistenceController.shared.viewContext

        let remoteRequest = Remote.fetchRequest()
        remoteRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let remotes = (try? context.fetch(remoteRequest)) ?? []
        let remoteDTOs = remotes.map { remote -> RemoteDTO in
            let buttons = (remote.buttons ?? []).sorted { $0.sortOrder < $1.sortOrder }.map { button in
                RemoteButtonDTO(
                    name: button.name,
                    code: button.irCode,
                    protocolType: button.protocolType,
                    bits: button.bitCount,
                    category: button.category,
                    colorHex: button.colorHex
                )
            }
            return RemoteDTO(
                version: "1.0",
                remote: RemoteDTO.RemoteData(
                    name: remote.name,
                    icon: remote.icon,
                    category: remote.category,
                    manufacturer: remote.manufacturer,
                    model: remote.modelName,
                    deviceType: remote.category,
                    layout: nil,
                    buttons: buttons
                ),
                metadata: ExportMetadata(
                    exportedAt: ISO8601DateFormatter().string(from: Date()),
                    appVersion: "1.0.0",
                    deviceModel: UIDevice.current.model,
                    iOSVersion: UIDevice.current.systemVersion
                )
            )
        }

        let roomRequest = Room.fetchRequest()
        let rooms = (try? context.fetch(roomRequest)) ?? []
        let roomDTOs = rooms.map { room in
            RoomDTO(
                id: room.id.uuidString,
                name: room.name,
                icon: room.icon,
                sortOrder: room.sortOrder,
                isLocked: room.isLocked,
                remoteIDs: (room.remotes ?? []).map { $0.id.uuidString }
            )
        }

        let scenarioRequest = Scenario.fetchRequest()
        let scenarios = (try? context.fetch(scenarioRequest)) ?? []
        let scenarioDTOs = scenarios.map { scenario in
            ScenarioDTO(
                id: scenario.id.uuidString,
                name: scenario.name,
                icon: scenario.icon,
                steps: (scenario.steps ?? []).sorted { $0.sortOrder < $1.sortOrder }.map { step in
                    ScenarioStepDTO(
                        remoteID: step.button?.remote?.id.uuidString ?? "",
                        buttonID: step.button?.id.uuidString ?? "",
                        delay: step.delay,
                        sortOrder: step.sortOrder
                    )
                }
            )
        }

        var historyDTOs: [HistoryEventDTO]? = nil
        if includeHistory {
            let historyRequest = HistoryEvent.fetchRequest()
            historyRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            historyRequest.fetchLimit = 500
            let events = (try? context.fetch(historyRequest)) ?? []
            historyDTOs = events.map { event in
                HistoryEventDTO(
                    timestamp: ISO8601DateFormatter().string(from: event.timestamp),
                    remoteName: event.remoteName,
                    buttonName: event.buttonName,
                    irCode: event.irCode,
                    success: event.success
                )
            }
        }

        let backup = BackupDTO(
            version: "1.0",
            createdAt: ISO8601DateFormatter().string(from: Date()),
            appVersion: "1.0.0",
            deviceName: UIDevice.current.name,
            remotes: remoteDTOs,
            rooms: roomDTOs,
            scenarios: scenarioDTOs,
            history: historyDTOs,
            settings: SettingsDTO(
                themeName: nil,
                hapticIntensity: nil,
                flashEnabled: nil,
                soundEnabled: nil,
                buttonLayout: nil,
                lockDelay: nil,
                language: nil
            )
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(backup)
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("IRRemote_Backup_\(Int(Date().timeIntervalSince1970))")
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
        let context = PersistenceController.shared.viewContext

        for roomDTO in backup.rooms {
            let room = Room(context: context)
            room.id = UUID(uuidString: roomDTO.id) ?? UUID()
            room.name = roomDTO.name
            room.icon = roomDTO.icon
            room.sortOrder = roomDTO.sortOrder
            room.isLocked = roomDTO.isLocked
        }
        for remoteDTO in backup.remotes {
            let remote = Remote(context: context)
            remote.id = UUID()
            remote.name = remoteDTO.remote.name
            remote.icon = remoteDTO.remote.icon
            remote.category = remoteDTO.remote.category
            remote.manufacturer = remoteDTO.remote.manufacturer
            remote.modelName = remoteDTO.remote.model
            remote.createdAt = Date()
            remote.updatedAt = Date()
            remote.sortOrder = 0
            if let roomIDStr = backup.rooms.first(where: { $0.remoteIDs.contains(remote.id.uuidString) })?.id,
               let roomUUID = UUID(uuidString: roomIDStr),
               let room = try? context.fetch(Room.fetchRequest()).first(where: { $0.id == roomUUID }) {
                remote.room = room
            }
            for (i, btnDTO) in remoteDTO.remote.buttons.enumerated() {
                let button = Button(context: context)
                button.id = UUID()
                button.name = btnDTO.name
                button.irCode = btnDTO.code
                button.protocolType = btnDTO.protocolType
                button.bitCount = btnDTO.bits ?? 32
                button.sortOrder = Int16(i)
                button.remote = remote
            }
        }
        PersistenceController.shared.save()
    }
}
