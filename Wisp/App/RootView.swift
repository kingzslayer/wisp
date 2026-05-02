import SwiftUI

private enum AppScreen: Equatable {
    case splash
    case welcome
    case onboarding
    case profileSetup
    case home
}

struct RootView: View {
    @EnvironmentObject var appState: AppState
    @State private var showOnboarding = false

    private var activeScreen: AppScreen {
        if appState.isLoading { return .splash }
        if !appState.isAuthenticated { return showOnboarding ? .onboarding : .welcome }
        if appState.needsProfileSetup { return .profileSetup }
        return .home
    }

    var body: some View {
        Group {
            switch activeScreen {
            case .splash:
                SplashView()
            case .welcome:
                WelcomeView(showOnboarding: $showOnboarding)
            case .onboarding:
                OnboardingView()
            case .profileSetup:
                ProfileSetupView()
            case .home:
                HomeView()
            }
        }
        .animation(.easeInOut, value: activeScreen)
        .wispToast()
    }
}
