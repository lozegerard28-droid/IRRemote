import Foundation
import CoreData

@objc(Room)
final class Room: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var icon: String
    @NSManaged var sortOrder: Int16
    @NSManaged var isLocked: Bool
    @NSManaged var isDefault: Bool

    @NSManaged var remotes: Set<Remote>
}

extension Room {
    var sortedRemotes: [Remote] {
        remotes.sorted { $0.sortOrder < $1.sortOrder }
    }
}
