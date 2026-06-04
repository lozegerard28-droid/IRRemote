import SwiftUI

struct RemoteButtonEditor: View {
    @Binding var name: String
    @Binding var code: String
    @Binding var protocolType: String
    @Binding var colorHex: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Form {
            Section("Bouton") {
                TextField("Nom", text: $name)
                TextField("Code IR", text: $code)
                    .font(.system(.body, design: .monospaced))
                Picker("Protocole", selection: $protocolType) {
                    ForEach(IRProtocol.allCases) { proto in
                        Text(proto.rawValue).tag(proto.rawValue)
                    }
                }
                TextField("Couleur (#RRGGBB)", text: $colorHex)
            }
            Section("Aperçu") {
                Button(name) {}
                    .buttonStyle(.bordered)
                    .tint(Color(hex: colorHex.isEmpty ? "#1A3C6E" : colorHex))
            }
        }
    }
}
