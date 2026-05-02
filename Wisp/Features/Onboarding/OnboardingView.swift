import SwiftUI

private enum OnboardingPhase {
    case email, sending, codeSent, verifying
}

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var toastState: ToastState
    @State private var phase: OnboardingPhase = .email
    @State private var email = ""
    @State private var otpCode = ""
    @State private var resendCountdown = 0
    @State private var isResending = false
    @State private var resendGeneration = 0

    var body: some View {
        ZStack {
            AuraGradient()

            VStack(spacing: WispTheme.Spacing.xxl) {
                Spacer()
                titleSection
                Spacer()
                authSection
                Spacer().frame(height: WispTheme.Spacing.safeBottom)
            }
            .padding(.horizontal, WispTheme.Spacing.xxl)
        }
        .preferredColorScheme(.dark)
        .task(id: resendGeneration) {
            guard resendGeneration > 0 else { return }
            resendCountdown = WispTheme.Animation.resendCooldown
            while resendCountdown > 0 {
                try? await Task.sleep(for: .seconds(1))
                resendCountdown -= 1
            }
        }
    }

    private var titleSection: some View {
        VStack(spacing: WispTheme.Spacing.md) {
            Text("wisp")
                .font(WispTheme.Typography.hero)
                .foregroundStyle(WispTheme.Colors.primaryText)

            Text(subtitleText)
                .font(.system(size: 18, weight: .light))
                .foregroundStyle(WispTheme.Colors.secondaryText)
                .animation(.easeInOut, value: phase)
        }
    }

    private var subtitleText: String {
        switch phase {
        case .email, .sending: return "feel your people"
        case .codeSent, .verifying: return "we whispered a code to your inbox"
        }
    }

    @ViewBuilder
    private var authSection: some View {
        VStack(spacing: WispTheme.Spacing.lg) {
            if phase == .email || phase == .sending {
                emailSection
                    .transition(.asymmetric(
                        insertion: .opacity,
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }

            if phase == .codeSent || phase == .verifying {
                codeSection
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
    }

    private var emailSection: some View {
        VStack(spacing: WispTheme.Spacing.md) {
            WispTextField(
                placeholder: "your email",
                text: $email,
                keyboardType: .emailAddress,
                isDisabled: phase == .sending
            )
            .textContentType(.emailAddress)

            WispButton(
                title: "let's go",
                isLoading: phase == .sending,
                isDisabled: !Validators.isValidEmail(email)
            ) {
                Task { await sendOTP() }
            }
        }
    }

    private var codeSection: some View {
        VStack(spacing: WispTheme.Spacing.md) {
            Text(email)
                .font(WispTheme.Typography.small)
                .foregroundStyle(WispTheme.Colors.tertiaryText)

            WispTextField(
                placeholder: "enter code",
                text: $otpCode,
                keyboardType: .numberPad,
                alignment: .center,
                isDisabled: phase == .verifying,
                fontDesign: .monospaced
            )

            WispButton(
                title: "open sesame",
                isLoading: phase == .verifying,
                isDisabled: otpCode.isEmpty
            ) {
                Task { await verifyOTP() }
            }

            WispButton(
                title: resendCountdown > 0
                    ? "whisper again in \(resendCountdown)s"
                    : "whisper again",
                style: .ghost,
                isLoading: isResending,
                isDisabled: resendCountdown > 0 || isResending
            ) {
                Task { await resendCode() }
            }
        }
    }

    private func sendOTP() async {
        withAnimation(.easeInOut(duration: WispTheme.Animation.stateTransition)) {
            phase = .sending
        }
        do {
            try await appState.sendOTP(email: email)
            withAnimation(.easeInOut(duration: WispTheme.Animation.stateTransition)) {
                phase = .codeSent
            }
            resendGeneration += 1
            toastState.show(.success("code sent ✨"))
        } catch {
            withAnimation(.easeInOut(duration: WispTheme.Animation.stateTransition)) {
                phase = .email
            }
            toastState.show(.error(ErrorMapper.message(for: error)))
        }
    }

    private func verifyOTP() async {
        withAnimation(.easeInOut(duration: WispTheme.Animation.stateTransition)) {
            phase = .verifying
        }
        do {
            try await appState.verifyOTP(email: email, token: otpCode)
        } catch {
            withAnimation(.easeInOut(duration: WispTheme.Animation.stateTransition)) {
                phase = .codeSent
            }
            toastState.show(.error(ErrorMapper.message(for: error)))
        }
    }

    private func resendCode() async {
        isResending = true
        defer { isResending = false }
        do {
            try await appState.sendOTP(email: email)
            resendGeneration += 1
            toastState.show(.success("code sent ✨"))
        } catch {
            toastState.show(.error(ErrorMapper.message(for: error)))
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
        .environmentObject(ToastState())
}
