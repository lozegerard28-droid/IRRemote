import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showSettings = false
    @State private var showAddMenu = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if !viewModel.favoriteRemotes.isEmpty {
                        favoritesSection
                    }

                    if viewModel.filteredRooms.isEmpty && viewModel.searchText.isEmpty {
                        emptyState
                    } else {
                        roomsList
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .searchable(text: $viewModel.searchText, prompt: "Rechercher une télécommande...")
            .navigationTitle("IR Remote")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { showSettings.toggle() } label: {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showAddMenu.toggle() } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .confirmationDialog("Ajouter", isPresented: $showAddMenu) {
                Button("Importer un fichier") { viewModel.showImportSheet = true }
                Button("Créer manuellement") { viewModel.showCreateRemote = true }
            }
            .sheet(isPresented: $viewModel.showImportSheet) {
                ImportView()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }

    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Favoris")
                .font(.headline)
                .padding(.leading, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.favoriteRemotes, id: \.id) { remote in
                        NavigationLink(destination: RemoteControlView(remote: remote)) {
                            FavoriteCardView(remote: remote)
                        }
                    }
                }
            }
        }
    }

    private var roomsList: some View {
        ForEach(viewModel.filteredRooms, id: \.id) { room in
            RoomSectionView(room: room, viewModel: viewModel)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "remote.fill")
                .font(.system(size: 64))
                .foregroundColor(.secondary)

            Text("Bienvenue sur IR Remote")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Ajoutez votre première télécommande\npour commencer à piloter vos appareils.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            Button {
                showAddMenu.toggle()
            } label: {
                Label("Ajouter ma première télécommande", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.top, 60)
    }
}

struct FavoriteCardView: View {
    let remote: Remote

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: remote.icon.isEmpty ? "remote" : remote.icon)
                .font(.title2)
            Text(remote.name)
                .font(.caption)
                .lineLimit(1)
        }
        .frame(width: 80, height: 80)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
