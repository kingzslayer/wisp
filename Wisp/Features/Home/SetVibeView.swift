import SwiftUI
import WispShared

struct SetVibeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var toastState: ToastState
    @Environment(\.dismiss) private var dismiss
    let bondId: UUID
    @State private var selectedMood: Mood?
    @State private var statusText = ""
    @State private var isLoading = false
    @State private var didLoadInitial = false

    private var bondData: (bond: Bond, partner: WispUser, partnerVibe: Vibe?, myVibe: Vibe?)? {
        appState.bonds.first { $0.bond.id == bondId }
    }

    private let columns = Array(repeating: GridItem(.flexible(), spacing: WispTheme.Spacing.lg), count: 4)

    var body: some View {
        ZStack {
            if let data = bondData {
                AuraGradient(aura: data.partner.auraType)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: WispTheme.Spacing.xxl) {
                        Spacer().frame(height: WispTheme.Spacing.xxl)
                        partnerInfo(data.partner)
                        partnerVibeSection(data.partnerVibe)
                        Spacer().frame(height: WispTheme.Spacing.xxl)
                        moodGrid

                        VStack(spacing: WispTheme.Spacing.md) {
                            statusInput
                            setVibeButton
                        }

                        Spacer().frame(height: WispTheme.Spacing.safeBottom)
                    }
                    .padding(.horizontal, WispTheme.Spacing.xl)
                    .frame(minHeight: UIScreen.main.bounds.height)
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
        .overlay(alignment: .topTrailing) {
            WispButton(icon: "xmark", compact: true) {
                dismiss()
            }
            .padding(.trailing, WispTheme.Spacing.lg)
        }
        .preferredColorScheme(.dark)
        .wispToast()
        .onAppear {
            guard !didLoadInitial, let data = bondData else { return }
            didLoadInitial = true
            if let myVibe = data.myVibe {
                selectedMood = Mood.allCases.first { $0.rawValue == myVibe.mood }
                statusText = myVibe.status ?? ""
            }
        }
    }

    private func partnerInfo(_ partner: WispUser) -> some View {
        VStack(spacing: WispTheme.Spacing.sm) {
            Text(partner.name)
                .font(WispTheme.Typography.hero)
                .foregroundStyle(WispTheme.Colors.primaryText)

            HStack(spacing: WispTheme.Spacing.md) {
                Text(partner.thread.components(separatedBy: " ").first ?? "")
                    .font(.system(size: 18, weight: .light, design: .serif))
                    .italic()
                Image(systemName: "diamond.fill")
                    .font(.system(size: 6))
                    .opacity(0.5)
                Text(partner.thread.components(separatedBy: " ").last ?? "")
                    .font(.system(size: 18, weight: .light, design: .serif))
                    .italic()
            }
            .foregroundStyle(WispTheme.Colors.secondaryText)
        }
    }

    private var moodGrid: some View {
        LazyVGrid(columns: columns, spacing: WispTheme.Spacing.lg) {
            ForEach(Mood.allCases, id: \.self) { mood in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedMood = mood
                    }
                } label: {
                    Image(systemName: mood.rawValue)
                        .font(.system(size: 28, weight: .light))
                        .foregroundStyle(WispTheme.Colors.primaryText)
                        .frame(width: 56, height: 56)
                        .background {
                            if selectedMood == mood {
                                Circle()
                                    .fill(.white.opacity(0.2))
                            }
                        }
                        .overlay {
                            if selectedMood == mood {
                                Circle()
                                    .stroke(.white.opacity(0.4), lineWidth: 1)
                            }
                        }
                }
            }
        }
    }

    private var statusInput: some View {
        WispTextField(
            placeholder: "say something...",
            text: $statusText,
            alignment: .center,
            isDisabled: isLoading
        )
    }

    private var setVibeButton: some View {
        WispButton(
            title: "set vibe",
            isLoading: isLoading,
            isDisabled: selectedMood == nil
        ) {
            Task { await setVibe() }
        }
    }

    @ViewBuilder
    private func partnerVibeSection(_ partnerVibe: Vibe?) -> some View {
        if let partnerVibe {
            HStack(spacing: WispTheme.Spacing.sm) {
                Image(systemName: partnerVibe.mood)
                    .font(.system(size: 16, weight: .light))
                if let status = partnerVibe.status, !status.isEmpty {
                    Text(status)
                        .font(WispTheme.Typography.caption)
                }
            }
            .foregroundStyle(WispTheme.Colors.secondaryText)
            .padding(.vertical, WispTheme.Spacing.sm)
            .padding(.horizontal, WispTheme.Spacing.lg)
            .background(.white.opacity(0.1))
            .clipShape(Capsule())
        }
    }

    private func setVibe() async {
        guard let mood = selectedMood else { return }
        isLoading = true
        defer { isLoading = false }
        let status = statusText.trimmingCharacters(in: .whitespaces)
        do {
            try await appState.setVibe(
                bondId: bondId,
                mood: mood.rawValue,
                status: status.isEmpty ? nil : status
            )
            toastState.show(.success("vibe set"))
            dismiss()
        } catch {
            toastState.show(.error(ErrorMapper.message(for: error)))
        }
    }
}

#if DEBUG
#Preview {
    SetVibeView(bondId: AppState.previewBond.id)
        .environmentObject(AppState.preview)
        .environmentObject(ToastState())
}
#endif
