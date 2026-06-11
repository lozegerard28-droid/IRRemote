import SwiftUI

struct SettingsView: View {
    @StateObject private var dongleManager = DongleManager.shared

    var body: some View {
        NavigationView {
            Form {
                Section("Dongle IR") {
                    if dongleManager.isConnected {
                        Label("Connecté", systemImage: "antenna.radiowaves.left.and.right")
                            .foregroundColor(.green)
                        SwiftUI.Button("Déconnecter") { dongleManager.disconnect() }
                    } else {
                        SwiftUI.Button("Rechercher un dongle") {
                            Task { await dongleManager.scanForDongles() }
                        }
                    }
                }

                Section("À propos") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Réglages")
        }
    }
}
