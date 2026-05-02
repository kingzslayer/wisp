import Foundation
import Supabase
import WispShared

enum UserService {
    private static let supabase = SupabaseClientFactory.shared

    static func fetch(id: UUID) async -> WispUser? {
        do {
            return try await supabase
                .from(SupabaseConfig.Tables.users)
                .select()
                .eq("id", value: id.uuidString)
                .single()
                .execute()
                .value
        } catch {
            return nil
        }
    }

    static func threadExists(thread: String) async -> Bool {
        do {
            let result: [WispUser] = try await supabase
                .from(SupabaseConfig.Tables.users)
                .select()
                .eq("thread", value: thread)
                .limit(1)
                .execute()
                .value
            return !result.isEmpty
        } catch {
            return false
        }
    }

    static func create(id: UUID, name: String, thread: String, aura: String) async throws {
        try await supabase
            .from(SupabaseConfig.Tables.users)
            .insert(UserInsert(id: id.uuidString, name: name, thread: thread, aura: aura))
            .execute()
    }

    static func update(id: UUID, name: String, aura: String) async throws {
        try await supabase
            .from(SupabaseConfig.Tables.users)
            .update(["name": name, "aura": aura])
            .eq("id", value: id.uuidString)
            .execute()
    }
}
