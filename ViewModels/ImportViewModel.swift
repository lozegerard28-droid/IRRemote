import SwiftUI
import UniformTypeIdentifiers

class ImportViewModel: ObservableObject {
    @Published var importResult: ImportResult?
    @Published var isImporting = false
    @Published var importError: String?
    @Published var showNameDialog = false
    @Published var remoteName = ""
    @Published var selectedRoom: Room?
    @Published var availableRooms: [Room] = []

    private let csvService = CSVImportService()
    private let jsonService = JSONImportService()

    func handleFile(url: URL) async {
        isImporting = true
        importError = nil
        defer { isImporting = false }

        do {
            let extension_ = url.pathExtension.lowercased()
            let buttons: [RemoteButtonDTO]

            switch extension_ {
            case "csv":
                buttons = try await csvService.importFile(url: url)
            case "json", "irremote":
                let remoteDTO = try await jsonService.importFile(url: url)
                buttons = remoteDTO.remote.buttons
            default:
                throw AppError.fileInvalid("Extension non supportée: \(extension_)")
            }

            guard !buttons.isEmpty else {
                throw AppError.fileEmpty
            }

            await MainActor.run {
                importResult = ImportResult(remoteName: "", roomName: nil, buttons: buttons, errors: [], warnings: [])
                showNameDialog = true
                availableRooms = (try? PersistenceController.shared.viewContext.fetch(Room.fetchRequest())) ?? []
            }
        } catch {
            await MainActor.run { importError = error.localizedDescription }
        }
    }

    func confirmImport() {
        guard let result = importResult, !remoteName.isEmpty else { return }
        let context = PersistenceController.shared.viewContext

        let remote = Remote(context: context)
        remote.id = UUID()
        remote.name = remoteName
        remote.icon = "remote.fill"
        remote.createdAt = Date()
        remote.updatedAt = Date()
        remote.sortOrder = 0

        for (i, btnDTO) in result.buttons.enumerated() {
            let button = Button(context: context)
            button.id = UUID()
            button.name = btnDTO.name
            button.irCode = btnDTO.code
            button.protocolType = btnDTO.protocolType ?? "NEC"
            button.bitCount = btnDTO.bits ?? 32
            button.colorHex = btnDTO.colorHex
            button.sortOrder = Int16(i)
            button.remote = remote
        }

        if let room = selectedRoom {
            remote.room = room
        }

        PersistenceController.shared.save()
        reset()
    }

    func reset() {
        importResult = nil
        importError = nil
        remoteName = ""
        selectedRoom = nil
        showNameDialog = false
    }
}
