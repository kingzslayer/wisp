import SwiftUI
import WispShared

struct LockScreenWideView: View {
    let entry: WispTimelineEntry

    var body: some View {
        if let vibe = entry.vibe {
            HStack(spacing: 10) {
                Image(systemName: vibe.mood ?? "circle.dashed")
                    .font(.system(size: 28, weight: .medium))

                VStack(alignment: .leading, spacing: 2) {
                    Text(vibe.partnerName)
                        .font(.system(size: 14, weight: .semibold))
                        .lineLimit(1)

                    if let status = vibe.status, !status.isEmpty {
                        Text(status)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                .layoutPriority(1)
            }
        } else {
            HStack(spacing: 10) {
                Image(systemName: "sparkle")
                    .font(.system(size: 24, weight: .medium))

                Text("wisp")
                    .font(.system(size: 14, weight: .light, design: .rounded))
            }
            .foregroundStyle(.secondary)
        }
    }
}
