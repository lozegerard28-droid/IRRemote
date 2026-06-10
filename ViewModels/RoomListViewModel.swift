import SwiftUI
import CoreData

@MainActor
final class RoomListViewModel: ObservableObject {
    @Published var rooms: [Room] = []
    @Published var showAddRoom = false
    @Published var newRoomName = ""
    @Published var newRoomIcon = "house"

    private let context = PersistenceController.shared.viewContext
    let icons = ["house", "tv", "bed.double", "fork.knife", "desktopcomputer", "car", "bicycle", "gamecontroller", "music.note", "sun.max", "snowflake", "bathtub"]

    func loadRooms() {
        let fetch = NSFetchRequest<Room>(entityName: "Room")
        fetch.sortDescriptors = [NSSortDescriptor(key: "sortOrder", ascending: true)]
        rooms = (try? context.fetch(fetch)) ?? []
    }

    func addRoom() {
        guard !newRoomName.isEmpty else { return }
        let room = Room(context: context)
        room.id = UUID()
        room.name = newRoomName
        room.icon = newRoomIcon
        room.sortOrder = Int16(rooms.count)
        room.isLocked = false
        room.isDefault = false
        PersistenceController.shared.save()
        loadRooms()
        newRoomName = ""
        showAddRoom = false
    }

    func deleteRoom(_ room: Room) {
        guard !room.isDefault else { return }
        context.delete(room)
        PersistenceController.shared.save()
        loadRooms()
    }

    func updateRoomOrder() {
        for (index, room) in rooms.enumerated() {
            room.sortOrder = Int16(index)
        }
        PersistenceController.shared.save()
    }

    func updateIcon(_ room: Room, icon: String) {
        room.icon = icon
        PersistenceController.shared.save()
    }

    func toggleLock(_ room: Room) {
        room.isLocked.toggle()
        PersistenceController.shared.save()
    }
}
