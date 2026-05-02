import Foundation

public struct WidgetVibe: Codable, Sendable {
    public let partnerName: String
    public let partnerThread: String
    public let mood: String?
    public let status: String?
    public let aura: String
    public let bondId: String
    public let updatedAt: Date?

    public init(partnerName: String, partnerThread: String, mood: String?, status: String?, aura: String, bondId: String, updatedAt: Date?) {
        self.partnerName = partnerName
        self.partnerThread = partnerThread
        self.mood = mood
        self.status = status
        self.aura = aura
        self.bondId = bondId
        self.updatedAt = updatedAt
    }
}
