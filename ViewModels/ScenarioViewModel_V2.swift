import SwiftUI
import CoreData

@MainActor
class ScenarioViewModel: ObservableObject {
    @Published var scenarios: [Scenario] = []
    @Published var isRunning = false
    @Published var currentStep = 0

    let irService = IRTransmitterService.shared

    func loadScenarios() {
        let request = Scenario.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        scenarios = (try? PersistenceController.shared.viewContext.fetch(request)) ?? []
    }

    @MainActor
    func executeScenario(_ scenario: Scenario) async {
        guard !isRunning else { return }
        isRunning = true
        currentStep = 0
        defer { isRunning = false }

        let steps = (scenario.steps ?? []).sorted { $0.sortOrder < $1.sortOrder }
        for step in steps {
            guard isRunning else { break }
            if step.delay > 0 {
                try? await Task.sleep(nanoseconds: UInt64(step.delay * 1_000_000_000))
            }
            guard let button = step.button else { continue }
            do {
                let proto = IRProtocol(rawValue: button.protocolType ?? "NEC") ?? .nec
                try await irService.send(code: button.irCode, protocolType: proto, bits: Int(button.bitCount))
            } catch {
                AppLogger.error("Scenario step failed: \(error)", category: AppLogger.ir)
            }
            currentStep += 1
        }
    }

    func cancelScenario() {
        isRunning = false
    }
}
