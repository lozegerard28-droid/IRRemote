import Foundation
import CoreData

@objc(ScenarioStep)
final class ScenarioStep: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var delay: Double
    @NSManaged var sortOrder: Int16

    @NSManaged var scenario: Scenario?
    @NSManaged var button: Button?
}
