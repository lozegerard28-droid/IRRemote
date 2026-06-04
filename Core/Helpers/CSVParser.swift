import Foundation

struct CSVParser {
    static func parse(url: URL, encoding: String.Encoding = .utf8) throws -> [RemoteButtonDTO] {
        let content = try String(contentsOf: url, encoding: encoding)
        return try parse(content: content)
    }
    static func parse(content: String) throws -> [RemoteButtonDTO] {
        var lines = content.components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .filter { !$0.trimmingCharacters(in: .whitespaces).hasPrefix("#") }
        guard lines.count >= 2 else { throw AppError.fileEmpty }
        let header = parseCSVLine(lines[0]).map { $0.trimmingCharacters(in: .whitespaces).lowercased() }
        guard let nameIdx = header.firstIndex(where: { ["nom", "name", "button", "bouton"].contains($0) }),
              let codeIdx = header.firstIndex(where: { ["codeir", "code", "ircode", "ir_code"].contains($0) }) else {
            throw AppError.fileInvalid("Colonnes 'Nom' et 'CodeIR' requises")
        }
        let protoIdx = header.firstIndex(where: { ["protocole", "protocol", "proto"].contains($0) })
        let bitsIdx = header.firstIndex(where: { ["bits", "bitcount", "bit_count"].contains($0) })
        let catIdx = header.firstIndex(where: { ["categorie", "category", "cat"].contains($0) })
        let colorIdx = header.firstIndex(where: { ["couleur", "color", "col"].contains($0) })
        
        var buttons: [RemoteButtonDTO] = []
        for line in lines[1...] {
            let fields = parseCSVLine(line)
            guard fields.count > max(nameIdx, codeIdx) else { continue }
            let name = fields[nameIdx].trimmingCharacters(in: .whitespacesAndNewlines)
            let code = fields[codeIdx].trimmingCharacters(in: .whitespacesAndNewlines)
            guard !name.isEmpty, !code.isEmpty else { continue }
            let button = RemoteButtonDTO(
                name: name, code: code,
                protocolType: protoIdx.map { fields[$0].trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty },
                bits: bitsIdx.flatMap { Int16(fields[$0].trimmingCharacters(in: .whitespaces)) },
                category: catIdx.map { fields[$0].trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty },
                colorHex: colorIdx.map { fields[$0].trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
            )
            buttons.append(button)
        }
        return buttons
    }
    private static func parseCSVLine(_ line: String) -> [String] {
        var fields: [String] = []
        var current = ""
        var inQuotes = false
        for char in line {
            if char == "\"" { inQuotes.toggle() }
            else if char == "," && !inQuotes { fields.append(current); current = "" }
            else { current.append(char) }
        }
        fields.append(current)
        return fields
    }
}
