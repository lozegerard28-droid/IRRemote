import SwiftUI
import UniformTypeIdentifiers

struct ImportView: View {
    @StateObject private var viewModel = ImportViewModel()
    @State private var showFilePicker = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if viewModel.isImporting {
                    ProgressView("Import en cours...")
                } else if viewModel.showNameDialog, let result = viewModel.importResult {
                    importNameDialog(result)
                } else {
                    importOptions
                }
            }
            .padding()
            .navigationTitle("Ajouter")
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Fermer") { presentationMode.wrappedValue.dismiss() } } }
            .alert("Erreur", isPresented: Binding<Bool>(
                get: { viewModel.importError != nil },
                set: { if !$0 { viewModel.importError = nil } }
            )) {
                Button("OK") { viewModel.importError = nil }
            } message: { Text(viewModel.importError ?? "") }
        }
    }
    
    private var importOptions: some View {
        VStack(spacing: 20) {
            Image(systemName: "plus.circle").font(.system(size: 50)).foregroundColor(themeManager.currentTheme.colors.primary)
            Text("Ajouter une télécommande").font(.title2).bold()
            
            // File import
            Button(action: { showFilePicker = true }) {
                Label("Importer un fichier", systemImage: "doc.badge.plus")
                    .frame(maxWidth: .infinity).padding()
                    .background(themeManager.currentTheme.colors.surface)
                    .cornerRadius(12)
            }
            .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [.commaSeparatedText, .json]) { result in
                if case .success(let url) = result {
                    Task { await viewModel.handleFile(url: url) }
                }
            }
            
            // Manual creation
            Button(action: {}) {
                Label("Créer manuellement", systemImage: "square.and.pencil")
                    .frame(maxWidth: .infinity).padding()
                    .background(themeManager.currentTheme.colors.surface)
                    .cornerRadius(12)
            }
            
            // Learning mode
            if DongleManager.shared.isConnected {
                Button(action: {}) {
                    Label("Mode apprentissage", systemImage: "waveform")
                        .frame(maxWidth: .infinity).padding()
                        .background(themeManager.currentTheme.colors.surface)
                        .cornerRadius(12)
                }
            }
        }
    }
    
    private func importNameDialog(_ result: ImportResult) -> some View {
        VStack(spacing: 16) {
            Text("\(result.buttonCount) boutons détectés").font(.headline)
            Text("Donnez un nom à cette télécommande :").foregroundColor(.secondary)
            TextField("Nom", text: $viewModel.remoteName).textFieldStyle(.roundedBorder)
            
            Picker("Pièce", selection: $viewModel.selectedRoom) {
                Text("Aucune").tag(nil as Room?)
                ForEach(viewModel.availableRooms, id: \.id) { room in
                    Text(room.name).tag(room as Room?)
                }
            }
            
            HStack(spacing: 16) {
                Button("Annuler") { viewModel.reset() }
                    .buttonStyle(.bordered)
                Button("Importer") { viewModel.confirmImport(); presentationMode.wrappedValue.dismiss() }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.remoteName.isEmpty)
            }
        }
    }
}
