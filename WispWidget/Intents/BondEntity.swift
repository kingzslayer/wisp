import AppIntents

struct BondEntity: AppEntity, Sendable {
    static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Bond")
    static let defaultQuery = BondEntityQuery()

    var id: String
    var partnerName: String
    var partnerThread: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(partnerName)", subtitle: "\(partnerThread)")
    }
}
