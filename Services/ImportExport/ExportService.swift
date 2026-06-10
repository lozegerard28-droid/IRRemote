import Foundation

final class ExportService {
    static let shared = ExportService()

    func exportRemoteAsCSV(_ remote: Remote) throws -> URL {
        var csv = "Nom,CodeIR,Protocole,Bits,Categorie,Couleur\n"
        for button in remote.sortedButtons {
            let proto = button.irProtocol ?? "NEC"
            let cat = button.category ?? "custom"
            let color = button.color ?? "#FFFFFF"
            csv += "\(button.name),\(button.irCode),\(proto),\(button.bitCount),\(cat),\(color)\n"
        }

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(remote.name).csv")
        try csv.write(to: url, atomically: true, encoding: .utf8)
        return url
    }

    func exportRemoteAsJSON(_ remote: Remote) throws -> URL {
        let buttons = remote.sortedButtons.map { button in
            ButtonDTO(
                name: button.name,
                code: button.irCode,
                protocol: button.irProtocol,
                bits: Int(button.bitCount),
                category: button.category,
                color: button.color,
                row: Int(button.row),
                col: Int(button.col)
            )
        }
        let content = RemoteDTO.RemoteContent(
            name: remote.name,
            icon: remote.icon,
            category: nil,
            manufacturer: remote.manufacturer,
            model: remote.model,
            layout: RemoteDTO.Layout(columns: Int(remote.columns), rows: Int(remote.rows)),
            buttons: buttons
        )
        let dto = RemoteDTO(version: "1.0", remote: content, metadata: RemoteDTO.Metadata(
            exportedAt: Date(),
            appVersion: "1.0.0"
        ))
        let data = try JSONEncoder().encode(dto)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(remote.name).json")
        try data.write(to: url)
        return url
    }
}
