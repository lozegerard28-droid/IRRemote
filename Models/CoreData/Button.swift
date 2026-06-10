import Foundation
import CoreData

@objc(Button)
final class Button: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var irCode: String
    @NSManaged var irProtocol: String?
    @NSManaged var bitCount: Int16
    @NSManaged var category: String?
    @NSManaged var color: String?
    @NSManaged var sortOrder: Int16
    @NSManaged var row: Int16
    @NSManaged var col: Int16

    @NSManaged var remote: Remote?
    @NSManaged var scenarioSteps: Set<ScenarioStep>
}
