import Foundation
import OSLog

enum AppLogger {
    private static let subsystem = "com.irremote.app"
    static let core = Logger(subsystem: subsystem, category: "core")
    static let ir = Logger(subsystem: subsystem, category: "ir")
    static let ui = Logger(subsystem: subsystem, category: "ui")
    static let data = Logger(subsystem: subsystem, category: "data")
    static let security = Logger(subsystem: subsystem, category: "security")
    
    static func error(_ message: String, category: Logger, file: String = #file, line: Int = #line) {
        category.error("\(file):\(line) \(message)")
    }
    static func info(_ message: String, category: Logger) {
        category.info("\(message)")
    }
    static func debug(_ message: String, category: Logger) {
        category.debug("\(message)")
    }
}
