import Foundation
import Supabase
import WispShared

enum AuthService {
    private static let supabase = SupabaseClientFactory.shared

    static func session() async throws -> Session {
        try await supabase.auth.session
    }

    static func sendOTP(email: String) async throws {
        try await supabase.auth.signInWithOTP(email: email)
    }

    static func verifyOTP(email: String, token: String) async throws -> Session {
        let response = try await supabase.auth.verifyOTP(
            email: email,
            token: token,
            type: .email
        )
        guard let session = response.session else {
            throw AuthError.sessionMissing
        }
        return session
    }

    static func signOut() async throws {
        try await supabase.auth.signOut()
    }
}
