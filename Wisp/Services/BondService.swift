import Foundation
import Supabase
import WispShared

enum BondError: Error {
    case threadNotFound
    case cannotBondWithSelf
    case alreadyBonded
    case alreadyReaching
}

enum BondService {
    private static let supabase = SupabaseClientFactory.shared

    static func findUserByThread(_ thread: String) async -> WispUser? {
        do {
            let result: [WispUser] = try await supabase
                .from(SupabaseConfig.Tables.users)
                .select()
                .eq("thread", value: thread)
                .limit(1)
                .execute()
                .value
            return result.first
        } catch {
            return nil
        }
    }

    static func reachOut(from currentUserId: UUID, toThread thread: String) async throws {
        guard let target = await findUserByThread(thread) else {
            throw BondError.threadNotFound
        }

        guard target.id != currentUserId else {
            throw BondError.cannotBondWithSelf
        }

        if await bondExists(between: currentUserId, and: target.id) {
            throw BondError.alreadyBonded
        }

        if await reachExists(from: currentUserId, to: target.id) {
            throw BondError.alreadyReaching
        }

        if await reachExists(from: target.id, to: currentUserId) {
            try await createBond(souls: [currentUserId, target.id])
            return
        }

        try await supabase
            .from(SupabaseConfig.Tables.reaches)
            .insert(ReachInsert(soulId: currentUserId.uuidString, kindredId: target.id.uuidString))
            .execute()
    }

    static func fetchBonds(userId: UUID) async -> [Bond] {
        do {
            return try await supabase
                .from(SupabaseConfig.Tables.bonds)
                .select()
                .contains("souls", value: [userId.uuidString])
                .execute()
                .value
        } catch {
            return []
        }
    }

    static func fetchPartner(bond: Bond, currentUserId: UUID) async -> WispUser? {
        guard let partnerId = bond.partnerId(for: currentUserId) else { return nil }
        return await UserService.fetch(id: partnerId)
    }

    private static func bondExists(between userA: UUID, and userB: UUID) async -> Bool {
        do {
            let result: [Bond] = try await supabase
                .from(SupabaseConfig.Tables.bonds)
                .select()
                .contains("souls", value: [userA.uuidString, userB.uuidString])
                .limit(1)
                .execute()
                .value
            return !result.isEmpty
        } catch {
            return false
        }
    }

    private static func reachExists(from soulId: UUID, to kindredId: UUID) async -> Bool {
        do {
            let result: [Reach] = try await supabase
                .from(SupabaseConfig.Tables.reaches)
                .select()
                .eq("soul_id", value: soulId.uuidString)
                .eq("kindred_id", value: kindredId.uuidString)
                .limit(1)
                .execute()
                .value
            return !result.isEmpty
        } catch {
            return false
        }
    }

    private static func createBond(souls: [UUID]) async throws {
        try await supabase
            .from(SupabaseConfig.Tables.bonds)
            .insert(BondInsert(souls: souls.map(\.uuidString)))
            .execute()
    }
}
