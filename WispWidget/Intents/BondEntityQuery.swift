import AppIntents

struct BondEntityQuery: EntityQuery, Sendable {
    func entities(for identifiers: [String]) async throws -> [BondEntity] {
        let vibes = WidgetDataReader.loadVibes()
        return vibes.filter { identifiers.contains($0.bondId) }.map {
            BondEntity(id: $0.bondId, partnerName: $0.partnerName, partnerThread: $0.partnerThread)
        }
    }

    func suggestedEntities() async throws -> [BondEntity] {
        WidgetDataReader.loadVibes().map {
            BondEntity(id: $0.bondId, partnerName: $0.partnerName, partnerThread: $0.partnerThread)
        }
    }
}
