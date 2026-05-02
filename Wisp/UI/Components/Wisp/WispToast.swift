import SwiftUI

struct WispToastView: View {
    let toast: ToastType

    var body: some View {
        HStack(spacing: WispTheme.Spacing.sm) {
            Image(systemName: toast.icon)
                .foregroundStyle(toast.iconColor)
            Text(toast.message)
                .font(WispTheme.Typography.toast)
                .foregroundStyle(WispTheme.Colors.primaryText)
        }
        .padding(.horizontal, WispTheme.Spacing.lg)
        .padding(.vertical, WispTheme.Spacing.md)
        .background(Color.white.opacity(0.15))
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(.white.opacity(0.15), lineWidth: 0.5)
        )
        .shadow(color: .white.opacity(0.05), radius: 12, y: 4)
    }
}
