import SwiftUI
import CoreData

struct RemoteControlView: View {
    let remote: Remote
    @EnvironmentObject var appState: AppState

    @FetchRequest private var buttons: FetchedResults<Button>
    @StateObject private var dongleManager = DongleManager.shared
    @State private var showingDongleSheet = false
    @State private var sendError: String?
    @State private var showingError = false

    init(remote: Remote) {
        self.remote = remote
        _buttons = FetchRequest(
            sortDescriptors: [SortDescriptor(\.name, order: .forward)],
            predicate: NSPredicate(format: "remote == %@", remote)
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if dongleManager.isConnected {
                    Label("Connecté", systemImage: "antenna.radiowaves.left.and.right")
                        .foregroundColor(.green)
                } else {
                    Button("Connecter dongle") { showingDongleSheet = true }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                    ForEach(buttons) { button in
                        Button(action: { sendIRCode(button) }) {
                            VStack(spacing: 4) {
                                Text(button.name ?? "?")
                                    .font(.caption)
                                    .lineLimit(2)
                                if let code = button.irCode, code.count > 8 {
                                    Text(String(code.suffix(4)).uppercased())
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(remote.name ?? "Télécommande")
        .sheet(isPresented: $showingDongleSheet) {
            DongleConnectView()
        }
        .alert("Erreur", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(sendError ?? "Erreur inconnue")
        }
    }

    private func sendIRCode(_ button: Button) {
        guard let code = button.irCode else { return }
        Task {
            do {
                try await dongleManager.sendIR(code: code)
            } catch {
                sendError = error.localizedDescription
                showingError = true
            }
        }
    }
}

struct DongleConnectView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dongleManager = DongleManager.shared
    @State private var scanned = false

    var body: some View {
        NavigationStack {
            List {
                if dongleManager.availableDongles.isEmpty {
                    if !scanned {
                        ProgressView("Recherche...")
                            .task { await dongleManager.scanForDongles(); scanned = true }
                    } else {
                        Text("Aucun dongle trouvé")
                    }
                }
                ForEach(dongleManager.availableDongles) { dongle in
                    Button {
                        dongleManager.connect(to: dongle.id)
                        dismiss()
                    } label: {
                        VStack(alignment: .leading) {
                            Text(dongle.name).font(.headline)
                            Text(dongle.manufacturer).font(.caption).foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Dongle IR")
            .toolbar { ToolbarItem(placement: .cancellation) { Button("Annuler") { dismiss() } } }
        }
    }
}
