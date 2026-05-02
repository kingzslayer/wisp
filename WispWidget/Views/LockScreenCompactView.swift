import SwiftUI
import WidgetKit

struct LockScreenCompactView: View {
    let entry: WispTimelineEntry

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()

            if let mood = entry.vibe?.mood {
                Image(systemName: mood)
                    .font(.system(size: 22, weight: .bold))
            } else {
                Image(systemName: "sparkle")
                    .font(.system(size: 20, weight: .medium))
            }
        }
    }
}
