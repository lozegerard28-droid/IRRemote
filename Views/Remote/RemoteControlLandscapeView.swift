import SwiftUI

struct RemoteControlLandscapeView: View {
    let remote: Remote
    @StateObject private var viewModel = RemoteControlViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(remote.name)
                    .font(.headline)
                Spacer()
            }
            .padding()

            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 6), count: 4), spacing: 6) {
                ForEach(remote.sortedButtons, id: \.id) { button in
                    Button {
                        viewModel.sendIR(button: button)
                    } label: {
                        Text(button.name)
                            .font(.caption.bold())
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color(.tertiarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding(.horizontal)

            Button("STOP") { viewModel.stopRepeat() }
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
        }
        .onAppear {
            viewModel.loadRemote(remote)
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}
