import Foundation

public struct WispUser: Codable, Identifiable, Sendable, Equatable {
    public let id: UUID
    public var name: String
    public var thread: String
    public var aura: String
    public let createdAt: Date
    public var updatedAt: Date

    public var auraType: Aura? { Aura(rawValue: aura) }

    public init(
        id: UUID,
        name: String,
        thread: String,
        aura: String,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.thread = thread
        self.aura = aura
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case thread
        case aura
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
