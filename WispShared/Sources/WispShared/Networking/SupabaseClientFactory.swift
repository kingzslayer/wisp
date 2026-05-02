import Foundation
import Supabase

public enum SupabaseClientFactory {
    public static let shared: SupabaseClient = {
        SupabaseClient(
            supabaseURL: SupabaseConfig.projectURL,
            supabaseKey: SupabaseConfig.anonKey
        )
    }()
}
