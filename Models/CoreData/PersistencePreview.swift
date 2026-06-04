import CoreData

extension PersistenceController {
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext

        let room = Room(context: context)
        room.id = UUID()
        room.name = "Salon"
        room.icon = "sofa.fill"
        room.sortOrder = 0
        room.isLocked = false

        let remote = Remote(context: context)
        remote.id = UUID()
        remote.name = "TV Salon"
        remote.icon = "tv"
        remote.createdAt = Date()
        remote.updatedAt = Date()
        remote.isFavorite = true
        remote.sortOrder = 0
        remote.room = room

        for i in 1...5 {
            let button = Button(context: context)
            button.id = UUID()
            button.name = ["Power", "Volume +", "Volume -", "Chaîne +", "Chaîne -"][i-1]
            button.irCode = "0x10EF\(String(format: "%04X", i * 1000))"
            button.protocolType = "NEC"
            button.bitCount = 32
            button.sortOrder = Int16(i)
            button.remote = remote
        }
        try? context.save()
        return controller
    }()
}
