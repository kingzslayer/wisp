import Foundation

struct ReachInsert: Encodable {
    let soulId: String
    let kindredId: String

    enum CodingKeys: String, CodingKey {
        case soulId = "soul_id"
        case kindredId = "kindred_id"
    }
}
