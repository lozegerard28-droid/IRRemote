import Foundation
import ZIPFoundation

final class BackupService {
    static let shared = BackupService()

    func createBackup(context: NSManagedObjectContext) throws -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let backupDir = tempDir.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: backupDir, withIntermediateDirectories: true)

        // Export remotes
        let remoteFetch = NSFetchRequest<Remote>(entityName: "Remote")
        let remotes = try context.fetch(remoteFetch)
        let remoteDTOs = remotes.map { remote -> RemoteDTO.RemoteContent in
            RemoteDTO.RemoteContent(
                name: remote.name,
                icon: remote.icon,
                category: nil,
                manufacturer: remote.manufacturer,
                model: remote.model,
                layout: RemoteDTO.Layout(columns: Int(remote.columns), rows: Int(remote.rows)),
                buttons: remote.sortedButtons.map { button in
                    ButtonDTO(
                        name: button.name,
                        code: button.irCode,
                        protocol: button.irProtocol,
                        bits: Int(button.bitCount),
                        category: button.category,
                        color: button.color,
                        row: Int(button.row),
                        col: Int(button.col)
                    )
                }
            )
        }

        let remotesData = try JSONEncoder().encode(remoteDTOs)
        try remotesData.write(to: backupDir.appendingPathComponent("remotes.json"))

        // Export rooms
        let roomFetch = NSFetchRequest<Room>(entityName: "Room")
        let rooms = try context.fetch(roomFetch)
        let roomDTOs = rooms.map {
            BackupDTO.RoomDTO(name: $0.name, icon: $0.icon, sortOrder: Int($0.sortOrder), isLocked: $0.isLocked)
        }
        let roomsData = try JSONEncoder().encode(roomDTOs)
        try roomsData.write(to: backupDir.appendingPathComponent("rooms.json"))

        // Create ZIP
        let zipURL = tempDir.appendingPathComponent("IRRemote_\(Date().timeIntervalSince1970).irbackup")
        try FileManager.default.zipItem(at: backupDir, to: zipURL)
        try FileManager.default.removeItem(at: backupDir)

        Logger.app.info("Backup created at \(zipURL.path)")
        return zipURL
    }

    func restoreBackup(url: URL, context: NSManagedObjectContext) throws {
        let tempDir = FileManager.default.temporaryDirectory
        let extractDir = tempDir.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: extractDir, withIntermediateDirectories: true)
        try FileManager.default.unzipItem(at: url, to: extractDir)

        // Restore rooms
        let roomsURL = extractDir.appendingPathComponent("rooms.json")
        if FileManager.default.fileExists(atPath: roomsURL.path) {
            let data = try Data(contentsOf: roomsURL)
            let roomDTOs = try JSONDecoder().decode([BackupDTO.RoomDTO].self, from: data)
            for dto in roomDTOs {
                let room = Room(context: context)
                room.id = UUID()
                room.name = dto.name
                room.icon = dto.icon
                room.sortOrder = Int16(dto.sortOrder)
                room.isLocked = dto.isLocked
            }
        }

        // Restore remotes
        let remotesURL = extractDir.appendingPathComponent("remotes.json")
        if FileManager.default.fileExists(atPath: remotesURL.path) {
            let data = try Data(contentsOf: remotesURL)
            let remoteDTOs = try JSONDecoder().decode([RemoteDTO.RemoteContent].self, from: data)
            for dto in remoteDTOs {
                let remote = Remote(context: context)
                remote.id = UUID()
                remote.name = dto.name
                remote.icon = dto.icon
                remote.manufacturer = dto.manufacturer
                remote.model = dto.model
                remote.columns = Int16(dto.layout?.columns ?? 3)
                remote.rows = Int16(dto.layout?.rows ?? 3)
                for (index, bdto) in dto.buttons.enumerated() {
                    let button = Button(context: context)
                    button.id = UUID()
                    button.name = bdto.name
                    button.irCode = bdto.code
                    button.irProtocol = bdto.protocol
                    button.bitCount = Int16(bdto.bits ?? 32)
                    button.category = bdto.category
                    button.color = bdto.color
                    button.sortOrder = Int16(index)
                    button.row = Int16(bdto.row ?? index / 3)
                    button.col = Int16(bdto.col ?? index % 3)
                    button.remote = remote
                }
            }
        }

        try context.save()
        try FileManager.default.removeItem(at: extractDir)
        Logger.app.info("Backup restored from \(url.path)")
    }
}
