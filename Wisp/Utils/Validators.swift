import Foundation

enum Validators {
    private static let emailDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)

    static func isValidEmail(_ email: String) -> Bool {
        guard !email.isEmpty else { return false }
        let range = NSRange(email.startIndex..., in: email)
        let match = emailDetector?.firstMatch(in: email, options: [], range: range)
        return match?.url?.scheme == "mailto" && match?.range == range
    }
}
