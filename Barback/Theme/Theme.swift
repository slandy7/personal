import SwiftUI

enum AppTheme {
    // MARK: - Brand Colors

    static let amber = Color(red: 0.83, green: 0.65, blue: 0.41)
    static let warmBrown = Color(red: 0.55, green: 0.35, blue: 0.17)
    static let deepAmber = Color(red: 0.72, green: 0.45, blue: 0.15)
    static let cream = Color(red: 0.98, green: 0.96, blue: 0.91)
    static let darkWood = Color(red: 0.26, green: 0.15, blue: 0.07)

    // MARK: - Semantic Colors

    static let favorite = Color(red: 0.77, green: 0.38, blue: 0.42) // warm rose
    static let statusReady = Color(red: 0.18, green: 0.55, blue: 0.28) // accessible green
    static let statusMissing = deepAmber

    // Level colors — 3 states for clarity
    static let levelHealthy = Color(red: 0.18, green: 0.55, blue: 0.28)
    static let levelCaution = amber
    static let levelCritical = Color(red: 0.75, green: 0.19, blue: 0.19)

    static func levelColor(for level: Double) -> Color {
        switch level {
        case 0.5...1.0: return levelHealthy
        case 0.15..<0.5: return levelCaution
        default: return levelCritical
        }
    }

    // MARK: - Card Style

    static let cardCornerRadius: CGFloat = 16
    static let cardShadowRadius: CGFloat = 6
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

// MARK: - Press State Button Style

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
