import SwiftUI
import CoreData
import UniformTypeIdentifiers

fileprivate typealias SwiftButton = SwiftUI.Button

struct ImportView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showingFilePicker = false
    @State private var showingManualAdd = false
    @State private var importError: String?
    @State private var showingError = false

    var body: some View {
        NavigationView {
            List {
                SwiftButton { showingFilePicker = true } label: {
                    Label("Importer depuis CSV", systemImage: "doc.text")
                }

                SwiftButton { showingManualAdd = true } label: {
                    Label("Ajouter manuellement", systemImage: "plus.circle")
                }
            }
            .navigationTitle("Importer")
            .fileImporter(isPresented: $showingFilePicker, allowedContentTypes: [.commaSeparatedText]) { result in
                handleCSVImport(result)
            }
            .sheet(isPresented: $showingManualAdd) {
                ManualAddView()
            }
            .alert("Erreur", isPresented: $showingError) {
                SwiftButton("OK") { }
            } message: {
                Text(importError ?? "Erreur inconnue")
            }
        }
    }

    private func handleCSVImport(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            guard url.startAccessingSecurityScopedResource() else { return }
            defer { url.stopAccessingSecurityScopedResource() }
            do {
                let content = try String(contentsOf: url, encoding: .utf8)
                try parseAndSaveCSV(content)
            } catch {
                importError = error.localizedDescription
                showingError = true
            }
        case .failure(let error):
            importError = error.localizedDescription
            showingError = true
        }
    }

    private func parseAndSaveCSV(_ content: String) throws {
        let rows = content.components(separatedBy: .newlines).filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        guard rows.count > 1 else { return }

        let headers = rows[0].components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        guard let nameIdx = headers.firstIndex(of: "name") ?? headers.firstIndex(of: "Name") ?? headers.firstIndex(of: "Nom"),
              let codeIdx = headers.firstIndex(of: "code") ?? headers.firstIndex(of: "Code") ?? headers.firstIndex(of: "hex") else {
            throw ImportError.invalidCSV
        }
        let protoIdx = headers.firstIndex(of: "protocol") ?? headers.firstIndex(of: "Protocol")
        let bitsIdx = headers.firstIndex(of: "bits") ?? headers.firstIndex(of: "Bits")

        for i in 1..<rows.count {
            let cols = rows[i].components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            guard cols.count > max(nameIdx, codeIdx) else { continue }

            let remoteName = cols[nameIdx]
            let code = cols[codeIdx]

            let fetchRequest: NSFetchRequest<Remote> = Remote.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", remoteName)
            let existing = try viewContext.fetch(fetchRequest)

            let remote: Remote
            if let r = existing.first {
                remote = r
            } else {
                remote = Remote(context: viewContext)
                remote.id = UUID()
                remote.name = remoteName
                if let p = protoIdx, cols.count > p { remote.category = cols[p] }
                remote.createdAt = Date()
            }

            let newButton = Button(context: viewContext)
            newButton.id = UUID()
            newButton.name = "Bouton \((remote.buttons?.count ?? 0) + 1)"
            newButton.irCode = code
            if let b = bitsIdx, cols.count > b { newButton.bitCount = Int16(cols[b]) ?? 0 }
            newButton.remote = remote
        }
        try viewContext.save()
    }
}

struct ManualAddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var remoteName = ""
    @State private var code = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Form {
                Section("Informations") {
                    TextField("Nom de la télécommande", text: $remoteName)
                    TextField("Code hexadécimal (ex: FF00FF00)", text: $code)
                }
                Section {
                    SwiftButton("Ajouter") { addRemote() }
                        .disabled(remoteName.isEmpty || code.isEmpty)
                }
            }
            .navigationTitle("Ajout manuel")
            .toolbar { ToolbarItem(placement: .navigationBarLeading) { SwiftButton("Annuler") { dismiss() } } }
        }
    }

    private func addRemote() {
        let remote = Remote(context: viewContext)
        remote.id = UUID()
        remote.name = remoteName
        remote.createdAt = Date()

        let newButton = Button(context: viewContext)
        newButton.id = UUID()
        newButton.name = "Bouton 1"
        newButton.irCode = code
        newButton.bitCount = 32
        newButton.remote = remote

        do {
            try viewContext.save()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

enum ImportError: LocalizedError {
    case invalidCSV
    var errorDescription: String? { "Format CSV invalide. Colonnes requises: name, code" }
}
