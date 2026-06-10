import SwiftUI
import UniformTypeIdentifiers

struct ImportView: View {
    @StateObject private var viewModel = ImportViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showCSVPicker = false
    @State private var showJSONPicker = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if viewModel.isImporting {
                    ProgressView("Import en cours...")
                } else if viewModel.showPreview {
                    previewContent
                } else {
                    importOptions
                }
            }
            .navigationTitle("Importer")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
            }
            .alert("Erreur", isPresented: .init(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Text(viewModel.errorMessage ?? "")
            }
            .fileImporter(isPresented: $showCSVPicker, allowedContentTypes: [.commaSeparatedText]) { result in
                if case .success(let url) = result {
                    Task { await viewModel.importCSV(url: url) }
                }
            }
            .fileImporter(isPresented: $showJSONPicker, allowedContentTypes: [.json]) { result in
                if case .success(let url) = result {
                    Task { await viewModel.importJSON(url: url) }
                }
            }
        }
        .onAppear { viewModel.loadRooms() }
    }

    private var importOptions: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.and.arrow.down")
                .font(.system(size: 48))
                .foregroundColor(.accentColor)

            Text("Ajouter une télécommande")
                .font(.title2.bold())

            Button {
                showCSVPicker.toggle()
            } label: {
                Label("Importer un fichier CSV", systemImage: "doc.text")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button {
                showJSONPicker.toggle()
            } label: {
                Label("Importer un fichier JSON", systemImage: "curlybraces")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button {
                viewModel.importSource = .manual
                viewModel.showPreview = true
            } label: {
                Label("Créer manuellement", systemImage: "hand.tap")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
    }

    private var previewContent: some View {
        Form {
            Section("Aperçu") {
                TextField("Nom de la télécommande", text: $viewModel.remoteName)

                Picker("Pièce", selection: $viewModel.selectedRoom) {
                    ForEach(viewModel.rooms, id: \.id) { room in
                        Text(room.name).tag(room as Room?)
                    }
                }

                if !viewModel.importedRows.isEmpty {
                    ForEach(viewModel.importedRows, id: \.name) { row in
                        HStack {
                            Text(row.name)
                            Spacer()
                            Text(row.irCode)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }

            Section {
                Button("Confirmer l'import") {
                    viewModel.confirmImport()
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .font(.headline)
            }
        }
    }
}
