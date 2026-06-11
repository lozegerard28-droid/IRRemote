import SwiftUI

struct SettingsView: View {
    @StateObject private var dongleManager = DongleManager.shared
    @State private var esp32Address: String = ""

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

                Section("ESP32 WiFi") {
                    TextField("Adresse IP (ex: 192.168.1.42)", text: $esp32Address)
                        .keyboardType(.decimalPad)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: esp32Address) { newValue in
                            dongleManager.esp32Address = newValue
                        }
                    Text("L'ESP32 doit être sur le même réseau WiFi que l'iPhone.")
                        .font(.caption)
                        .foregroundColor(.secondary)
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
            .onAppear {
                esp32Address = dongleManager.esp32Address
            }
        }
    }
}
