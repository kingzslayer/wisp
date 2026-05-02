import SwiftUI
import WispShared

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showSettings = false
    @State private var showAddBond = false

    var body: some View {
        ZStack {
            WispTheme.Colors.background.ignoresSafeArea()
            AuraGradient(aura: appState.currentUser?.auraType, intensity: 0.15)

            BondsView(showAddBond: $showAddBond)
        }
        .overlay(alignment: .top) {
            HStack(alignment: .center) {
                Text("wisp")
                    .font(WispTheme.Typography.hero)
                    .textShimmer()

                Spacer()

                HStack(spacing: WispTheme.Spacing.md) {
                    if !appState.bonds.isEmpty {
                        WispButton(icon: "plus.circle", compact: true) {
                            showAddBond = true
                        }
                    }
                    WispButton(icon: "gearshape", compact: true) {
                        showSettings = true
                    }
                }
            }
            .padding(.horizontal, WispTheme.Spacing.lg)
        }
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $showAddBond) {
            AddBondView()
                .environmentObject(appState)
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(appState)
        }
    }
}

#if DEBUG
#Preview {
    HomeView()
        .environmentObject(AppState.preview)
        .environmentObject(ToastState())
}
#endif
