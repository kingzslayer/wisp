import SwiftUI
import WispShared

struct AuraCard<Content: View>: View {
    var aura: Aura?
    var active: Bool = false
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            if let aura {
                aura.gradient
                Color.black.opacity(active ? 0.1 : 0.55)
            } else {
                WispGlass(isLoading: false)
            }
            content()
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: WispTheme.Radius.xxl))
        .padding(active ? 6 : 0)
        .background {
            if active {
                RoundedRectangle(cornerRadius: WispTheme.Radius.xxl + 6)
                    .strokeBorder(
                        LinearGradient(
                            colors: (aura?.colors ?? [.white]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
                    .opacity(0.5)
            }
        }
    }
}
