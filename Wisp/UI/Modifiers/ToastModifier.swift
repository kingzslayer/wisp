import SwiftUI

struct ToastModifier: ViewModifier {
    @EnvironmentObject var toastState: ToastState

    func body(content: Content) -> some View {
        content.overlay(alignment: .top) {
            if let toast = toastState.current {
                WispToastView(toast: toast)
                    .padding(.top, WispTheme.Spacing.toastTop)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(WispTheme.Animation.toastSpring, value: toastState.current)
    }
}

extension View {
    func wispToast() -> some View {
        modifier(ToastModifier())
    }
}
