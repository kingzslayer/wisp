import SwiftUI
import WidgetKit

@main
struct WispWidgetBundle: WidgetBundle {
    var body: some Widget {
        WispSmallWidget()
        WispLockScreenWidget()
    }
}
