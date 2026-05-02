import WidgetKit
import AppIntents
import WispShared

struct WispTimelineProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> WispTimelineEntry {
        .placeholder
    }

    func snapshot(for configuration: SelectBondIntent, in context: Context) async -> WispTimelineEntry {
        guard let bondEntity = configuration.bond,
              let vibe = WidgetDataReader.loadVibe(for: bondEntity.id) else {
            let firstVibe = WidgetDataReader.loadVibes().first
            return WispTimelineEntry(date: .now, vibe: firstVibe, isPlaceholder: false)
        }
        return WispTimelineEntry(date: .now, vibe: vibe, isPlaceholder: false)
    }

    func timeline(for configuration: SelectBondIntent, in context: Context) async -> Timeline<WispTimelineEntry> {
        let vibe: WidgetVibe?
        if let bondEntity = configuration.bond {
            vibe = WidgetDataReader.loadVibe(for: bondEntity.id)
        } else {
            vibe = WidgetDataReader.loadVibes().first
        }

        let entry = WispTimelineEntry(date: .now, vibe: vibe, isPlaceholder: false)
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: .now)!
        return Timeline(entries: [entry], policy: .after(nextRefresh))
    }
}
