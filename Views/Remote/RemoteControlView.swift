import SwiftUI

struct RemoteControlView: View {
    let remote: Remote
    @StateObject private var viewModel = RemoteControlViewModel()
    @Environment(\.dismiss) private var dismiss

    private let columns = 3

    var body: some View {
        VStack(spacing: 0) {
            topBar

            if viewModel.isLocked {
                lockOverlay
            } else {
                buttonGrid
            }

            stopButton
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadRemote(remote)
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }

    private var topBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
            }

            Spacer()

            Text(remote.name)
                .font(.headline)

            Spacer()

            Button { viewModel.toggleFavorite() } label: {
                Image(systemName: remote.isFavorite ? "star.fill" : "star")
                    .foregroundColor(remote.isFavorite ? .yellow : .gray)
            }

            Button { viewModel.showEdit.toggle() } label: {
                Image(systemName: "pencil")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private var buttonGrid: some View {
        GeometryReader { geo in
            let buttonSize = geo.size.width / CGFloat(columns) - 12
            ScrollView {
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 8), count: columns), spacing: 8) {
                    ForEach(remote.sortedButtons, id: \.id) { button in
                        Button {
                            viewModel.sendIR(button: button)
                        } label: {
                            Text(button.name)
                                .font(.system(size: buttonSize * 0.15, weight: .medium))
                                .frame(width: buttonSize, height: buttonSize)
                                .background(Color(.tertiarySystemBackground))
                                .foregroundColor(.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.3)
                                .onEnded { _ in
                                    viewModel.startRepeat(button: button)
                                }
                        )
                        .onLongPressGesture(minimumDuration: 0.3, perform: {}) { _ in
                            viewModel.stopRepeat()
                        }
                        .scaleEffect(viewModel.lastSentButton == button.name ? 0.95 : 1.0)
                        .animation(.easeOut(duration: 0.1), value: viewModel.lastSentButton)
                    }
                }
                .padding(8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var lockOverlay: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.fill")
                .font(.system(size: 48))
            Text("Cette pièce est verrouillée")
                .font(.title3)
            Button("Déverrouiller") {
                Task { await viewModel.authenticateIfNeeded() }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var stopButton: some View {
        Button("STOP") {
            viewModel.stopRepeat()
        }
        .font(.title2.bold())
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.red)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
    }
}
