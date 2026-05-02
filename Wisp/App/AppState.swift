import SwiftUI
import WidgetKit
import WispShared

@MainActor
final class AppState: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = true
    @Published var currentUser: WispUser?
    @Published var email: String?
    @Published var bonds: [(bond: Bond, partner: WispUser, partnerVibe: Vibe?, myVibe: Vibe?)] = []
    @Published var deepLinkBondId: UUID?

    var needsProfileSetup: Bool { isAuthenticated && currentUser == nil }

    init() {
        Task { await checkSession() }
    }

    private init(mock: Bool) {}

    func checkSession() async {
        defer { isLoading = false }
        do {
            let session = try await AuthService.session()
            email = session.user.email
            currentUser = await UserService.fetch(id: session.user.id)
            isAuthenticated = true
            persistUserIdForWidget(session.user.id)
            await loadBondState()
            RealtimeService.startListening { [weak self] in
                guard let self else { return }
                self.currentUser = await UserService.fetch(id: session.user.id)
                await self.loadBondState()
            }
        } catch {
            isAuthenticated = false
        }
    }

    func sendOTP(email: String) async throws {
        try await AuthService.sendOTP(email: email)
    }

    func verifyOTP(email: String, token: String) async throws {
        let session = try await AuthService.verifyOTP(email: email, token: token)
        self.email = session.user.email
        currentUser = await UserService.fetch(id: session.user.id)
        isAuthenticated = true
        persistUserIdForWidget(session.user.id)
    }

    func createUser(name: String, thread: String) async throws {
        let session = try await AuthService.session()
        let aura = Aura.allCases.randomElement()!.rawValue
        try await UserService.create(id: session.user.id, name: name, thread: thread, aura: aura)
        currentUser = await UserService.fetch(id: session.user.id)
    }

    func updateUser(name: String, aura: String) async throws {
        guard let user = currentUser else { return }
        try await UserService.update(id: user.id, name: name, aura: aura)
        currentUser = await UserService.fetch(id: user.id)
    }

    func signOut() async {
        RealtimeService.stopListening()
        defer {
            currentUser = nil
            email = nil
            bonds = []
            isAuthenticated = false
        }
        try? await AuthService.signOut()
        let defaults = UserDefaults(suiteName: SharedDefaults.suiteName)
        defaults?.removeObject(forKey: SharedDefaults.userIdKey)
        defaults?.removeObject(forKey: SharedDefaults.vibesKey)
    }

    func loadBondState() async {
        guard let user = currentUser else { return }
        let fetchedBonds = await BondService.fetchBonds(userId: user.id)
        let vibes = await VibeService.fetchVibesForBonds(bondIds: fetchedBonds.map(\.id))
        var resolved: [(bond: Bond, partner: WispUser, partnerVibe: Vibe?, myVibe: Vibe?)] = []
        for bond in fetchedBonds {
            if let partner = await BondService.fetchPartner(bond: bond, currentUserId: user.id) {
                let partnerVibe = vibes.first { $0.bondId == bond.id && $0.senderId == partner.id }
                let myVibe = vibes.first { $0.bondId == bond.id && $0.senderId == user.id }
                resolved.append((bond: bond, partner: partner, partnerVibe: partnerVibe, myVibe: myVibe))
            }
        }
        bonds = resolved
        writeVibesForWidget()
    }

    func reachOut(thread: String) async throws {
        guard let user = currentUser else { return }
        try await BondService.reachOut(from: user.id, toThread: thread)
        await loadBondState()
    }

    func setVibe(bondId: UUID, mood: String, status: String?) async throws {
        guard let user = currentUser else { return }
        try await VibeService.setVibe(bondId: bondId, senderId: user.id, mood: mood, status: status)
        await loadBondState()
    }

    private func writeVibesForWidget() {
        let widgetVibes = bonds.map { item in
            WidgetVibe(
                partnerName: item.partner.name,
                partnerThread: item.partner.thread,
                mood: item.partnerVibe?.mood,
                status: item.partnerVibe?.status,
                aura: item.partner.aura,
                bondId: item.bond.id.uuidString,
                updatedAt: item.partnerVibe?.updatedAt
            )
        }
        guard let data = try? JSONEncoder().encode(widgetVibes) else { return }
        UserDefaults(suiteName: SharedDefaults.suiteName)?.set(data, forKey: SharedDefaults.vibesKey)
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func persistUserIdForWidget(_ userId: UUID) {
        UserDefaults(suiteName: SharedDefaults.suiteName)?.set(userId.uuidString, forKey: SharedDefaults.userIdKey)
    }

    #if DEBUG
    static let previewUserId = UUID()
    static let previewPartnerId = UUID()
    static let previewHalfPartnerId = UUID()
    static let previewSilentPartnerId = UUID()
    static let previewBondId = UUID()
    static let previewHalfBondId = UUID()
    static let previewSilentBondId = UUID()

    static var previewPartner: WispUser {
        WispUser(id: previewPartnerId, name: "Sol", thread: "quiet moon", aura: "sunset")
    }

    static var previewHalfPartner: WispUser {
        WispUser(id: previewHalfPartnerId, name: "Ren", thread: "silver tide", aura: "lavender")
    }

    static var previewSilentPartner: WispUser {
        WispUser(id: previewSilentPartnerId, name: "Kai", thread: "drifting ember", aura: "ocean")
    }

    static var previewBond: Bond {
        Bond(id: previewBondId, souls: [previewUserId, previewPartnerId], bondedAt: .now)
    }

    static var previewHalfBond: Bond {
        Bond(id: previewHalfBondId, souls: [previewUserId, previewHalfPartnerId], bondedAt: .now)
    }

    static var previewSilentBond: Bond {
        Bond(id: previewSilentBondId, souls: [previewUserId, previewSilentPartnerId], bondedAt: .now)
    }

    static var previewPartnerVibe: Vibe {
        Vibe(bondId: previewBondId, senderId: previewPartnerId, mood: "heart.fill", status: "feeling warm")
    }

    static var previewMyVibe: Vibe {
        Vibe(bondId: previewBondId, senderId: previewUserId, mood: "sun.max.fill", status: "golden hour")
    }

    static var previewHalfPartnerVibe: Vibe {
        Vibe(bondId: previewHalfBondId, senderId: previewHalfPartnerId, mood: "moon.fill", status: "can't sleep")
    }

    static var preview: AppState {
        let state = AppState(mock: true)
        state.isAuthenticated = true
        state.isLoading = false
        state.email = "luna@wisp.app"
        state.currentUser = WispUser(
            id: previewUserId,
            name: "Luna",
            thread: "trembling candle",
            aura: "nebula"
        )
        state.bonds = [
            (
                bond: previewBond,
                partner: previewPartner,
                partnerVibe: previewPartnerVibe,
                myVibe: previewMyVibe
            ),
            (
                bond: previewHalfBond,
                partner: previewHalfPartner,
                partnerVibe: previewHalfPartnerVibe,
                myVibe: nil
            ),
            (
                bond: previewSilentBond,
                partner: previewSilentPartner,
                partnerVibe: nil,
                myVibe: nil
            )
        ]
        return state
    }
    #endif
}
