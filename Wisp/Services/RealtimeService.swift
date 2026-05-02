import Foundation
import Supabase
import WispShared

@MainActor
enum RealtimeService {
    private static var channel: RealtimeChannelV2?
    private static var tasks: [Task<Void, Never>] = []

    static func startListening(onChange: @escaping @MainActor () async -> Void) {
        stopListening()

        let ch = SupabaseClientFactory.shared.realtimeV2.channel("wisp-changes")

        let vibesStream = ch.postgresChange(AnyAction.self, schema: "public", table: SupabaseConfig.Tables.vibes)
        let bondsStream = ch.postgresChange(AnyAction.self, schema: "public", table: SupabaseConfig.Tables.bonds)
        let reachesStream = ch.postgresChange(AnyAction.self, schema: "public", table: SupabaseConfig.Tables.reaches)
        let usersStream = ch.postgresChange(AnyAction.self, schema: "public", table: SupabaseConfig.Tables.users)

        channel = ch

        tasks.append(Task {
            do {
                try await ch.subscribeWithError()
            } catch {
                print("[Realtime] subscription error: \(error)")
                return
            }

            async let v: Void = { for await _ in vibesStream { await onChange() } }()
            async let b: Void = { for await _ in bondsStream { await onChange() } }()
            async let r: Void = { for await _ in reachesStream { await onChange() } }()
            async let u: Void = { for await _ in usersStream { await onChange() } }()
            _ = await (v, b, r, u)
        })
    }

    static func stopListening() {
        tasks.forEach { $0.cancel() }
        tasks = []

        if let ch = channel {
            Task { await ch.unsubscribe() }
            channel = nil
        }
    }
}
