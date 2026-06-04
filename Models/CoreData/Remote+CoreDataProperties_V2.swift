import Foundation
import CoreData

extension Remote {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Remote> { NSFetchRequest<Remote>(entityName: "Remote") }
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var icon: String?
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var isFavorite: Bool
    @NSManaged public var sortOrder: Int16
    @NSManaged public var category: String?
    @NSManaged public var manufacturer: String?
    @NSManaged public var modelName: String?
    @NSManaged public var buttons: Set<Button>?
    @NSManaged public var room: Room?
}

extension Button {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Button> { NSFetchRequest<Button>(entityName: "Button") }
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var irCode: String
    @NSManaged public var protocolType: String?
    @NSManaged public var bitCount: Int16
    @NSManaged public var colorHex: String?
    @NSManaged public var iconName: String?
    @NSManaged public var sortOrder: Int16
    @NSManaged public var remote: Remote?
    @NSManaged public var scenarioSteps: Set<ScenarioStep>?
}

extension Room {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Room> { NSFetchRequest<Room>(entityName: "Room") }
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var icon: String?
    @NSManaged public var sortOrder: Int16
    @NSManaged public var isLocked: Bool
    @NSManaged public var remotes: Set<Remote>?
}

extension Scenario {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Scenario> { NSFetchRequest<Scenario>(entityName: "Scenario") }
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var icon: String?
    @NSManaged public var createdAt: Date
    @NSManaged public var steps: Set<ScenarioStep>?
}

extension ScenarioStep {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScenarioStep> { NSFetchRequest<ScenarioStep>(entityName: "ScenarioStep") }
    @NSManaged public var id: UUID
    @NSManaged public var delay: Double
    @NSManaged public var sortOrder: Int16
    @NSManaged public var scenario: Scenario?
    @NSManaged public var button: Button?
}

extension HistoryEvent {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryEvent> { NSFetchRequest<HistoryEvent>(entityName: "HistoryEvent") }
    @NSManaged public var id: UUID
    @NSManaged public var timestamp: Date
    @NSManaged public var remoteName: String
    @NSManaged public var buttonName: String
    @NSManaged public var irCode: String
    @NSManaged public var success: Bool
}
