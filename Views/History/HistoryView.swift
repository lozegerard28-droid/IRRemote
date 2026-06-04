import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.events, id: \.id) { event in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(event.remoteName) • \(event.buttonName)")
                                .font(.subheadline).fontWeight(.medium)
                                .foregroundColor(themeManager.currentTheme.colors.text)
                            Text(event.irCode).font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(event.timestamp, style: .time).font(.caption2).foregroundColor(.secondary)
                            Text(event.timestamp, style: .date).font(.caption2).foregroundColor(.secondary)
                        }
                        if !event.success {
                            Image(systemName: "xmark.circle.fill").foregroundColor(.red).font(.caption)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Historique")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showClearAlert = true }) {
                        Image(systemName: "trash")
                    }
                }
            }
            .alert("Effacer l'historique ?", isPresented: $viewModel.showClearAlert) {
                Button("Annuler", role: .cancel) {}
                Button("Effacer", role: .destructive) { viewModel.clearHistory() }
            }
            .onAppear { viewModel.loadHistory() }
        }
    }
}
