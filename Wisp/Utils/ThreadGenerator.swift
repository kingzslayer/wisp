import Foundation
import WispShared

enum ThreadGenerator {
    private static let maxRetries = 10

    static func generate() -> String {
        let adjective = ThreadWordPool.adjectives.randomElement()!
        let noun = ThreadWordPool.nouns.randomElement()!
        return "\(adjective) \(noun)"
    }

    static func generateUnique() async -> String {
        for _ in 0..<maxRetries {
            let thread = generate()
            let exists = await UserService.threadExists(thread: thread)
            if !exists { return thread }
        }
        return generate()
    }
}
