import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var events: [HistoryEvent] = []
    @Published var filterText = ""
    @Published var showClearAlert = false

    private let historyService = HistoryService.shared

    func loadHistory() {
        events = historyService.getRecentEvents(limit: 100)
    }

    func clearHistory() {
        historyService.clearAll()
        loadHistory()
    }
}
