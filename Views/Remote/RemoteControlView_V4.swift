import SwiftUI
import CoreData

fileprivate typealias SwiftButton = SwiftUI.Button

struct RemoteControlView: View {
    let remote: Remote

    @FetchRequest private var buttons: FetchedResults<Button>
    @StateObject private var dongleManager = DongleManager.shared
    @State private var showingDongleSheet = false
    @State private var sendError: String?
    @State private var showingError = false
    @Environment(\.horizontalSizeClass) private var hSize

    init(remote: Remote) {
        self.remote = remote
        _buttons = FetchRequest(
            sortDescriptors: [SortDescriptor(\.sortOrder, order: .forward)],
            predicate: NSPredicate(format: "remote == %@", remote)
        )
    }

    var body: some View {
        let isLandscape = hSize == .regular
        VStack(spacing: 0) {
            HStack {
                if dongleManager.isConnected {
                    Label("Connecté", systemImage: "antenna.radiowaves.left.and.right")
                        .foregroundColor(.green)
                } else {
                    SwiftButton("Connecter dongle") { showingDongleSheet = true }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            ScrollView {
                LazyVGrid(columns: gridColumns(isLandscape), spacing: isLandscape ? 20 : 12) {
                    ForEach(buttons) { button in
                        SwiftButton(action: { sendIRCode(button) }) {
                            VStack(spacing: 4) {
                                Text(button.name ?? "?")
                                    .font(isLandscape ? .title3 : .caption)
                                    .lineLimit(2)
                                if let code = button.irCode, code.count > 8 {
                                    Text(String(code.suffix(4)).uppercased())
                                        .font(isLandscape ? .caption2 : .caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(isLandscape ? 20 : 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(remote.name ?? "Télécommande")
        .navigationBarHidden(isLandscape)
        .sheet(isPresented: $showingDongleSheet) {
            DongleConnectView()
        }
        .alert("Erreur", isPresented: $showingError) {
            SwiftButton("OK") { }
        } message: {
            Text(sendError ?? "Erreur inconnue")
        }
    }

    private func gridColumns(_ landscape: Bool) -> [GridItem] {
        if landscape {
            return Array(repeating: GridItem(.flexible(), spacing: 16), count: 5)
        }
        return Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
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

enum DongleAlert: Identifiable {
    case notFound
    case connected
    var id: Self { self }
}

struct DongleConnectView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dongleManager = DongleManager.shared
    @State private var scanned = false
    @State private var alert: DongleAlert?

    var body: some View {
        NavigationView {
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
                    SwiftButton {
                        dongleManager.connect(to: dongle.id)
                        alert = .connected
                    } label: {
                        VStack(alignment: .leading) {
                            Text(dongle.name).font(.headline)
                            Text(dongle.manufacturer).font(.caption).foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Dongle IR")
            .toolbar { ToolbarItem(placement: .navigationBarLeading) { SwiftButton("Annuler") { dismiss() } } }
            .onChange(of: scanned) { if $0 && dongleManager.availableDongles.isEmpty { alert = .notFound } }
            .alert(item: $alert) { a in
                switch a {
                case .notFound:
                    return Alert(
                        title: Text("Dongle non trouvé"),
                        message: Text("Aucun dongle USB IR détecté. Vérifie que le dongle est bien branché."),
                        dismissButton: .default(Text("OK"))
                    )
                case .connected:
                    return Alert(
                        title: Text("Dongle connecté"),
                        message: Text("Le dongle IR est prêt à être utilisé."),
                        dismissButton: .default(Text("OK")) { dismiss() }
                    )
                }
            }
        }
    }
}
