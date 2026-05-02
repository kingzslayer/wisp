import SwiftUI
import WidgetKit
import WispShared

struct WispSmallWidget: Widget {
    let kind = "WispSmallWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SelectBondIntent.self,
            provider: WispTimelineProvider()
        ) { entry in
            SmallWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    WidgetAuraBackground(auraName: entry.vibe?.aura ?? Aura.midnight.rawValue)
                }
                .widgetURL(widgetURL(for: entry))
        }
        .configurationDisplayName("Wisp")
        .description("Feel your bond's vibe")
        .supportedFamilies([.systemSmall])
    }

    private func widgetURL(for entry: WispTimelineEntry) -> URL? {
        guard let bondId = entry.vibe?.bondId else { return nil }
        return URL(string: "wisp://vibe/\(bondId)")
    }
}
