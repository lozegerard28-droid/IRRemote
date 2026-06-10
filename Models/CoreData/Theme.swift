import Foundation
import CoreData

@objc(ThemeEntity)
final class ThemeEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var author: String?
    @NSManaged var isBuiltIn: Bool
    @NSManaged var themeData: Data
    @NSManaged var createdAt: Date
}
