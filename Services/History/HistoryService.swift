import Foundation
import CoreData

final class HistoryService {
    static let shared = HistoryService()

    private let maxEntries = 500

    func recordEvent(remoteName: String, buttonName: String, irCode: String, roomName: String?, context: NSManagedObjectContext) {
        let event = HistoryEvent(context: context)
        event.id = UUID()
        event.timestamp = Date()
        event.remoteName = remoteName
        event.buttonName = buttonName
        event.irCode = irCode
        event.roomName = roomName

        PersistenceController.shared.save()
        trimHistory(context: context)
    }

    func fetchRecent(context: NSManagedObjectContext, limit: Int = 100) -> [HistoryEvent] {
        let fetch = NSFetchRequest<HistoryEvent>(entityName: "HistoryEvent")
        fetch.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetch.fetchLimit = limit
        return (try? context.fetch(fetch)) ?? []
    }

    func fetchFiltered(context: NSManagedObjectContext, remoteName: String? = nil, roomName: String? = nil) -> [HistoryEvent] {
        let fetch = NSFetchRequest<HistoryEvent>(entityName: "HistoryEvent")
        fetch.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]

        var predicates: [NSPredicate] = []
        if let remoteName = remoteName {
            predicates.append(NSPredicate(format: "remoteName == %@", remoteName))
        }
        if let roomName = roomName {
            predicates.append(NSPredicate(format: "roomName == %@", roomName))
        }
        if !predicates.isEmpty {
            fetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }

        return (try? context.fetch(fetch)) ?? []
    }

    func clearAll(context: NSManagedObjectContext) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryEvent")
        let delete = NSBatchDeleteRequest(fetchRequest: fetch)
        try? context.execute(delete)
        PersistenceController.shared.save()
    }

    func exportToCSV(context: NSManagedObjectContext) -> URL {
        let events = fetchRecent(context: context, limit: maxEntries)
        var csv = "Date,Heure,Télécommande,Bouton,Code IR,Pièce\n"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd,HH:mm:ss"

        for event in events {
            let dateStr = formatter.string(from: event.timestamp)
            let room = event.roomName ?? ""
            csv += "\(dateStr),\(event.remoteName),\(event.buttonName),\(event.irCode),\(room)\n"
        }

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("IRRemote_History.csv")
        try? csv.write(to: url, atomically: true, encoding: .utf8)
        return url
    }

    private func trimHistory(context: NSManagedObjectContext) {
        let fetch = NSFetchRequest<HistoryEvent>(entityName: "HistoryEvent")
        fetch.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        guard let events = try? context.fetch(fetch), events.count > maxEntries else { return }

        let toDelete = events.suffix(events.count - maxEntries)
        for event in toDelete {
            context.delete(event)
        }
        PersistenceController.shared.save()
    }
}
