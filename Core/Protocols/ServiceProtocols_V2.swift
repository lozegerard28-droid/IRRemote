import Foundation
import LocalAuthentication
import CoreData

protocol BiometricAuthenticatable {
    var isAvailable: Bool { get }
    var biometryType: LABiometryType { get }
    func authenticate(reason: String) async throws -> Bool
}

protocol HapticFeedable {
    func playPressFeedback(intensity: Float)
    func playSuccessFeedback()
    func playErrorFeedback()
}

protocol FlashLightable {
    var isAvailable: Bool { get }
    func flash(duration: TimeInterval)
    func stopFlashing()
}

protocol AudioPlayable {
    func playSendSound()
    func playSuccessSound()
    func playErrorSound()
}

protocol Backupable {
    func createBackup(includeHistory: Bool) async throws -> URL
    func restoreBackup(url: URL) async throws
}

protocol Historiable {
    func recordEvent(remoteName: String, buttonName: String, irCode: String, success: Bool)
    func getRecentEvents(limit: Int) -> [HistoryEvent]
    func getEvents(filter: HistoryFilter) -> [HistoryEvent]
    func clearAll()
}

struct HistoryFilter {
    var remoteName: String?
    var startDate: Date?
    var endDate: Date?
    var successOnly: Bool?
}
