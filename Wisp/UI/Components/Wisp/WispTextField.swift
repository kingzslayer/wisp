import SwiftUI

struct WispTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var alignment: TextAlignment = .leading
    var isDisabled: Bool = false
    var fontDesign: Font.Design = .default

    private var fontForDesign: Font {
        switch fontDesign {
        case .monospaced: WispTheme.Typography.mono
        case .serif: .system(size: 16, weight: .light, design: .serif)
        default: WispTheme.Typography.body
        }
    }

    var body: some View {
        TextField(
            "",
            text: $text,
            prompt: Text(placeholder)
                .foregroundStyle(WispTheme.Colors.placeholderText)
        )
        .font(fontForDesign)
        .foregroundStyle(WispTheme.Colors.primaryText)
        .keyboardType(keyboardType)
        .multilineTextAlignment(alignment)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .disabled(isDisabled)
        .padding(WispTheme.Spacing.lg)
        .background(WispTheme.Colors.glassBg)
        .clipShape(RoundedRectangle(cornerRadius: WispTheme.Radius.lg))
        .opacity(isDisabled ? WispTheme.Colors.disabledOpacity : 1)
    }
}
