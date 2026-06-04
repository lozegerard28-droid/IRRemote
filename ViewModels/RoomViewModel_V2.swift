import SwiftUI
import CoreData

@MainActor
class RoomViewModel: ObservableObject {
    @Published var rooms: [Room] = []
    @Published var showAddRoom = false
    @Published var newRoomName = ""
    @Published var newRoomIcon = "house.fill"

    func loadRooms() {
        let request = Room.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "sortOrder", ascending: true)]
        rooms = (try? PersistenceController.shared.viewContext.fetch(request)) ?? []
    }

    func createRoom() {
        guard !newRoomName.isEmpty else { return }
        let room = Room(context: PersistenceController.shared.viewContext)
        room.id = UUID()
        room.name = newRoomName
        room.icon = newRoomIcon
        room.sortOrder = Int16(rooms.count)
        room.isLocked = false
        PersistenceController.shared.save()
        newRoomName = ""
        showAddRoom = false
        loadRooms()
    }

    func deleteRoom(_ room: Room) {
        PersistenceController.shared.viewContext.delete(room)
        PersistenceController.shared.save()
        loadRooms()
    }

    func toggleLock(_ room: Room) {
        room.isLocked.toggle()
        PersistenceController.shared.save()
    }
}
