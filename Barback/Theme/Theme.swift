import SwiftUI

enum AppTheme {
    // MARK: - Colors

    static let accent = Color("AccentColor", bundle: nil)
    static let amber = Color(red: 0.83, green: 0.65, blue: 0.41)
    static let warmBrown = Color(red: 0.55, green: 0.35, blue: 0.17)
    static let deepAmber = Color(red: 0.72, green: 0.45, blue: 0.15)
    static let cream = Color(red: 0.98, green: 0.96, blue: 0.91)
    static let darkWood = Color(red: 0.26, green: 0.15, blue: 0.07)

    // Semantic colors
    static let levelFull = Color.green
    static let levelGood = Color.mint
    static let levelHalf = Color.yellow
    static let levelLow = Color.orange
    static let levelEmpty = Color.red

    static func levelColor(for level: Double) -> Color {
        switch level {
        case 0.75...1.0: return levelFull
        case 0.5..<0.75: return levelGood
        case 0.25..<0.5: return levelHalf
        case 0.01..<0.25: return levelLow
        default: return levelEmpty
        }
    }

    // MARK: - Card Style

    static let cardCornerRadius: CGFloat = 16
    static let cardShadowRadius: CGFloat = 2
    static let smallCornerRadius: CGFloat = 10
}

// MARK: - View Modifiers

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
            .shadow(color: .black.opacity(0.06), radius: AppTheme.cardShadowRadius, y: 1)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
