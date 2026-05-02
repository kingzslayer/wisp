import SwiftUI
import WispShared

struct WidgetAuraBackground: View {
    let auraName: String

    private var aura: Aura {
        Aura(rawValue: auraName) ?? .nebula
    }

    var body: some View {
        ZStack {
            RadialGradient(
                colors: aura.colors,
                center: .center,
                startRadius: 5,
                endRadius: 180
            )

            RadialGradient(
                colors: aura.colors.reversed().map { $0.opacity(0.4) },
                center: .topLeading,
                startRadius: 10,
                endRadius: 200
            )

            Color.black.opacity(0.25)
        }
    }
}
