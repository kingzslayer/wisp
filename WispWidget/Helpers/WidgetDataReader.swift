import Foundation
import WispShared

enum WidgetDataReader {
    static func loadVibes() -> [WidgetVibe] {
        guard let data = UserDefaults(suiteName: SharedDefaults.suiteName)?.data(forKey: SharedDefaults.vibesKey),
              let vibes = try? JSONDecoder().decode([WidgetVibe].self, from: data) else {
            return []
        }
        return vibes
    }

    static func loadVibe(for bondId: String) -> WidgetVibe? {
        loadVibes().first { $0.bondId == bondId }
    }
}
