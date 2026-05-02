import SwiftUI
import WispShared

struct SmallWidgetView: View {
    let entry: WispTimelineEntry

    var body: some View {
        if let vibe = entry.vibe {
            vibeContent(vibe)
        } else {
            emptyContent
        }
    }

    private func vibeContent(_ vibe: WidgetVibe) -> some View {
        let aura = Aura(rawValue: vibe.aura) ?? .nebula
        let dominantColor = aura.colors.first ?? .purple

        return VStack(spacing: 6) {
            Spacer()

            MoodIconView(mood: vibe.mood, size: 44, glowColor: dominantColor)

            if let status = vibe.status, !status.isEmpty {
                Text(status)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(1)
            }

            if let updatedAt = vibe.updatedAt {
                Text(updatedAt.timeAgo)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(.white.opacity(0.4))
            }

            Spacer()

            Text(vibe.partnerName)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(14)
    }

    private var emptyContent: some View {
        VStack(spacing: 8) {
            Text("wisp")
                .font(.system(size: 18, weight: .light, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))

            Text("add a bond")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.white.opacity(0.3))
        }
    }
}
