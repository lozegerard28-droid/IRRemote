import Foundation
import UniformTypeIdentifiers

struct CSVParser: Importable {
    typealias ImportResult = [CSVRow]

    func validate(url: URL) throws -> Bool {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw AppError.fileInvalid("File not found")
        }
        guard url.pathExtension.lowercased() == "csv" else {
            throw AppError.fileInvalid("Not a CSV file")
        }
        return true
    }

    func parse(url: URL) async throws -> [CSVRow] {
        try validate(url: url)
        let content = try String(contentsOf: url, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .filter { !$0.hasPrefix("#") }

        guard lines.count > 1 else {
            throw AppError.fileEmpty
        }

        let headers = parseCSVLine(lines[0]).map { $0.lowercased().trimmingCharacters(in: .whitespaces) }
        guard !headers.isEmpty else {
            throw AppError.fileInvalid("Missing headers")
        }

        var rows: [CSVRow] = []
        for line in lines.dropFirst() {
            let fields = parseCSVLine(line)
            let dict = Dictionary(uniqueKeysWithValues: zip(headers, fields))
            let row = CSVRow(
                name: dict["nom"] ?? dict["name"] ?? "",
                irCode: dict["codeir"] ?? dict["code"] ?? "",
                protocol: dict["protocole"] ?? dict["protocol"],
                bits: Int(dict["bits"] ?? ""),
                category: dict["categorie"] ?? dict["category"],
                color: dict["couleur"] ?? dict["color"]
            )
            if !row.name.isEmpty && !row.irCode.isEmpty {
                rows.append(row)
            }
        }

        if rows.isEmpty {
            throw AppError.fileEmpty
        }
        return rows
    }

    private func parseCSVLine(_ line: String) -> [String] {
        var fields: [String] = []
        var current = ""
        var inQuotes = false
        for char in line {
            if char == "\"" {
                inQuotes.toggle()
            } else if char == "," && !inQuotes {
                fields.append(current.trimmingCharacters(in: .whitespaces))
                current = ""
            } else {
                current.append(char)
            }
        }
        fields.append(current.trimmingCharacters(in: .whitespaces))
        return fields
    }
}
