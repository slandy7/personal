import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    var buttonTitle: String?
    var action: (() -> Void)?

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: icon)
        } description: {
            Text(subtitle)
        } actions: {
            if let buttonTitle, let action {
                Button(action: action) {
                    Text(buttonTitle)
                        .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.amber)
            }
        }
    }
}

#Preview {
    EmptyStateView(
        icon: "wineglass",
        title: "Your Bar is Empty",
        subtitle: "Add your first bottle to get started.",
        buttonTitle: "Add Bottle",
        action: {}
    )
}
