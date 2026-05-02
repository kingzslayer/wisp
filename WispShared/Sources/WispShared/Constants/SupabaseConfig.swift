import Foundation

public enum SupabaseConfig {
    public static let projectURL: URL = {
        guard let str = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
              let url = URL(string: str) else {
            fatalError("SUPABASE_URL missing from Info.plist")
        }
        return url
    }()

    public static let anonKey: String = {
        guard let key = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String,
              !key.isEmpty else {
            fatalError("SUPABASE_ANON_KEY missing from Info.plist")
        }
        return key
    }()

    public enum Tables {
        public static let users = "users"
        public static let reaches = "reaches"
        public static let bonds = "bonds"
        public static let vibes = "vibes"
    }
}
