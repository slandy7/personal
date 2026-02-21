import SwiftUI

struct BottleLevelView: View {
    let level: Double
    var height: CGFloat = 8
    var showLabel: Bool = false

    private var color: Color {
        AppTheme.levelColor(for: level)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(color.opacity(0.2))

                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(color)
                        .frame(width: max(geo.size.width * level, height))
                }
            }
            .frame(height: height)

            if showLabel {
                Text("\(Int(level * 100))%")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Bottle Shape View (decorative)

struct BottleShapeView: View {
    let level: Double
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack(alignment: .bottom) {
                // Bottle outline
                BottleShape()
                    .stroke(color.opacity(0.3), lineWidth: 1.5)

                // Fill
                BottleShape()
                    .fill(color.opacity(0.25))
                    .mask(
                        VStack(spacing: 0) {
                            Spacer()
                            Rectangle()
                                .frame(height: h * level * 0.75)
                        }
                    )
            }
            .frame(width: w, height: h)
        }
    }
}

struct BottleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        // Neck top
        path.move(to: CGPoint(x: w * 0.35, y: 0))
        path.addLine(to: CGPoint(x: w * 0.65, y: 0))

        // Neck
        path.addLine(to: CGPoint(x: w * 0.65, y: h * 0.15))

        // Shoulder
        path.addQuadCurve(
            to: CGPoint(x: w * 0.9, y: h * 0.3),
            control: CGPoint(x: w * 0.9, y: h * 0.15)
        )

        // Body
        path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.95))

        // Bottom
        path.addQuadCurve(
            to: CGPoint(x: w * 0.1, y: h * 0.95),
            control: CGPoint(x: w * 0.5, y: h * 1.02)
        )

        // Body left
        path.addLine(to: CGPoint(x: w * 0.1, y: h * 0.3))

        // Left shoulder
        path.addQuadCurve(
            to: CGPoint(x: w * 0.35, y: h * 0.15),
            control: CGPoint(x: w * 0.1, y: h * 0.15)
        )

        path.closeSubpath()
        return path
    }
}

#Preview {
    VStack(spacing: 20) {
        BottleLevelView(level: 0.85, showLabel: true)
        BottleLevelView(level: 0.5, showLabel: true)
        BottleLevelView(level: 0.15, showLabel: true)
        BottleLevelView(level: 0, showLabel: true)

        BottleShapeView(level: 0.6, color: .orange)
            .frame(width: 50, height: 100)
    }
    .padding()
}
