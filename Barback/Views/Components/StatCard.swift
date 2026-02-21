import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .contentTransition(.numericText())

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 8)
        .cardStyle()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title): \(value)")
    }
}

struct LargeFeatureCard: View {
    let cocktail: Cocktail
    let canMake: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        if canMake {
                            Label("Ready to make", systemImage: "checkmark.circle.fill")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(AppTheme.statusReady)
                        }

                        Text(cocktail.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)

                        Text(cocktail.glass.rawValue)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: cocktail.glass.icon)
                        .font(.system(size: 36))
                        .foregroundStyle(cocktail.category.color.opacity(0.7))
                }

                // Ingredient pills
                FlowLayout(spacing: 6) {
                    ForEach(cocktail.ingredients) { ingredient in
                        Text(ingredient.name)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(cocktail.category.color.opacity(0.12))
                            .foregroundStyle(cocktail.category.color)
                            .clipShape(Capsule())
                    }
                }

                Text(cocktail.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .padding(16)
            .cardStyle()
        }
        .buttonStyle(ScaleButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(cocktail.name), \(canMake ? "ready to make" : ""), \(cocktail.glass.rawValue)")
        .accessibilityHint("Double tap to view recipe")
    }
}

// MARK: - Flow Layout for ingredient pills

struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }

            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x)
        }

        return (positions, CGSize(width: maxX, height: y + rowHeight))
    }
}

#Preview {
    VStack {
        HStack {
            StatCard(title: "Bottles", value: "12", icon: "wineglass.fill", color: AppTheme.amber)
            StatCard(title: "Can Make", value: "8", icon: "checkmark.circle.fill", color: AppTheme.statusReady)
            StatCard(title: "One Away", value: "5", icon: "hand.point.up.fill", color: AppTheme.deepAmber)
        }
        .padding()
    }
}
