import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.events, id: \.id) { event in
                    Button {
                        viewModel.resend(event)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(event.buttonName)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(event.timestamp, style: .time)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            HStack {
                                Text(event.remoteName)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                if let room = event.roomName {
                                    Text("• \(room)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Text(event.irCode)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Historique")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Exporter CSV") { _ = viewModel.exportCSV() }
                        Button("Tout effacer", role: .destructive) { viewModel.clearAll() }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .onAppear { viewModel.loadHistory() }
    }
}
