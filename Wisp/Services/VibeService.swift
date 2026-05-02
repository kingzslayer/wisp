import Foundation
import Supabase
import WispShared

enum VibeService {
    private static let supabase = SupabaseClientFactory.shared

    static func setVibe(bondId: UUID, senderId: UUID, mood: String, status: String?) async throws {
        try await supabase
            .from(SupabaseConfig.Tables.vibes)
            .upsert(
                VibeInsert(
                    bondId: bondId.uuidString,
                    senderId: senderId.uuidString,
                    mood: mood,
                    status: status
                ),
                onConflict: "bond_id,sender_id"
            )
            .execute()
    }

    static func fetchVibesForBonds(bondIds: [UUID]) async -> [Vibe] {
        guard !bondIds.isEmpty else { return [] }
        do {
            return try await supabase
                .from(SupabaseConfig.Tables.vibes)
                .select()
                .in("bond_id", values: bondIds.map(\.uuidString))
                .execute()
                .value
        } catch {
            return []
        }
    }

    static func fetchVibe(bondId: UUID, senderId: UUID) async -> Vibe? {
        do {
            let result: [Vibe] = try await supabase
                .from(SupabaseConfig.Tables.vibes)
                .select()
                .eq("bond_id", value: bondId.uuidString)
                .eq("sender_id", value: senderId.uuidString)
                .limit(1)
                .execute()
                .value
            return result.first
        } catch {
            return nil
        }
    }
}
