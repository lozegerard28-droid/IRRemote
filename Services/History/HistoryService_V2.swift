import Foundation
import CoreData

@MainActor
class HistoryService {
    static let shared = HistoryService()
    private let maxEvents = 500

    func recordEvent(remoteName: String, buttonName: String, irCode: String, success: Bool) {
        let context = PersistenceController.shared.container.viewContext
        let event = HistoryEvent(context: context)
        event.id = UUID()
        event.timestamp = Date()
        event.remoteName = remoteName
        event.buttonName = buttonName
        event.irCode = irCode
        event.success = success
        PersistenceController.shared.save()
        trimHistory()
    }

    func getRecentEvents(limit: Int = 50) -> [HistoryEvent] {
        let request = HistoryEvent.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.fetchLimit = limit
        return (try? PersistenceController.shared.container.viewContext.fetch(request)) ?? []
    }

    func getEvents(filter: HistoryFilter) -> [HistoryEvent] {
        let request = HistoryEvent.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        var predicates: [NSPredicate] = []
        if let name = filter.remoteName { predicates.append(NSPredicate(format: "remoteName == %@", name)) }
        if let start = filter.startDate { predicates.append(NSPredicate(format: "timestamp >= %@", start as NSDate)) }
        if let end = filter.endDate { predicates.append(NSPredicate(format: "timestamp <= %@", end as NSDate)) }
        if filter.successOnly == true { predicates.append(NSPredicate(format: "success == YES")) }
        request.predicate = predicates.isEmpty ? nil : NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        return (try? PersistenceController.shared.container.viewContext.fetch(request)) ?? []
    }

    func clearAll() {
        let context = PersistenceController.shared.container.viewContext
        let delete = NSBatchDeleteRequest(entityName: "HistoryEvent")
        try? context.execute(delete)
        context.reset()
        PersistenceController.shared.save()
    }

    private func trimHistory() {
        let context = PersistenceController.shared.container.viewContext
        let request = HistoryEvent.fetchRequest()
        let count = (try? context.count(for: request)) ?? 0
        if count > maxEvents {
            request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
            request.fetchLimit = count - maxEvents
            if let old = try? context.fetch(request) {
                old.forEach { context.delete($0) }
                PersistenceController.shared.save()
            }
        }
    }
}
