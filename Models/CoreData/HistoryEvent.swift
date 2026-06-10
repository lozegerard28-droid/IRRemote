import Foundation
import CoreData

@objc(HistoryEvent)
final class HistoryEvent: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var timestamp: Date
    @NSManaged var remoteName: String
    @NSManaged var buttonName: String
    @NSManaged var irCode: String
    @NSManaged var roomName: String?
}
