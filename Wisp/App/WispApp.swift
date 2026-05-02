import SwiftUI
import WispShared

@main
struct WispApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var toastState = ToastState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(toastState)
                .onOpenURL { url in
                    handleDeepLink(url)
                }
        }
    }

    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "wisp",
              url.host == "vibe",
              let bondIdString = url.pathComponents.last,
              let bondId = UUID(uuidString: bondIdString) else { return }
        appState.deepLinkBondId = bondId
    }
}
