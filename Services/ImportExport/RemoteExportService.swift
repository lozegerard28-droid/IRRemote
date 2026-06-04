import Foundation

class RemoteExportService {
    static let shared = RemoteExportService()
    
    func exportRemote(_ remote: RemoteDTO) throws -> URL {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(remote)
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(remote.remote.name)
            .appendingPathExtension("irremote")
        try data.write(to: url)
        return url
    }
    
    func exportAsCSV(remote: RemoteDTO) throws -> URL {
        var csv = "Nom,CodeIR,Protocole,Bits,Categorie,Couleur\n"
        for button in remote.remote.buttons {
            csv += "\(button.name),\(button.code),\(button.protocolType ?? "NEC"),\(button.bits ?? 32),\(button.category ?? ""),\(button.colorHex ?? "")\n"
        }
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(remote.remote.name)
            .appendingPathExtension("csv")
        try csv.write(to: url, atomically: true, encoding: .utf8)
        return url
    }
}