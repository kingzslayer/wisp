import SwiftUI
import WispShared

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var editedName: String = ""
    @State private var selectedAura: Aura = .aurora
    @State private var swipeDirection: Edge = .trailing
    @State private var showActivitySheet = false
    @State private var isSaving = false

    private var user: WispUser? { appState.currentUser }

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let auraHeight = geo.size.height * 0.75

                ZStack(alignment: .top) {
                    WispTheme.Colors.background.ignoresSafeArea()

                    selectedAura.gradient
                        .frame(height: auraHeight)
                        .overlay(
                            LinearGradient(
                                stops: [
                                    .init(color: .clear, location: 0),
                                    .init(color: .clear, location: 0.5),
                                    .init(color: WispTheme.Colors.background.opacity(0.5), location: 0.7),
                                    .init(color: WispTheme.Colors.background, location: 1.0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .ignoresSafeArea()

                    VStack(spacing: 0) {
                        identitySection
                            .frame(height: auraHeight * 0.9)

                        AuraPicker(selection: $selectedAura, swipeDirection: swipeDirection)
                            .padding(.bottom, WispTheme.Spacing.xl)

                        infoRows
                            .padding(.horizontal, WispTheme.Spacing.lg)

                        Spacer()

                        WispButton(title: "sign out", style: .destructive, icon: "rectangle.portrait.and.arrow.right") {
                            Task { await appState.signOut() }
                        }
                        .padding(.horizontal, WispTheme.Spacing.lg)

                        Spacer().frame(height: WispTheme.Spacing.safeBottom)
                    }
                    .frame(height: geo.size.height)
                }
            }
            .ignoresSafeArea(edges: .top)
            .preferredColorScheme(.dark)
        }
        .overlay(alignment: .topTrailing) {
            HStack(spacing: WispTheme.Spacing.md) {
                WispButton(icon: "square.and.arrow.up", compact: true) {
                    showActivitySheet = true
                }

                WispButton(title: "Done", compact: true, isLoading: isSaving) {
                    saveAndDismiss()
                }
            }
            .padding(.trailing, WispTheme.Spacing.lg)
        }
        .wispToast()
        .sheet(isPresented: $showActivitySheet) {
            if let thread = user?.thread {
                ActivitySheet(items: ["somewhere quiet, i was named \u{2014} \u{2726} \(thread) \u{2726}"])
            }
        }
        .gesture(
            DragGesture(minimumDistance: 15)
                .onEnded { handleSwipe($0.translation.width) }
        )
        .onAppear {
            editedName = user?.name ?? ""
            if let userAura = user?.auraType {
                selectedAura = userAura
            }
        }
        .onChange(of: user?.name) { _, newName in
            editedName = newName ?? ""
        }
        .onChange(of: user?.auraType) { _, newAura in
            if let newAura { selectedAura = newAura }
        }
    }

    private var identitySection: some View {
        VStack {
            Spacer()

            VStack(spacing: WispTheme.Spacing.lg) {
                TextField("", text: $editedName)
                    .font(WispTheme.Typography.hero)
                    .foregroundStyle(WispTheme.Colors.primaryText)
                    .multilineTextAlignment(.center)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.words)

                if let thread = user?.thread {
                    HStack(spacing: WispTheme.Spacing.md) {
                        Text(thread.components(separatedBy: " ").first ?? "")
                            .font(.system(size: 18, weight: .light, design: .serif))
                            .italic()
                        Image(systemName: "diamond.fill")
                            .font(.system(size: 6))
                            .opacity(0.5)
                        Text(thread.components(separatedBy: " ").last ?? "")
                            .font(.system(size: 18, weight: .light, design: .serif))
                            .italic()
                    }
                    .foregroundStyle(WispTheme.Colors.secondaryText)
                    .contextMenu {
                        Button {
                            UIPasteboard.general.string = thread
                        } label: {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                    }
                }
            }

            Spacer().frame(height: WispTheme.Spacing.xxl)
        }
    }

    private var infoRows: some View {
        VStack(spacing: WispTheme.Spacing.sm) {
            if let email = appState.email {
                capsuleRow(icon: "envelope", text: email)
            }
            if let date = user?.createdAt {
                capsuleRow(icon: "leaf", text: "since \(date.formatted(.dateTime.month(.wide).year()).lowercased())")
            }
        }
    }

    private func saveAndDismiss() {
        let name = editedName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { dismiss(); return }
        isSaving = true
        Task {
            try? await appState.updateUser(name: name, aura: selectedAura.rawValue)
            isSaving = false
            dismiss()
        }
    }

    private func handleSwipe(_ horizontal: CGFloat) {
        guard abs(horizontal) > 40 else { return }
        let allAuras = Aura.allCases
        guard let currentIndex = allAuras.firstIndex(of: selectedAura) else { return }
        let forward = horizontal < 0
        swipeDirection = forward ? .trailing : .leading
        withAnimation(.easeInOut(duration: 0.5)) {
            selectedAura = allAuras[(currentIndex + (forward ? 1 : -1) + allAuras.count) % allAuras.count]
        }
    }

    private func capsuleRow(icon: String, text: String) -> some View {
        HStack(spacing: WispTheme.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundStyle(WispTheme.Colors.tertiaryText)
            Text(text)
                .font(WispTheme.Typography.caption)
                .foregroundStyle(WispTheme.Colors.secondaryText)
            Spacer()
        }
        .padding(.horizontal, WispTheme.Spacing.lg)
        .padding(.vertical, WispTheme.Spacing.lg)
        .background(WispTheme.Colors.glassBg)
        .clipShape(RoundedRectangle(cornerRadius: WispTheme.Radius.xl))
    }
}

#if DEBUG
#Preview {
    SettingsView()
        .environmentObject(AppState.preview)
        .environmentObject(ToastState())
}
#endif
