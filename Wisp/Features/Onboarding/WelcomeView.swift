import SwiftUI

struct WelcomeView: View {
    @Binding var showOnboarding: Bool
    @State private var titleScale: CGFloat = 0.8
    @State private var glowOpacity: Double = 0.3

    var body: some View {
        ZStack {
            AuraGradient()

            VStack(spacing: WispTheme.Spacing.xxl) {
                Spacer()

                VStack(spacing: WispTheme.Spacing.md) {
                    Text("wisp")
                        .font(WispTheme.Typography.hero)
                        .foregroundStyle(WispTheme.Colors.primaryText)
                        .scaleEffect(titleScale)
                        .shadow(
                            color: .white.opacity(glowOpacity),
                            radius: 20
                        )

                    Text("a gentle presence")
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(WispTheme.Colors.secondaryText)
                }

                Spacer()

                WispButton(title: "step in") {
                    withAnimation(.easeInOut(duration: WispTheme.Animation.stateTransition)) {
                        showOnboarding = true
                    }
                }
                .padding(.horizontal, WispTheme.Spacing.xxl)

                Spacer().frame(height: WispTheme.Spacing.safeBottom)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.6)) {
                titleScale = 1.0
            }
            withAnimation(
                .easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
            ) {
                glowOpacity = 0.6
            }
        }
        .onDisappear {
            titleScale = 0.8
            glowOpacity = 0.3
        }
    }
}

#Preview {
    WelcomeView(showOnboarding: .constant(false))
}
