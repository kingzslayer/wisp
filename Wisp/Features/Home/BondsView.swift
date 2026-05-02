import SwiftUI
import WispShared

struct BondsView: View {
    @EnvironmentObject var appState: AppState
    @Binding var showAddBond: Bool
    @State private var selectedBondId: UUID?
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 0) {
            if appState.bonds.isEmpty {
                emptyState
                    .frame(maxHeight: .infinity)
            } else {
                bondList
            }
        }
        .frame(maxHeight: .infinity)
        .animation(.easeInOut(duration: WispTheme.Animation.stateTransition), value: appState.bonds.isEmpty)
        .fullScreenCover(isPresented: Binding(
            get: { selectedBondId != nil },
            set: { if !$0 { selectedBondId = nil } }
        )) {
            if let bondId = selectedBondId {
                SetVibeView(bondId: bondId)
            }
        }
    }

    private var emptyState: some View {
        ZStack {
            AuraGradient(aura: appState.currentUser?.auraType, intensity: 0.15)

            VStack(spacing: WispTheme.Spacing.lg) {
                Spacer()

                Image(systemName: "heart.circle")
                    .font(.system(size: 40, weight: .light))
                    .foregroundStyle(WispTheme.Colors.tertiaryText)

                Text("no bonds yet")
                    .font(WispTheme.Typography.title)
                    .foregroundStyle(WispTheme.Colors.secondaryText)

                WispButton(title: "add a bond", icon: "plus.circle", compact: true) {
                    showAddBond = true
                }

                Spacer()
            }
        }
    }

    private var bondList: some View {
        ScrollView {
            LazyVStack(spacing: WispTheme.Spacing.lg) {
                ForEach(Array(appState.bonds.enumerated()), id: \.element.bond.id) { index, item in
                    bondCard(
                        partner: item.partner,
                        bondedAt: item.bond.bondedAt,
                        partnerVibe: item.partnerVibe,
                        myVibe: item.myVibe
                    )
                    .onTapGesture { selectedBondId = item.bond.id }
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.08),
                        value: appeared
                    )
                }
            }
            .padding(.horizontal, WispTheme.Spacing.lg)
            .padding(.top, 90)
        }
        .onAppear { appeared = true }
        .onChange(of: appState.deepLinkBondId) { _, bondId in
            guard let bondId else { return }
            if appState.bonds.contains(where: { $0.bond.id == bondId }) {
                selectedBondId = bondId
            }
            appState.deepLinkBondId = nil
        }
    }

    private func bondCard(partner: WispUser, bondedAt: Date, partnerVibe: Vibe?, myVibe: Vibe?) -> some View {
        let hasVibes = partnerVibe != nil || myVibe != nil

        return AuraCard(aura: partner.auraType, active: hasVibes) {
            VStack(alignment: .leading, spacing: WispTheme.Spacing.md) {
                HStack(spacing: WispTheme.Spacing.md) {
                    Text(partner.name)
                        .font(WispTheme.Typography.title)
                        .foregroundStyle(WispTheme.Colors.primaryText)

                    threadLabel(partner.thread)

                    Spacer()

                    if let partnerVibe {
                        Text(partnerVibe.updatedAt.timeAgo)
                            .font(WispTheme.Typography.small)
                            .foregroundStyle(WispTheme.Colors.tertiaryText)
                    }
                }

                if hasVibes {
                    HStack(alignment: .top, spacing: WispTheme.Spacing.lg) {
                        if let partnerVibe {
                            vibeColumn(label: "them", vibe: partnerVibe)
                        }

                        if partnerVibe != nil && myVibe != nil {
                            Rectangle()
                                .fill(.white.opacity(0.1))
                                .frame(width: 0.5)
                                .padding(.vertical, WispTheme.Spacing.xs)
                        }

                        if let myVibe {
                            vibeColumn(label: "you", vibe: myVibe)
                        }
                    }
                    .padding(.vertical, WispTheme.Spacing.sm)
                }

                Text("bonded since \(bondedAt.formatted(.dateTime.month(.wide).year()).lowercased())")
                    .font(WispTheme.Typography.caption)
                    .foregroundStyle(WispTheme.Colors.tertiaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(WispTheme.Spacing.lg)
        }
    }

    private func vibeColumn(label: String, vibe: Vibe) -> some View {
        VStack(spacing: WispTheme.Spacing.sm) {
            Text(label)
                .font(WispTheme.Typography.small)
                .foregroundStyle(WispTheme.Colors.tertiaryText)

            Image(systemName: vibe.mood)
                .font(.system(size: 28, weight: .thin))
                .foregroundStyle(WispTheme.Colors.primaryText)

            if let status = vibe.status, !status.isEmpty {
                Text(status)
                    .font(.system(size: 13, weight: .light, design: .serif))
                    .italic()
                    .foregroundStyle(WispTheme.Colors.secondaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func threadLabel(_ thread: String) -> some View {
        HStack(spacing: WispTheme.Spacing.sm) {
            Image(systemName: "diamond.fill")
                .font(.system(size: 4))
                .opacity(0.5)
            Text(thread)
                .font(.system(size: 14, weight: .light, design: .serif))
                .italic()
        }
        .foregroundStyle(WispTheme.Colors.secondaryText)
    }
}

#if DEBUG
#Preview {
    BondsView(showAddBond: .constant(false))
        .environmentObject(AppState.preview)
        .environmentObject(ToastState())
}
#endif
