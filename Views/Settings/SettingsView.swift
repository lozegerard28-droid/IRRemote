import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showFilePicker = false
    @State private var showHistoryExport = false

    var body: some View {
        NavigationStack {
            Form {
                generalSection
                behaviorSection
                remoteDefaultsSection
                securitySection
                backupSection
                dataSection
                aboutSection
            }
            .navigationTitle("Paramètres")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fermer") { dismiss() }
                }
            }
            .alert("Réinitialiser l'application ?", isPresented: $viewModel.showResetConfirmation) {
                Button("Annuler", role: .cancel) {}
                Button("Réinitialiser", role: .destructive) { viewModel.resetApp() }
            } message: {
                Text("Toutes les données seront supprimées. Cette action est irréversible.")
            }
            .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [.zip]) { result in
                if case .success(let url) = result {
                    viewModel.importBackup(url: url)
                }
            }
        }
    }

    private var generalSection: some View {
        Section("Général") {
            Picker("Langue", selection: $viewModel.preferences.language) {
                Text("Français").tag("fr")
                Text("English").tag("en")
            }
            Picker("Taille de police", selection: $viewModel.preferences.fontSize) {
                Text("Petit").tag("Petit")
                Text("Normal").tag("Normal")
                Text("Grand").tag("Grand")
                Text("Très grand").tag("Très grand")
            }
            Picker("Unité température", selection: $viewModel.preferences.temperatureUnit) {
                Text("Celsius").tag("Celsius")
                Text("Fahrenheit").tag("Fahrenheit")
            }
        }
    }

    private var behaviorSection: some View {
        Section("Comportement") {
            Picker("Feedback haptique", selection: $viewModel.preferences.hapticIntensity) {
                Text("Faible").tag("Faible")
                Text("Moyen").tag("Medium")
                Text("Fort").tag("Fort")
                Text("Désactivé").tag("Désactivé")
            }
            Toggle("Son à l'envoi", isOn: $viewModel.preferences.soundEnabled)
            Toggle("Flash LED à l'envoi", isOn: $viewModel.preferences.flashEnabled)
            Toggle("Désactiver verrouillage auto", isOn: $viewModel.preferences.autoLockDisabled)
        }
    }

    private var remoteDefaultsSection: some View {
        Section("Télécommandes") {
            Picker("Disposition par défaut", selection: $viewModel.preferences.defaultLayout) {
                Text("3×3").tag("3x3")
                Text("4×3").tag("4x3")
                Text("4×4").tag("4x4")
            }
            Toggle("Afficher les noms", isOn: $viewModel.preferences.showButtonNames)
            Toggle("Afficher les icônes", isOn: $viewModel.preferences.showButtonIcons)
        }
    }

    private var securitySection: some View {
        Section("Sécurité") {
            Toggle("Masquer les codes IR", isOn: $viewModel.preferences.hideIRCodes)
            Picker("Délai de verrouillage", selection: $viewModel.preferences.lockTimeout) {
                Text("Immédiat").tag("Immédiat")
                Text("1 min").tag("1 min")
                Text("5 min").tag("5 min")
                Text("15 min").tag("15 min")
            }
        }
    }

    private var backupSection: some View {
        Section("Sauvegarde") {
            Button("Sauvegarder la configuration") {
                _ = viewModel.exportBackup()
            }
            Button("Restaurer une sauvegarde") {
                showFilePicker.toggle()
            }
        }
    }

    private var dataSection: some View {
        Section("Données") {
            Button("Exporter l'historique (CSV)") {
                _ = viewModel.exportHistory()
                showHistoryExport = true
            }
            Button("Effacer l'historique") {
                viewModel.clearHistory()
            }
            Button("Réinitialiser l'application", role: .destructive) {
                viewModel.showResetConfirmation = true
            }
        }
    }

    private var aboutSection: some View {
        Section("À propos") {
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0")
                    .foregroundColor(.secondary)
            }
            Link("Dépôt GitHub", destination: URL(string: "https://github.com/")!)
            Link("Site web du projet", destination: URL(string: "https://")!)
        }
    }
}
