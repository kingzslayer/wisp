import SwiftUI
import WispShared

struct ProfileSetupView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var toastState: ToastState
    @State private var name = ""
    @State private var thread = ""
    @State private var isSaving = false

    var body: some View {
        ZStack {
            AuraGradient()

            VStack(spacing: WispTheme.Spacing.xxl) {
                Spacer()

                VStack(spacing: WispTheme.Spacing.md) {
                    Text("one last thing")
                        .font(WispTheme.Typography.hero)
                        .foregroundStyle(WispTheme.Colors.primaryText)

                    Text("what should we call you?")
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(WispTheme.Colors.secondaryText)
                }

                Spacer()

                VStack(spacing: WispTheme.Spacing.md) {
                    WispTextField(
                        placeholder: "your name",
                        text: $name,
                        alignment: .center,
                        isDisabled: isSaving
                    )
                    .textContentType(.name)

                    AuraCard {
                            Text(thread)
                                .font(.system(size: 22, weight: .light, design: .serif))
                                .italic()
                                .foregroundStyle(WispTheme.Colors.primaryText)
                                .id(thread)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .opacity),
                                    removal: .move(edge: .top).combined(with: .opacity)
                                ))
                        }
                        .frame(height: 100)
                        .overlay(alignment: .topTrailing) {
                            Button {
                                withAnimation(.easeInOut(duration: WispTheme.Animation.stateTransition)) {
                                    thread = ThreadGenerator.generate()
                                }
                            } label: {
                                Image(systemName: "shuffle")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(WispTheme.Colors.secondaryText)
                                    .padding(WispTheme.Spacing.md)
                            }
                        }

                    WispButton(
                        title: "that's me",
                        isLoading: isSaving,
                        isDisabled: name.trimmingCharacters(in: .whitespaces).isEmpty || thread.isEmpty
                    ) {
                        Task { await save() }
                    }

                    WispButton(title: "logout", style: .ghost) {
                        Task { try? await appState.signOut() }
                    }
                }

                Spacer().frame(height: WispTheme.Spacing.safeBottom)
            }
            .padding(.horizontal, WispTheme.Spacing.xxl)
        }
        .preferredColorScheme(.dark)
        .task {
            thread = await ThreadGenerator.generateUnique()
        }
    }

    private func save() async {
        isSaving = true
        defer { isSaving = false }
        do {
            try await appState.createUser(
                name: name.trimmingCharacters(in: .whitespaces),
                thread: thread
            )
        } catch {
            toastState.show(.error(ErrorMapper.message(for: error)))
        }
    }
}

#Preview {
    ProfileSetupView()
        .environmentObject(AppState())
        .environmentObject(ToastState())
}
