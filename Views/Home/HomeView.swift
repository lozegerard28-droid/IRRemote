import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var appState = AppState.shared
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Favorites section
                    if !viewModel.favorites.isEmpty {
                        favoritesSection
                    }
                    // Rooms section
                    if viewModel.filteredRooms.isEmpty {
                        emptyStateView
                    } else {
                        ForEach(viewModel.filteredRooms, id: \.id) { room in
                            roomSection(room)
                        }
                    }
                }
                .padding()
            }
            .background(themeManager.currentTheme.colors.background)
            .navigationTitle("IR Remote")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showImportSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Rechercher...")
            .sheet(isPresented: $viewModel.showImportSheet) {
                ImportView()
            }
            .onAppear { viewModel.loadData() }
        }
    }
    
    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Favoris").font(.headline).foregroundColor(themeManager.currentTheme.colors.textSecondary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.favorites, id: \.id) { remote in
                        RemoteCardView(remote: remote, isFavorite: true)
                            .onTapGesture { appState.navigateToRemote(remote) }
                            .contextMenu { favoriteContextMenu(remote) }
                    }
                }
            }
        }
    }
    
    private func roomSection(_ room: Room) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: room.icon ?? "house.fill")
                    .foregroundColor(themeManager.currentTheme.colors.primary)
                Text(room.name).font(.headline).foregroundColor(themeManager.currentTheme.colors.text)
                Spacer()
                if room.isLocked {
                    Image(systemName: "lock.fill").foregroundColor(themeManager.currentTheme.colors.secondary).font(.caption)
                }
            }
            .padding(.horizontal, 4)
            .onTapGesture {
                if room.isLocked {
                    Task { await AppState.shared.unlockRoom() }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if let remotes = room.remotes?.sorted(by: { $0.sortOrder < $1.sortOrder }) {
                        ForEach(remotes, id: \.id) { remote in
                            RemoteCardView(remote: remote)
                                .onTapGesture { appState.navigateToRemote(remote) }
                                .contextMenu { remoteContextMenu(remote) }
                        }
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 60)
            Image(systemName: "remote.fill").font(.system(size: 60)).foregroundColor(themeManager.currentTheme.colors.textDisabled)
            Text("Bienvenue !").font(.title2).bold().foregroundColor(themeManager.currentTheme.colors.text)
            Text("Ajoutez votre première télécommande\npour commencer à contrôler vos appareils.")
                .multilineTextAlignment(.center).foregroundColor(themeManager.currentTheme.colors.textSecondary)
            Button(action: { viewModel.showImportSheet = true }) {
                Label("Ajouter une télécommande", systemImage: "plus.circle.fill")
                    .font(.headline).padding(.horizontal, 24).padding(.vertical, 12)
                    .background(themeManager.currentTheme.colors.primary)
                    .foregroundColor(.white).cornerRadius(12)
            }
        }
    }
    
    private func favoriteContextMenu(_ remote: Remote) -> some View { Group {
        Button { viewModel.toggleFavorite(remote) } label: { Label("Retirer des favoris", systemImage: "star.slash") }
        Button(role: .destructive) { viewModel.deleteRemote(remote) } label: { Label("Supprimer", systemImage: "trash") }
    }}
    
    private func remoteContextMenu(_ remote: Remote) -> some View { Group {
        Button { viewModel.toggleFavorite(remote) } label: { Label(remote.isFavorite ? "Retirer des favoris" : "Ajouter aux favoris", systemImage: remote.isFavorite ? "star.slash" : "star") }
        Button(role: .destructive) { viewModel.deleteRemote(remote) } label: { Label("Supprimer", systemImage: "trash") }
    }}
}

struct RemoteCardView: View {
    let remote: Remote
    var isFavorite = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: remote.icon ?? "remote.fill")
                    .font(.title2).foregroundColor(themeManager.currentTheme.colors.primary)
                    .frame(width: 40, height: 40)
                    .background(themeManager.currentTheme.colors.surface)
                    .cornerRadius(10)
                if isFavorite {
                    Image(systemName: "star.fill").font(.system(size: 10)).foregroundColor(themeManager.currentTheme.colors.favorite)
                        .offset(x: 4, y: -4)
                }
            }
            Text(remote.name).font(.caption).fontWeight(.medium)
                .foregroundColor(themeManager.currentTheme.colors.text)
                .lineLimit(1)
        }
        .frame(width: 80, height: 90)
        .padding(8)
        .background(themeManager.currentTheme.colors.surface)
        .cornerRadius(themeManager.currentTheme.shapes.cardCornerRadius)
        .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
    }
}
