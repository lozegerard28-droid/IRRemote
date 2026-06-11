import SwiftUI
import CoreData

struct RemoteListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: .forward)]) private var remotes: FetchedResults<Remote>

    @State private var showingDeleteAlert = false
    @State private var remoteToDelete: Remote?

    var body: some View {
        NavigationStack {
            List {
                ForEach(remotes) { remote in
                    NavigationLink(destination: RemoteControlView(remote: remote)) {
                        VStack(alignment: .leading) {
                            Text(remote.name ?? "Sans nom")
                                .font(.headline)
                            if let category = remote.category {
                                Text(category)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteRemotes)
            }
            .navigationTitle("Télécommandes")
            .toolbar {
                EditButton()
            }
        }
    }

    private func deleteRemotes(at offsets: IndexSet) {
        for index in offsets {
            let remote = remotes[index]
            viewContext.delete(remote)
        }
        try? viewContext.save()
    }
}
