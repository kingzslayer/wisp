import SwiftUI
import WispShared

struct AuraGradient: View {
    var aura: Aura? = nil
    var intensity: CGFloat = 1.0

    @State private var colorIndex = 0
    @State private var animateGradient = false

    private var activeColors: [Color] {
        if let aura { return aura.colors }
        return Aura.allCases[colorIndex].colors
    }

    var body: some View {
        LinearGradient(
            colors: activeColors,
            startPoint: animateGradient ? .topLeading : .bottomLeading,
            endPoint: animateGradient ? .bottomTrailing : .topTrailing
        )
        .drawingGroup()
        .ignoresSafeArea()
        .opacity(intensity)
        .onAppear {
            withAnimation(
                .linear(duration: WispTheme.Animation.gradientShift)
                .repeatForever(autoreverses: true)
            ) {
                animateGradient = true
            }
        }
        .onDisappear {
            animateGradient = false
        }
        .task {
            guard aura == nil else { return }
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(WispTheme.Animation.gradientCycle))
                guard !Task.isCancelled else { break }
                withAnimation(.easeInOut(duration: WispTheme.Animation.colorTransition)) {
                    colorIndex = (colorIndex + 1) % Aura.allCases.count
                }
            }
        }
    }
}
