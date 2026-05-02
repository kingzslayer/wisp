import SwiftUI

enum WispTheme {
    enum Colors {
        static let primaryText = Color.white
        static let secondaryText = Color.white.opacity(0.7)
        static let tertiaryText = Color.white.opacity(0.5)
        static let placeholderText = Color.white.opacity(0.3)
        static let background = Color.black
        static let glassBg = Color.white.opacity(0.1)
        static let glassBorder = Color.white.opacity(0.2)
        static let disabledOpacity = 0.6
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 40
        static let safeBottom: CGFloat = 60
        static let toastTop: CGFloat = 50
    }

    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 14
        static let xl: CGFloat = 16
        static let xxl: CGFloat = 24
    }

    enum Typography {
        static let hero = Font.system(size: 48, weight: .thin, design: .rounded)
        static let title = Font.system(size: 24, weight: .light)
        static let body = Font.system(size: 16, weight: .light)
        static let button = Font.system(size: 18, weight: .medium)
        static let caption = Font.system(size: 14, weight: .light)
        static let mono = Font.system(size: 24, weight: .medium, design: .monospaced)
        static let small = Font.system(size: 13, weight: .light)
        static let toast = Font.system(size: 14, weight: .medium)
    }

    enum Animation {
        static let gradientCycle: Double = 5.0
        static let gradientShift: Double = 8.0
        static let colorTransition: Double = 3.0
        static let stateTransition: Double = 0.4
        static let toastDuration: Double = 4.0
        static let resendCooldown: Int = 60
        static let toastSpring = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.7)
    }
}
