import SwiftUI

enum WispButtonStyle {
    case primary
    case ghost
    case destructive
}

struct WispButton: View {
    var title: String? = nil
    var style: WispButtonStyle = .primary
    var icon: String? = nil
    var compact: Bool = false
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            switch style {
            case .primary:
                primaryContent
            case .ghost:
                ghostContent
            case .destructive:
                destructiveContent
            }
        }
        .buttonStyle(WispPressStyle())
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled || isLoading ? WispTheme.Colors.disabledOpacity : 1)
    }

    private var iconSize: CGFloat { title == nil ? 18 : 15 }

    @ViewBuilder
    private var label: some View {
        if isLoading {
            HStack(spacing: WispTheme.Spacing.sm) {
                if let icon { Image(systemName: icon).font(.system(size: iconSize)) }
                if let title { Text(title).textShimmer() }
            }
        } else {
            HStack(spacing: WispTheme.Spacing.sm) {
                if let icon { Image(systemName: icon).font(.system(size: iconSize)) }
                if let title { Text(title) }
            }
        }
    }

    private var primaryContent: some View {
        label
            .font(WispTheme.Typography.button)
            .foregroundStyle(WispTheme.Colors.primaryText)
            .padding(.vertical, compact ? WispTheme.Spacing.md : 0)
            .padding(.horizontal, compact ? WispTheme.Spacing.lg : 0)
            .frame(maxWidth: compact ? nil : .infinity)
            .frame(height: compact ? nil : 52)
            .background(WispGlass(isLoading: isLoading))
            .clipShape(RoundedRectangle(cornerRadius: WispTheme.Radius.xl))
            .overlay(
                RoundedRectangle(cornerRadius: WispTheme.Radius.xl)
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: .white.opacity(0.08), radius: 12, y: 4)
    }

    private var ghostContent: some View {
        label
            .font(WispTheme.Typography.button)
            .foregroundStyle(WispTheme.Colors.primaryText)
            .frame(maxWidth: compact ? nil : .infinity)
            .frame(height: 36)
    }

    private var destructiveContent: some View {
        label
            .font(WispTheme.Typography.button)
            .foregroundStyle(WispTheme.Colors.primaryText)
            .padding(.vertical, compact ? WispTheme.Spacing.md : 0)
            .padding(.horizontal, compact ? WispTheme.Spacing.lg : 0)
            .frame(maxWidth: compact ? nil : .infinity)
            .frame(height: compact ? nil : 52)
            .background {
                ZStack {
                    Color.red
                    WispGlass(isLoading: isLoading)
                        .opacity(0.15)
                        .blendMode(.overlay)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: WispTheme.Radius.xl))
    }
}

struct WispPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
