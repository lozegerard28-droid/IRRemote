import SwiftUI

struct RoomSectionView: View {
    let room: Room
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: room.icon)
                Text(room.name)
                    .font(.headline)
                if room.isLocked {
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text("\(room.sortedRemotes.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 4)

            ForEach(room.sortedRemotes, id: \.id) { remote in
                NavigationLink(destination: RemoteControlView(remote: remote)) {
                    RemoteCardView(remote: remote, viewModel: viewModel)
                }
            }
        }
    }
}

struct RemoteCardView: View {
    let remote: Remote
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: remote.icon.isEmpty ? "remote" : remote.icon)
                .font(.title3)
                .foregroundColor(.accentColor)
                .frame(width: 36, height: 36)
                .background(Color.accentColor.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(remote.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                if let room = remote.room {
                    Text(room.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            if remote.isFavorite {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contextMenu {
            Button { viewModel.toggleFavorite(remote) } label: {
                Label(remote.isFavorite ? "Retirer des favoris" : "Ajouter aux favoris",
                      systemImage: remote.isFavorite ? "star.slash" : "star")
            }
            Button { viewModel.duplicateRemote(remote) } label: {
                Label("Dupliquer", systemImage: "doc.on.doc")
            }
            Divider()
            Button(role: .destructive) { viewModel.deleteRemote(remote) } label: {
                Label("Supprimer", systemImage: "trash")
            }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) { viewModel.deleteRemote(remote) } label: {
                Label("Supprimer", systemImage: "trash")
            }
            Button { viewModel.toggleFavorite(remote) } label: {
                Label("Favori", systemImage: "star")
            }
            .tint(.yellow)
        }
    }
}
