import SwiftUI
import WispShared

struct AuraPicker: View {
    @Binding var selection: Aura
    var swipeDirection: Edge = .trailing
    @State private var isReady = false

    private var allAuras: [Aura] { Aura.allCases }
    private var auraIndex: Int { allAuras.firstIndex(of: selection) ?? 0 }

    var body: some View {
        VStack(spacing: WispTheme.Spacing.sm) {
            Text(selection.rawValue)
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundStyle(WispTheme.Colors.tertiaryText)
                .textCase(.uppercase)
                .tracking(3)
                .id(selection)
                .transition(.asymmetric(
                    insertion: .move(edge: swipeDirection).combined(with: .opacity),
                    removal: .move(edge: swipeDirection == .trailing ? .leading : .trailing).combined(with: .opacity)
                ))

            HStack(spacing: 8) {
                ForEach(visibleDots, id: \.aura) { dot in
                    Circle()
                        .fill(dot.aura.gradient)
                        .frame(width: dot.isCenter ? 10 : 6, height: dot.isCenter ? 10 : 6)
                        .opacity(dot.isCenter ? 1 : dot.distance == 1 ? 0.5 : 0.2)
                }
            }
            .animation(isReady ? .easeInOut(duration: 0.35) : nil, value: auraIndex)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isReady = true
            }
        }
    }

    private struct AuraDot: Identifiable {
        let aura: Aura
        let isCenter: Bool
        let distance: Int
        var id: String { aura.rawValue }
    }

    private var visibleDots: [AuraDot] {
        (-2...2).map { offset in
            let index = ((auraIndex + offset) % allAuras.count + allAuras.count) % allAuras.count
            return AuraDot(aura: allAuras[index], isCenter: offset == 0, distance: abs(offset))
        }
    }
}
