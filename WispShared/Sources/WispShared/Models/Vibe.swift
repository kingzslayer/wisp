import Foundation

public struct Vibe: Codable, Identifiable, Sendable, Equatable {
    public let id: UUID
    public let bondId: UUID
    public let senderId: UUID
    public let mood: String
    public let status: String?
    public let createdAt: Date
    public let updatedAt: Date

    public var isFresh: Bool {
        updatedAt.timeIntervalSinceNow > -1800
    }

    public init(
        id: UUID = UUID(),
        bondId: UUID,
        senderId: UUID,
        mood: String,
        status: String? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.bondId = bondId
        self.senderId = senderId
        self.mood = mood
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case bondId = "bond_id"
        case senderId = "sender_id"
        case mood, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
