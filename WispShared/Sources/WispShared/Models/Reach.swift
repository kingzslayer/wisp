import Foundation

public struct Reach: Codable, Identifiable, Sendable, Equatable {
    public let id: UUID
    public let soulId: UUID
    public let kindredId: UUID
    public let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case soulId = "soul_id"
        case kindredId = "kindred_id"
        case createdAt = "created_at"
    }
}
