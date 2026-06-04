import SwiftUI

struct ThemePreviewView: View {
    let theme: IRTheme
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 8) {
            // Preview cards
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 8).fill(theme.colors.primary).frame(width: 30, height: 30)
                RoundedRectangle(cornerRadius: 8).fill(theme.colors.secondary).frame(width: 30, height: 30)
                RoundedRectangle(cornerRadius: 8).fill(theme.colors.success).frame(width: 30, height: 30)
                RoundedRectangle(cornerRadius: 8).fill(theme.colors.error).frame(width: 30, height: 30)
                RoundedRectangle(cornerRadius: 8).fill(theme.colors.warning).frame(width: 30, height: 30)
            }
            Text(theme.name).font(.caption).fontWeight(.medium)
            Text(theme.isBuiltIn ? "Intégré" : "Importé").font(.caption2).foregroundColor(.secondary)
        }
        .padding(12)
        .background(theme.colors.surface)
        .cornerRadius(theme.shapes.cardCornerRadius)
        .overlay(RoundedRectangle(cornerRadius: theme.shapes.cardCornerRadius).stroke(themeManager.currentTheme == theme ? theme.colors.primary : Color.clear, lineWidth: 2))
        .onTapGesture { themeManager.applyTheme(theme) }
    }
}
