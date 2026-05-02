import SwiftUI

@MainActor
final class ToastState: ObservableObject {
    @Published var current: ToastType?
    private var dismissTask: Task<Void, Never>?

    func show(_ toast: ToastType) {
        dismissTask?.cancel()
        withAnimation(WispTheme.Animation.toastSpring) {
            current = toast
        }
        dismissTask = Task {
            try? await Task.sleep(for: .seconds(WispTheme.Animation.toastDuration))
            guard !Task.isCancelled else { return }
            dismiss()
        }
    }

    func dismiss() {
        withAnimation(WispTheme.Animation.toastSpring) {
            current = nil
        }
    }
}
