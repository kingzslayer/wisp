import SwiftUI
import WispShared

struct AddBondView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var toastState: ToastState
    @Environment(\.dismiss) private var dismiss
    @State private var thread = ""
    @State private var isLoading = false
    @State private var showActivitySheet = false

    private var canSubmit: Bool {
        thread.trimmingCharacters(in: .whitespaces).split(separator: " ").count == 2 && !isLoading
    }

    private var user: WispUser? { appState.currentUser }

    var body: some View {
        ZStack {
            AuraGradient(aura: user?.auraType, intensity: 0.6)

            ScrollView {
                VStack(spacing: WispTheme.Spacing.xxl) {
                    Spacer().frame(height: 60)

                    shareSection

                    divider

                    entrySection

                    Spacer().frame(height: WispTheme.Spacing.safeBottom)
                }
                .padding(.horizontal, WispTheme.Spacing.xl)
                .frame(minHeight: UIScreen.main.bounds.height)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .overlay(alignment: .topTrailing) {
            WispButton(icon: "xmark", compact: true) {
                dismiss()
            }
            .padding(.trailing, WispTheme.Spacing.lg)
        }
        .preferredColorScheme(.dark)
        .wispToast()
        .sheet(isPresented: $showActivitySheet) {
            if let thread = user?.thread {
                ActivitySheet(items: ["somewhere quiet, i was named \u{2014} \u{2726} \(thread) \u{2726}"])
            }
        }
    }

    private var shareSection: some View {
        VStack(spacing: WispTheme.Spacing.lg) {
            Text("YOUR THREAD")
                .font(WispTheme.Typography.caption)
                .foregroundStyle(WispTheme.Colors.tertiaryText)
                .tracking(2)

            if let thread = user?.thread {
                HStack(spacing: WispTheme.Spacing.md) {
                    Text(thread.components(separatedBy: " ").first ?? "")
                        .font(.system(size: 22, weight: .light, design: .serif))
                        .italic()
                    Image(systemName: "diamond.fill")
                        .font(.system(size: 6))
                        .opacity(0.5)
                    Text(thread.components(separatedBy: " ").last ?? "")
                        .font(.system(size: 22, weight: .light, design: .serif))
                        .italic()
                }
                .foregroundStyle(WispTheme.Colors.primaryText)
            }

            Text("share it with someone you trust")
                .font(WispTheme.Typography.small)
                .foregroundStyle(WispTheme.Colors.secondaryText)

            WispButton(title: "share thread", icon: "square.and.arrow.up") {
                showActivitySheet = true
            }
        }
    }

    private var divider: some View {
        HStack(spacing: WispTheme.Spacing.lg) {
            Rectangle()
                .fill(WispTheme.Colors.glassBorder)
                .frame(height: 0.5)
            Text("or")
                .font(WispTheme.Typography.caption)
                .foregroundStyle(WispTheme.Colors.tertiaryText)
            Rectangle()
                .fill(WispTheme.Colors.glassBorder)
                .frame(height: 0.5)
        }
    }

    private var entrySection: some View {
        VStack(spacing: WispTheme.Spacing.lg) {
            Text("ENTER THEIR THREAD")
                .font(WispTheme.Typography.caption)
                .foregroundStyle(WispTheme.Colors.tertiaryText)
                .tracking(2)

            WispTextField(
                placeholder: "their thread",
                text: $thread,
                alignment: .center,
                isDisabled: isLoading,
                fontDesign: .serif
            )

            WispButton(
                title: "reach out",
                isLoading: isLoading,
                isDisabled: !canSubmit
            ) {
                Task { await submit() }
            }
        }
    }

    private func submit() async {
        isLoading = true
        defer { isLoading = false }
        let trimmed = thread.trimmingCharacters(in: .whitespaces).lowercased()
        do {
            try await appState.reachOut(thread: trimmed)
            toastState.show(.success("a thread drifts toward them"))
            dismiss()
        } catch {
            toastState.show(.error(ErrorMapper.message(for: error)))
        }
    }
}

#if DEBUG
#Preview {
    AddBondView()
        .environmentObject(AppState.preview)
        .environmentObject(ToastState())
}
#endif
