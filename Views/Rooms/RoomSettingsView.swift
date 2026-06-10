import SwiftUI

struct RoomSettingsView: View {
    @StateObject private var viewModel = RoomListViewModel()

    var body: some View {
        List {
            ForEach(viewModel.rooms, id: \.id) { room in
                HStack {
                    Image(systemName: room.icon)
                        .foregroundColor(.accentColor)
                    Text(room.name)
                    Spacer()
                    if room.isDefault {
                        Text("Par défaut")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .swipeActions {
                    if !room.isDefault {
                        Button(role: .destructive) { viewModel.deleteRoom(room) } label: {
                            Label("Supprimer", systemImage: "trash")
                        }
                    }
                }
            }
            .onMove { source, destination in
                viewModel.rooms.move(fromOffsets: source, toOffset: destination)
                viewModel.updateRoomOrder()
            }
        }
        .navigationTitle("Pièces")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button { viewModel.showAddRoom.toggle() } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $viewModel.showAddRoom) {
            NavigationStack {
                Form {
                    TextField("Nom de la pièce", text: $viewModel.newRoomName)
                    Picker("Icône", selection: $viewModel.newRoomIcon) {
                        ForEach(viewModel.icons, id: \.self) { icon in
                            Image(systemName: icon).tag(icon)
                        }
                    }
                }
                .navigationTitle("Nouvelle pièce")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Ajouter") { viewModel.addRoom() }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Annuler") { viewModel.showAddRoom = false }
                    }
                }
            }
        }
        .onAppear { viewModel.loadRooms() }
    }
}
