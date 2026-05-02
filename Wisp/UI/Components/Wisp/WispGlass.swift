import SwiftUI

struct WispGlass: View {
    let isLoading: Bool
    @State private var sheenOffset: CGFloat = -0.3

    var body: some View {
        ZStack {
            Color.white.opacity(0.15)

            LinearGradient(
                colors: [.white.opacity(0.25), .clear],
                startPoint: UnitPoint(x: sheenOffset, y: 0),
                endPoint: UnitPoint(x: sheenOffset + 0.6, y: 1)
            )
        }
        .task(id: isLoading) {
            sheenOffset = -0.3
            withAnimation(
                .easeInOut(duration: isLoading ? 1.5 : 3.0)
                .repeatForever(autoreverses: true)
            ) {
                sheenOffset = 1.3
            }
        }
    }
}
