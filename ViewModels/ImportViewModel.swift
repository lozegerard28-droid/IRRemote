import SwiftUI
import UniformTypeIdentifiers

@MainActor
final class ImportViewModel: ObservableObject {
    @Published var importedRows: [CSVRow] = []
    @Published var importedRemote: RemoteDTO?
    @Published var remoteName = ""
    @Published var selectedRoom: Room?
    @Published var rooms: [Room] = []
    @Published var showPreview = false
    @Published var errorMessage: String?
    @Published var isImporting = false
    @Published var importSource: ImportSource?

    enum ImportSource {
        case csv
        case json
        case manual
    }

    private let context = PersistenceController.shared.viewContext

    func loadRooms() {
        let fetch = NSFetchRequest<Room>(entityName: "Room")
        fetch.sortDescriptors = [NSSortDescriptor(key: "sortOrder", ascending: true)]
        rooms = (try? context.fetch(fetch)) ?? []
        selectedRoom = rooms.first
    }

    func importCSV(url: URL) async {
        isImporting = true
        defer { isImporting = false }
        do {
            let rows = try await CSVImportService.shared.importFrom(url: url)
            importedRows = rows
            importSource = .csv
            remoteName = url.deletingPathExtension().lastPathComponent
            showPreview = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func importJSON(url: URL) async {
        isImporting = true
        defer { isImporting = false }
        do {
            let dto = try await JSONImportService.shared.importFrom(url: url)
            importedRemote = dto
            importSource = .json
            remoteName = dto.remote.name
            showPreview = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func confirmImport() {
        guard let room = selectedRoom else { return }

        let remote = Remote(context: context)
        remote.id = UUID()
        remote.name = remoteName
        remote.icon = "remote"
        remote.isFavorite = false
        remote.manufacturer = importedRemote?.remote.manufacturer
        remote.model = importedRemote?.remote.model
        remote.columns = Int16(importedRemote?.remote.layout?.columns ?? 3)
        remote.rows = Int16(importedRemote?.remote.layout?.rows ?? 3)
        remote.createdAt = Date()
        remote.updatedAt = Date()
        remote.room = room

        if importSource == .csv {
            for (index, row) in importedRows.enumerated() {
                let button = Button(context: context)
                button.id = UUID()
                button.name = row.name
                button.irCode = row.irCode
                button.irProtocol = row.protocol
                button.bitCount = Int16(row.bits ?? 32)
                button.category = row.category
                button.color = row.color
                button.sortOrder = Int16(index)
                button.row = Int16(index / Int(remote.columns))
                button.col = Int16(index % Int(remote.columns))
                button.remote = remote
            }
        } else if importSource == .json, let dto = importedRemote {
            for (index, bdto) in dto.remote.buttons.enumerated() {
                let button = Button(context: context)
                button.id = UUID()
                button.name = bdto.name
                button.irCode = bdto.code
                button.irProtocol = bdto.protocol
                button.bitCount = Int16(bdto.bits ?? 32)
                button.category = bdto.category
                button.color = bdto.color
                button.sortOrder = Int16(index)
                button.row = Int16(bdto.row ?? index / Int(remote.columns))
                button.col = Int16(bdto.col ?? index % Int(remote.columns))
                button.remote = remote
            }
        }

        PersistenceController.shared.save()
        reset()
    }

    func reset() {
        importedRows = []
        importedRemote = nil
        remoteName = ""
        showPreview = false
        errorMessage = nil
        importSource = nil
    }
}
