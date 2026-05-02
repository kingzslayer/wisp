import AppIntents
import WidgetKit

struct SelectBondIntent: WidgetConfigurationIntent, Sendable {
    static let title: LocalizedStringResource = "Select Bond"
    static let description: IntentDescription = "Choose which bond to display"

    @Parameter(title: "Bond")
    var bond: BondEntity?
}
