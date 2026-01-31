import SwiftUI

enum LayoutStyle: String, CaseIterable, Identifiable {
    case vintage = "温暖复古"
    case minimal = "清透极简"
    case vibrant = "活力碰撞"
    
    var id: String { rawValue }
    
    var subtitle: String {
        switch self {
        case .vintage: return "C型布局"
        case .minimal: return "左右布局"
        case .vibrant: return "色块布局"
        }
    }
    
    var description: String {
        switch self {
        case .vintage: return "复古纸张质感，手写字体，适合怀旧温馨的日记"
        case .minimal: return "简洁线条，留白呼吸感，适合简单清新的记录"
        case .vibrant: return "活力四射，拼贴风格，适合充满活力的日常"
        }
    }
    
    var colors: [Color] {
        switch self {
        case .vintage: return [Color(hex: "D4A574"), Color(hex: "FFF8E7"), Color(hex: "C4956C")]
        case .minimal: return [Color(hex: "FFE66D"), .white, Color(hex: "FFC93C")]
        case .vibrant: return [Color(hex: "FF9A8B"), Color(hex: "FF6A88"), Color(hex: "FFEAA7")]
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .vintage: return Color(hex: "FFF8E7")
        case .minimal: return Color(hex: "FFFEF0")
        case .vibrant: return Color(hex: "FFE5E5")
        }
    }
    
    var primaryColor: Color {
        switch self {
        case .vintage: return Color(hex: "D4A574")
        case .minimal: return Color(hex: "FFE66D")
        case .vibrant: return Color(hex: "FF9A8B")
        }
    }
}

// Color extension for hex support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
