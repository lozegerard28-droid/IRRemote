import SwiftUI

struct ThemeSettingsView: View {
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        List {
            ForEach(themeManager.availableThemes, id: \.name) { theme in
                HStack {
                    Circle()
                        .fill(Color(hex: theme.colors.primary))
                        .frame(width: 24, height: 24)
                    VStack(alignment: .leading) {
                        Text(theme.name)
                            .font(.body)
                        if let author = theme.author {
                            Text(author)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                    if themeManager.activeTheme.name == theme.name {
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    themeManager.applyTheme(theme)
                }
            }
        }
        .navigationTitle("Thèmes")
    }
}
