import SwiftUI
import WispShared

struct MoodIconView: View {
    let mood: String?
    let size: CGFloat
    let glowColor: Color

    var body: some View {
        Image(systemName: mood ?? "circle.dashed")
            .font(.system(size: size, weight: .medium))
            .foregroundStyle(.white)
            .shadow(color: glowColor.opacity(0.6), radius: 12)
            .shadow(color: glowColor.opacity(0.3), radius: 24)
    }
}
