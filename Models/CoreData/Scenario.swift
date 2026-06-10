import Foundation
import CoreData

@objc(Scenario)
final class Scenario: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var icon: String
    @NSManaged var isFavorite: Bool
    @NSManaged var createdAt: Date

    @NSManaged var steps: Set<ScenarioStep>
}

extension Scenario {
    var sortedSteps: [ScenarioStep] {
        steps.sorted { $0.sortOrder < $1.sortOrder }
    }
}
