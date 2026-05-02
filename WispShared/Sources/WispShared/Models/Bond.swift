import Foundation

public struct Bond: Codable, Identifiable, Sendable, Equatable {
    public let id: UUID
    public let souls: [UUID]
    public let bondedAt: Date

    enum CodingKeys: String, CodingKey {
        case id, souls
        case bondedAt = "bonded_at"
    }

    public init(id: UUID, souls: [UUID], bondedAt: Date) {
        self.id = id
        self.souls = souls
        self.bondedAt = bondedAt
    }

    public func partnerId(for userId: UUID) -> UUID? {
        souls.first { $0 != userId }
    }
}
