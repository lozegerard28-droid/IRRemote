import SwiftUI

struct ThemePreviewView: View {
    let theme: ThemeDTO
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 8).fill(Color(hex: theme.colors.primary)).frame(width: 30, height: 30)
                RoundedRectangle(cornerRadius: 8).fill(Color(hex: theme.colors.background)).frame(width: 30, height: 30)
                RoundedRectangle(cornerRadius: 8).fill(Color(hex: theme.colors.success)).frame(width: 30, height: 30)
                RoundedRectangle(cornerRadius: 8).fill(Color(hex: theme.colors.error)).frame(width: 30, height: 30)
                RoundedRectangle(cornerRadius: 8).fill(Color(hex: theme.colors.favorite)).frame(width: 30, height: 30)
            }
            Text(theme.name).font(.caption).fontWeight(.medium)
            Text(theme.author).font(.caption2).foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(hex: theme.colors.surface))
        .cornerRadius(theme.shapes?.cardCornerRadius ?? 16)
        .overlay(RoundedRectangle(cornerRadius: theme.shapes?.cardCornerRadius ?? 16).stroke(Color(hex: theme.colors.primary), lineWidth: 2))
    }
}
