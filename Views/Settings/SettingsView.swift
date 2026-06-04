import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Form {
            // General
            Section("Général") {
                Picker("Thème", selection: $viewModel.themeMode) {
                    Text("Système").tag(ThemeMode.system)
                    Text("Clair").tag(ThemeMode.light)
                    Text("Sombre").tag(ThemeMode.dark)
                }
                Picker("Langue", selection: $viewModel.language) {
                    Text("Français").tag(Language.french)
                    Text("English").tag(Language.english)
                }
            }
            
            // Behavior
            Section("Comportement") {
                Picker("Retour haptique", selection: $viewModel.hapticIntensity) {
                    Text("Désactivé").tag(HapticIntensity.off)
                    Text("Faible").tag(HapticIntensity.light)
                    Text("Moyen").tag(HapticIntensity.medium)
                    Text("Fort").tag(HapticIntensity.strong)
                }
                Toggle("Flash LED à l'envoi", isOn: $viewModel.flashEnabled)
                Toggle("Son à l'envoi", isOn: $viewModel.soundEnabled)
            }
            
            // Remotes
            Section("Télécommandes") {
                Picker("Disposition", selection: $viewModel.buttonLayout) {
                    Text("3 × 3").tag("3x3")
                    Text("4 × 3").tag("4x3")
                    Text("4 × 4").tag("4x4")
                }
                NavigationLink("Gérer les pièces") { RoomListView() }
            }
            
            // Security
            Section("Sécurité") {
                NavigationLink("Verrouillage biométrique") { SecuritySettingsView() }
            }
            
            // Backup
            Section("Sauvegarde") {
                Button(action: { Task { await viewModel.exportBackup() } }) {
                    Label("Sauvegarder la configuration", systemImage: "square.and.arrow.up")
                }
            }
            
            // Data
            Section("Données") {
                Button(role: .destructive) { viewModel.showResetAlert = true } label: {
                    Label("Réinitialiser l'application", systemImage: "trash")
                }
            }
            
            // About
            Section("À propos") {
                HStack { Text("Version"); Spacer(); Text(viewModel.appVersion).foregroundColor(.secondary) }
                HStack { Text("Format de données"); Spacer(); Text(viewModel.dataVersion).foregroundColor(.secondary) }
                NavigationLink("Crédits") { CreditsView() }
            }
        }
        .navigationTitle("Paramètres")
        .alert("Réinitialiser", isPresented: $viewModel.showResetAlert) {
            Button("Annuler", role: .cancel) {}
            Button("Réinitialiser", role: .destructive) { viewModel.resetAllData() }
        } message: { Text("Toutes les données seront effacées. Cette action est irréversible.") }
    }
}

struct CreditsView: View {
    var body: some View {
        Form {
            Section {
                VStack(spacing: 8) {
                    Image(systemName: "remote.fill").font(.system(size: 40)).foregroundColor(.blue)
                    Text("IR Remote Controller").font(.title2).bold()
                    Text("Application iOS de télécommande universelle").foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity).padding()
            }
            Section("Développement") {
                HStack { Text("Créateur"); Spacer(); Text("Martin").foregroundColor(.secondary) }
            }
            Section("Open Source") {
                HStack { Text("Licence"); Spacer(); Text("MIT").foregroundColor(.secondary) }
                HStack { Text("Dépôt"); Spacer(); Text("github.com/").foregroundColor(.blue) }
            }
        }
        .navigationTitle("Crédits")
    }
}

struct SecuritySettingsView: View {
    @State private var lockedRooms: Set<String> = []
    @State private var autoLockDelay = 1
    
    var body: some View {
        Form {
            Section {
                Text("Les pièces verrouillées nécessitent Face ID ou Touch ID pour être ouvertes.").font(.caption).foregroundColor(.secondary)
            }
            Section("Pièces verrouillées") {
                // List rooms with toggle
            }
            Section("Délai de verrouillage") {
                Picker("Délai", selection: $autoLockDelay) {
                    Text("Immédiat").tag(0)
                    Text("1 min").tag(1)
                    Text("5 min").tag(5)
                    Text("15 min").tag(15)
                }
            }
        }
        .navigationTitle("Sécurité")
    }
}
