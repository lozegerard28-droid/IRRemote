import SwiftUI

struct RemoteControlView: View {
    @StateObject private var viewModel = RemoteControlViewModel()
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var themeManager: ThemeManager
    let remote: Remote
    
    private let gridLayout = [GridItem(.adaptive(minimum: 80))]
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left").font(.title3)
                        .foregroundColor(themeManager.currentTheme.colors.text)
                }
                Spacer()
                Text(remote.name).font(.headline).foregroundColor(themeManager.currentTheme.colors.text)
                Spacer()
                Button(action: {}) { Image(systemName: "pencil").foregroundColor(themeManager.currentTheme.colors.textSecondary) }
            }
            .padding(.horizontal).padding(.vertical, 8)
            .background(themeManager.currentTheme.colors.surface)
            
            Divider().background(themeManager.currentTheme.colors.divider)
            
            // Button grid
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(viewModel.buttons, id: \.id) { button in
                        RemoteButtonView(button: button, theme: themeManager.currentTheme) {
                            Task { await viewModel.sendCommand(button: button) }
                        }
                    }
                }
                .padding()
            }
            
            // Stop button
            if viewModel.isSending {
                Button(action: {}) {
                    Label("STOP", systemImage: "stop.fill").font(.title3).bold()
                        .frame(maxWidth: .infinity).padding(.vertical, 12)
                        .background(Color.red).foregroundColor(.white)
                }
                .padding(.horizontal).padding(.bottom, 8)
            }
        }
        .background(themeManager.currentTheme.colors.background)
        .navigationBarHidden(true)
        .onAppear { viewModel.loadRemote(remote) }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            viewModel.toggleOrientation()
        }
    }
}

struct RemoteButtonView: View {
    let button: Button
    let theme: IRTheme
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Text(button.name)
                .font(.system(size: theme.fonts.size.button, weight: .bold))
                .foregroundColor(theme.colors.buttonText)
                .frame(maxWidth: .infinity, minHeight: 60)
                .background(isPressed ? theme.colors.buttonPressed : theme.colors.buttonBackground)
                .cornerRadius(theme.shapes.buttonCornerRadius)
                .overlay(theme.shapes.buttonBorderWidth > 0 ? RoundedRectangle(cornerRadius: theme.shapes.buttonCornerRadius).stroke(theme.colors.border, lineWidth: theme.shapes.buttonBorderWidth) : nil)
        }
        .scaleEffect(isPressed ? theme.animations.pressScale : 1.0)
        .animation(.easeInOut(duration: theme.animations.pressDuration), value: isPressed)
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in isPressed = true }
            .onEnded { _ in isPressed = false }
        )
    }
}
