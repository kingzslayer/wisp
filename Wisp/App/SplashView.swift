import SwiftUI
import WispShared

struct SplashView: View {
    var body: some View {
        ZStack {
            Aura.nebula.gradient.ignoresSafeArea()
            Text("wisp")
                .font(WispTheme.Typography.hero)
                .textShimmer()
        }
    }
}

#Preview {
    SplashView()
}
