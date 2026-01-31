import SwiftUI

// MARK: - Color Extension for Hex Support
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
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Theme Definitions

enum ThemeType: String, CaseIterable, Identifiable {
    case matcha
    case taro
    case peach
    case ocean
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .matcha: return "抹茶拿铁"
        case .taro: return "芋泥波波"
        case .peach: return "蜜桃乌龙"
        case .ocean: return "海盐微风"
        }
    }
    
    var description: String {
        switch self {
        case .matcha: return "自然的呼吸感，治愈的抹茶与燕麦色调。"
        case .taro: return "梦幻与静谧，柔软的香芋与云朵色调。"
        case .peach: return "温暖与活力，午后阳光般的蜜桃与乌龙色调。"
        case .ocean: return "清新与专注，如海风吹拂般的透明与清澈。"
        }
    }
    
    var theme: AppTheme {
        switch self {
        case .matcha: return .matcha
        case .taro: return .taro
        case .peach: return .peach
        case .ocean: return .ocean
        }
    }
}

struct AppTheme {
    let background: Color
    let primary: Color
    let secondary: Color
    let accent: Color
    let text: Color
    let surface: Color
    let cornerRadius: CGFloat
    
    // MARK: - Preset Themes
    
    /// 抹茶拿铁 (Matcha Latte)
    static let matcha = AppTheme(
        background: Color(hex: "FDFCF8"),
        primary: Color(hex: "A8C2A4"),
        secondary: Color(hex: "F2E6D8"),
        accent: Color(hex: "E8A09A"),
        text: Color(hex: "5C5C5C"),
        surface: Color.white.opacity(0.9),
        cornerRadius: 24
    )
    
    /// 芋泥波波 (Taro Cloud)
    static let taro = AppTheme(
        background: Color(hex: "F6F7FB"), // 极淡冷灰蓝
        primary: Color(hex: "B8B8E0"),   // 淡紫罗兰
        secondary: Color(hex: "D6E4FF"), // 婴儿蓝
        accent: Color(hex: "FFD180"),    // 奶黄 (月光色)
        text: Color(hex: "4A4A68"),      // 灰紫
        surface: Color.white.opacity(0.75), // 玻璃磨砂感更强
        cornerRadius: 24
    )
    
    /// 蜜桃乌龙 (Peach Oolong)
    static let peach = AppTheme(
        background: Color(hex: "FFFAF5"), // 淡粉橙白
        primary: Color(hex: "FFCCBC"),    // 蜜桃粉橙
        secondary: Color(hex: "FFE0B2"),  // 杏色
        accent: Color(hex: "81C784"),     // 嫩草绿
        text: Color(hex: "6D4C41"),       // 暖咖色
        surface: Color.white.opacity(0.85),
        cornerRadius: 24
    )
    
    /// 海盐微风 (Ocean Breeze)
    static let ocean = AppTheme(
        background: Color(hex: "F0FBFD"), // 淡青
        primary: Color(hex: "8CD1CA"),    // 海盐绿
        secondary: Color(hex: "D3EEEC"),  // 浅沫
        accent: Color(hex: "FFAB91"),     // 珊瑚粉
        text: Color(hex: "455A64"),       // 蓝灰
        surface: Color.white.opacity(0.9),
        cornerRadius: 24
    )
}

// MARK: - Theme Manager

class ThemeManager: ObservableObject {
    @AppStorage("selected_theme_v1") var selectedThemeID: String = ThemeType.matcha.rawValue
    
    var current: AppTheme {
        ThemeType(rawValue: selectedThemeID)?.theme ?? .matcha
    }
    
    var currentType: ThemeType {
        ThemeType(rawValue: selectedThemeID) ?? .matcha
    }
    
    func switchTo(_ type: ThemeType) {
        withAnimation(.easeInOut(duration: 0.5)) {
            selectedThemeID = type.rawValue
        }
    }
}

// MARK: - View Modifiers (Dynamic)

struct ThemeCardModifier: ViewModifier {
    @ObservedObject var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .background(themeManager.current.surface)
            .cornerRadius(themeManager.current.cornerRadius)
            .shadow(
                color: themeManager.current.primary.opacity(0.1),
                radius: 10,
                x: 0,
                y: 5
            )
            // 如果是芋泥主题，添加一点背景模糊以增强玻璃感
            .background(
                themeManager.currentType == .taro ? .ultraThinMaterial : .regular,
                in: RoundedRectangle(cornerRadius: themeManager.current.cornerRadius)
            )
    }
}

struct ThemeButtonStyle: ButtonStyle {
    @ObservedObject var themeManager: ThemeManager
    var isAccent: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        let theme = themeManager.current
        let color = isAccent ? theme.accent : theme.primary
        
        configuration.label
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(
                Capsule()
                    .fill(color)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .shadow(
                color: color.opacity(0.4),
                radius: configuration.isPressed ? 4 : 8,
                x: 0,
                y: configuration.isPressed ? 2 : 4
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
