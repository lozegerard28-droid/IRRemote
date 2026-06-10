import SwiftUI
import CoreData

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published var events: [HistoryEvent] = []
    @Published var filterRemoteName: String?
    @Published var filterRoomName: String?
    @Published var remoteNames: [String] = []
    @Published var roomNames: [String] = []

    private let context = PersistenceController.shared.viewContext

    func loadHistory() {
        events = HistoryService.shared.fetchFiltered(
            context: context,
            remoteName: filterRemoteName,
            roomName: filterRoomName
        )
    }

    func loadFilterOptions() {
        let remoteFetch = NSFetchRequest<NSDictionary>(entityName: "Remote")
        remoteFetch.propertiesToFetch = ["name"]
        remoteFetch.resultType = .dictionaryResultType
        remoteNames = ((try? context.fetch(remoteFetch)) ?? []).compactMap { $0["name"] as? String }

        let roomFetch = NSFetchRequest<NSDictionary>(entityName: "Room")
        roomFetch.propertiesToFetch = ["name"]
        roomFetch.resultType = .dictionaryResultType
        roomNames = ((try? context.fetch(roomFetch)) ?? []).compactMap { $0["name"] as? String }
    }

    func clearAll() {
        HistoryService.shared.clearAll(context: context)
        loadHistory()
    }

    func exportCSV() -> URL {
        HistoryService.shared.exportToCSV(context: context)
    }

    func resend(_ event: HistoryEvent) {
        Task {
            do {
                try await IRTransmitterService.shared.send(code: event.irCode, protocol: .nec)
            } catch {
                Logger.ir.error("Resend failed: \(error.localizedDescription)")
            }
        }
    }
}
