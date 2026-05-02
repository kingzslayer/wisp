import SwiftUI

public enum Aura: String, Codable, CaseIterable, Sendable {
    case aurora
    case sunset
    case midnight
    case forest
    case ocean
    case lavender
    case ember
    case arctic
    case dusk
    case citrus
    case berry
    case storm
    case golden
    case blossom
    case nebula

    public var colors: [Color] {
        switch self {
        case .aurora:   [Color(hex: "00C9A7"), Color(hex: "845EC2"), Color(hex: "2C73D2")]
        case .sunset:   [Color(hex: "FF6F61"), Color(hex: "FF9671"), Color(hex: "845EC2")]
        case .midnight: [Color(hex: "0A1628"), Color(hex: "1B2838"), Color(hex: "2C3E6B")]
        case .forest:   [Color(hex: "1B4332"), Color(hex: "2D6A4F"), Color(hex: "40916C")]
        case .ocean:    [Color(hex: "0077B6"), Color(hex: "00B4D8"), Color(hex: "48CAE4")]
        case .lavender: [Color(hex: "845EC2"), Color(hex: "D65DB1"), Color(hex: "FBEAFF")]
        case .ember:    [Color(hex: "D00000"), Color(hex: "E85D04"), Color(hex: "FAA307")]
        case .arctic:   [Color(hex: "CAF0F8"), Color(hex: "ADE8F4"), Color(hex: "E8F7FF")]
        case .dusk:     [Color(hex: "22223B"), Color(hex: "4A4E69"), Color(hex: "9A8C98")]
        case .citrus:   [Color(hex: "F9C74F"), Color(hex: "90BE6D"), Color(hex: "F8961E")]
        case .berry:    [Color(hex: "9B2226"), Color(hex: "AE2012"), Color(hex: "CA6702")]
        case .storm:    [Color(hex: "495057"), Color(hex: "6C757D"), Color(hex: "343A40")]
        case .golden:   [Color(hex: "FFD700"), Color(hex: "FFA500"), Color(hex: "FFFDE7")]
        case .blossom:  [Color(hex: "FFB3C6"), Color(hex: "FF8FAB"), Color(hex: "FFDDE1")]
        case .nebula:   [Color(hex: "3A0CA3"), Color(hex: "4361EE"), Color(hex: "4CC9F0")]
        }
    }

    public var gradient: LinearGradient {
        LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

}
