import SwiftUI

struct ScenarioListView: View {
    @StateObject private var viewModel = ScenarioViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.scenarios, id: \.id) { scenario in
                    HStack {
                        Image(systemName: scenario.icon ?? "play.circle")
                            .foregroundColor(themeManager.currentTheme.colors.primary)
                        VStack(alignment: .leading) {
                            Text(scenario.name ?? "").font(.body)
                            if let steps = scenario.steps {
                                Text("\(steps.count) étape(s)").font(.caption).foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                        if viewModel.isRunning {
                            ProgressView()
                        } else {
                            Button("Lancer") {
                                Task { await viewModel.executeScenario(scenario) }
                            }
                            .buttonStyle(.borderedProminent).controlSize(.small)
                        }
                    }
                }
            }
            .navigationTitle("Scénarios")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { Button(action: {}) { Image(systemName: "plus") } }
            }
            .onAppear { viewModel.loadScenarios() }
        }
    }
}
