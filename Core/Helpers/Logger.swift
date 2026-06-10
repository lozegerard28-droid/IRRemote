import Foundation
import OSLog

extension Logger {
    static let app = Logger(subsystem: "com.irremote.app", category: "app")
    static let ir = Logger(subsystem: "com.irremote.app", category: "ir")
    static let persistence = Logger(subsystem: "com.irremote.app", category: "persistence")
    static let security = Logger(subsystem: "com.irremote.app", category: "security")
    static let `import` = Logger(subsystem: "com.irremote.app", category: "import")
}
