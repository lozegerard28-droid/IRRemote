import SwiftUI
import CoreData

@MainActor
class HomeViewModel: ObservableObject {
    @Published var rooms: [Room] = []
    @Published var favorites: [Remote] = []
    @Published var searchText = ""
    @Published var showImportSheet = false

    private let viewContext = PersistenceController.shared.viewContext

    var filteredRooms: [Room] {
        if searchText.isEmpty { return rooms }
        return rooms.filter { room in
            room.name.localizedCaseInsensitiveContains(searchText) ||
            (room.remotes?.contains { $0.name.localizedCaseInsensitiveContains(searchText) } ?? false)
        }
    }

    func loadData() {
        let roomRequest = Room.fetchRequest()
        roomRequest.sortDescriptors = [NSSortDescriptor(key: "sortOrder", ascending: true)]
        rooms = (try? viewContext.fetch(roomRequest)) ?? []

        let favRequest = Remote.fetchRequest()
        favRequest.predicate = NSPredicate(format: "isFavorite == YES")
        favRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        favorites = (try? viewContext.fetch(favRequest)) ?? []
    }

    func addRoom(name: String, icon: String = "house.fill") {
        let room = Room(context: viewContext)
        room.id = UUID()
        room.name = name
        room.icon = icon
        room.sortOrder = Int16(rooms.count)
        room.isLocked = false
        PersistenceController.shared.save()
        loadData()
    }

    func deleteRoom(_ room: Room) {
        viewContext.delete(room)
        PersistenceController.shared.save()
        loadData()
    }

    func toggleFavorite(_ remote: Remote) {
        remote.isFavorite.toggle()
        PersistenceController.shared.save()
        loadData()
    }

    func deleteRemote(_ remote: Remote) {
        viewContext.delete(remote)
        PersistenceController.shared.save()
        loadData()
    }
}
