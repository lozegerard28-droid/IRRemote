import Foundation
import CoreData

@objc(Remote)
final class Remote: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var icon: String
    @NSManaged var isFavorite: Bool
    @NSManaged var sortOrder: Int16
    @NSManaged var manufacturer: String?
    @NSManaged var model: String?
    @NSManaged var columns: Int16
    @NSManaged var rows: Int16
    @NSManaged var createdAt: Date
    @NSManaged var updatedAt: Date

    @NSManaged var buttons: Set<Button>
    @NSManaged var room: Room?
    @NSManaged var scenarioSteps: Set<ScenarioStep>
}

extension Remote {
    var sortedButtons: [Button] {
        buttons.sorted { $0.sortOrder < $1.sortOrder }
    }
}
