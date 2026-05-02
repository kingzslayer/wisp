import Foundation

struct VibeInsert: Encodable {
    let bondId: String
    let senderId: String
    let mood: String
    let status: String?

    enum CodingKeys: String, CodingKey {
        case bondId = "bond_id"
        case senderId = "sender_id"
        case mood, status
    }
}
