import SwiftUI

struct RoomListView: View {
    @StateObject private var viewModel = RoomViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        List {
            ForEach(viewModel.rooms, id: \.id) { room in
                HStack {
                    Image(systemName: room.icon ?? "house.fill")
                        .foregroundColor(themeManager.currentTheme.colors.primary)
                        .frame(width: 30)
                    VStack(alignment: .leading) {
                        Text(room.name).font(.body).foregroundColor(themeManager.currentTheme.colors.text)
                        if let count = room.remotes?.count {
                            Text("\(count) télécommande(s)").font(.caption).foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                    Button(action: { viewModel.toggleLock(room) }) {
                        Image(systemName: room.isLocked ? "lock.fill" : "lock.open")
                            .foregroundColor(room.isLocked ? themeManager.currentTheme.colors.secondary : .secondary)
                    }
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { viewModel.deleteRoom(viewModel.rooms[$0]) }
            }
        }
        .navigationTitle("Pièces")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { viewModel.showAddRoom = true }) { Image(systemName: "plus") }
            }
        }
        .sheet(isPresented: $viewModel.showAddRoom) {
            NavigationView {
                Form {
                    TextField("Nom de la pièce", text: $viewModel.newRoomName)
                    Picker("Icône", selection: $viewModel.newRoomIcon) {
                        ForEach(["house.fill", "sofa.fill", "bed.double.fill", "fork.knife", "car.fill", "tree.fill", "sun.max.fill"], id: \.self) { icon in
                            Image(systemName: icon).tag(icon)
                        }
                    }
                }
                .navigationTitle("Nouvelle pièce")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) { Button("Ajouter") { viewModel.createRoom() }.disabled(viewModel.newRoomName.isEmpty) }
                    ToolbarItem(placement: .navigationBarLeading) { Button("Annuler") { viewModel.showAddRoom = false } }
                }
            }
        }
        .onAppear { viewModel.loadRooms() }
    }
}
