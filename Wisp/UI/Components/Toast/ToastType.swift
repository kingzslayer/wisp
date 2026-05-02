import SwiftUI

enum ToastType: Equatable {
    case success(String)
    case error(String)

    var message: String {
        switch self {
        case .success(let msg), .error(let msg): return msg
        }
    }

    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }

    var iconColor: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        }
    }
}
