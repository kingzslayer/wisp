import SwiftUI
import WidgetKit

struct WispLockScreenWidget: Widget {
    let kind = "WispLockScreenWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SelectBondIntent.self,
            provider: WispTimelineProvider()
        ) { entry in
            LockScreenWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
                .widgetURL(widgetURL(for: entry))
        }
        .configurationDisplayName("Wisp")
        .description("Feel your bond's vibe")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular])
    }

    private func widgetURL(for entry: WispTimelineEntry) -> URL? {
        guard let bondId = entry.vibe?.bondId else { return nil }
        return URL(string: "wisp://vibe/\(bondId)")
    }
}

private struct LockScreenWidgetEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    let entry: WispTimelineEntry

    var body: some View {
        switch widgetFamily {
        case .accessoryCircular:
            LockScreenCompactView(entry: entry)
        case .accessoryRectangular:
            LockScreenWideView(entry: entry)
        default:
            LockScreenCompactView(entry: entry)
        }
    }
}
