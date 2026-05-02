import WidgetKit
import WispShared

struct WispTimelineEntry: TimelineEntry {
    let date: Date
    let vibe: WidgetVibe?
    let isPlaceholder: Bool

    static var placeholder: WispTimelineEntry {
        let vibes = WidgetDataReader.loadVibes()
        return WispTimelineEntry(
            date: .now,
            vibe: vibes.first,
            isPlaceholder: true
        )
    }

    static var empty: WispTimelineEntry {
        WispTimelineEntry(date: .now, vibe: nil, isPlaceholder: false)
    }
}
