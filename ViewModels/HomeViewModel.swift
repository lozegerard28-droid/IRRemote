import SwiftUI
import CoreData

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var rooms: [Room] = []
    @Published var favoriteRemotes: [Remote] = []
    @Published var searchText = ""
    @Published var showImportSheet = false
    @Published var showCreateRemote = false
    @Published var selectedRoom: Room?

    private let context = PersistenceController.shared.viewContext

    func loadData() {
        let roomFetch = NSFetchRequest<Room>(entityName: "Room")
        roomFetch.sortDescriptors = [NSSortDescriptor(key: "sortOrder", ascending: true)]
        rooms = (try? context.fetch(roomFetch)) ?? []
        if rooms.isEmpty { createDefaultRoom() }

        let remoteFetch = NSFetchRequest<Remote>(entityName: "Remote")
        remoteFetch.predicate = NSPredicate(format: "isFavorite == YES")
        remoteFetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        favoriteRemotes = (try? context.fetch(remoteFetch)) ?? []
    }

    var filteredRooms: [Room] {
        guard !searchText.isEmpty else { return rooms }
        return rooms.filter { room in
            room.name.localizedCaseInsensitiveContains(searchText) ||
            room.sortedRemotes.contains { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func toggleFavorite(_ remote: Remote) {
        remote.isFavorite.toggle()
        PersistenceController.shared.save()
        loadData()
    }

    func deleteRemote(_ remote: Remote) {
        context.delete(remote)
        PersistenceController.shared.save()
        loadData()
    }

    func duplicateRemote(_ remote: Remote) {
        let newRemote = Remote(context: context)
        newRemote.id = UUID()
        newRemote.name = "\(remote.name) (copie)"
        newRemote.icon = remote.icon
        newRemote.isFavorite = false
        newRemote.sortOrder = remote.sortOrder + 1
        newRemote.manufacturer = remote.manufacturer
        newRemote.model = remote.model
        newRemote.columns = remote.columns
        newRemote.rows = remote.rows
        newRemote.createdAt = Date()
        newRemote.updatedAt = Date()
        newRemote.room = remote.room

        for button in remote.sortedButtons {
            let newButton = Button(context: context)
            newButton.id = UUID()
            newButton.name = button.name
            newButton.irCode = button.irCode
            newButton.irProtocol = button.irProtocol
            newButton.bitCount = button.bitCount
            newButton.category = button.category
            newButton.color = button.color
            newButton.sortOrder = button.sortOrder
            newButton.row = button.row
            newButton.col = button.col
            newButton.remote = newRemote
        }

        PersistenceController.shared.save()
        loadData()
    }

    func moveRemote(_ remote: Remote, to room: Room) {
        remote.room = room
        PersistenceController.shared.save()
        loadData()
    }

    func deleteRoom(_ room: Room) {
        guard !room.isDefault else { return }
        context.delete(room)
        PersistenceController.shared.save()
        loadData()
    }

    private func createDefaultRoom() {
        let room = Room(context: context)
        room.id = UUID()
        room.name = "Général"
        room.icon = "house"
        room.sortOrder = 0
        room.isLocked = false
        room.isDefault = true
        PersistenceController.shared.save()
        loadData()
    }
}
