//
//  FloatingActionButton.swift
//  MindLog_
//
//  Created by Antigravity on 2026/1/31.
//

import SwiftUI

/// 悬浮操作按钮（FAB）
/// 遵循 SwiftUI Skill: 使用 Button 而非 onTapGesture
struct FloatingActionButton: View {
    // MARK: - Properties
    
    private let icon: String
    private let action: () -> Void
    private let size: FABSize
    private let style: FABStyle
    
    @State private var isPressed = false
    
    // MARK: - Initialization
    
    init(
        icon: String,
        size: FABSize = .regular,
        style: FABStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.style = style
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(size.iconFont)
                .foregroundStyle(style.foregroundColor)
                .frame(width: size.dimension, height: size.dimension)
                .background(buttonBackground)
                .clipShape(Circle())
                .shadow(
                    color: style.shadowColor,
                    radius: isPressed ? 8 : 12,
                    x: 0,
                    y: isPressed ? 2 : 4
                )
        }
        .buttonStyle(FABButtonStyle(isPressed: $isPressed))
    }
    
    // MARK: - Background
    
    @ViewBuilder
    private var buttonBackground: some View {
        // NOTE: iOS 26 glassEffect not yet available
        Circle()
            .fill(style.backgroundColor)
    }
}

// MARK: - FAB Size

enum FABSize {
    case small
    case regular
    case large
    
    var dimension: CGFloat {
        switch self {
        case .small: return 48
        case .regular: return 56
        case .large: return 64
        }
    }
    
    var iconFont: Font {
        switch self {
        case .small: return .body
        case .regular: return .title3
        case .large: return .title2
        }
    }
}

// MARK: - FAB Style

enum FABStyle {
    case primary
    case secondary
    case accent
    
    var foregroundColor: Color {
        switch self {
        case .primary: return .white
        case .secondary: return .primary
        case .accent: return .white
        }
    }
    
    var backgroundColor: Material {
        switch self {
        case .primary: return .regularMaterial
        case .secondary: return .ultraThinMaterial
        case .accent: return .thickMaterial
        }
    }
    
    var shadowColor: Color {
        switch self {
        case .primary: return .blue.opacity(0.3)
        case .secondary: return .black.opacity(0.2)
        case .accent: return .purple.opacity(0.3)
        }
    }
}

// MARK: - Custom Button Style

struct FABButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .onChange(of: configuration.isPressed) { oldValue, newValue in
                isPressed = newValue
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Previews

#Preview("FAB Sizes") {
    ZStack {
        LiquidBackground()
        
        VStack(spacing: 32) {
            FloatingActionButton(icon: "plus", size: .small) {
                print("Small FAB tapped")
            }
            
            FloatingActionButton(icon: "plus", size: .regular) {
                print("Regular FAB tapped")
            }
            
            FloatingActionButton(icon: "plus", size: .large) {
                print("Large FAB tapped")
            }
        }
    }
}

#Preview("FAB Styles") {
    ZStack {
        LiquidBackground(colorScheme: .cool)
        
        HStack(spacing: 24) {
            FloatingActionButton(icon: "star.fill", style: .primary) {}
            FloatingActionButton(icon: "heart.fill", style: .secondary) {}
            FloatingActionButton(icon: "sparkles", style: .accent) {}
        }
    }
}
