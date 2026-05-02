import SwiftUI
import WispShared

struct AuraText: View {
    let text: String
    var font: Font = WispTheme.Typography.hero

    init(_ text: String, font: Font = WispTheme.Typography.hero) {
        self.text = text
        self.font = font
    }

    @State private var colorIndex = 0
    @State private var phase: CGFloat = 0

    private let auras = Aura.allCases

    var body: some View {
        Text(text)
            .font(font)
            .hidden()
            .overlay {
                LinearGradient(
                    colors: auras[colorIndex].colors,
                    startPoint: UnitPoint(x: phase - 0.5, y: 0),
                    endPoint: UnitPoint(x: phase + 0.5, y: 1)
                )
                .mask {
                    Text(text)
                        .font(font)
                }
            }
            .onAppear {
                withAnimation(
                    .easeInOut(duration: WispTheme.Animation.gradientShift)
                    .repeatForever(autoreverses: true)
                ) {
                    phase = 1.0
                }
            }
            .onDisappear {
                phase = 0
            }
            .task {
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(WispTheme.Animation.gradientCycle))
                    guard !Task.isCancelled else { break }
                    withAnimation(.easeInOut(duration: WispTheme.Animation.colorTransition)) {
                        colorIndex = (colorIndex + 1) % auras.count
                    }
                }
            }
    }
}
