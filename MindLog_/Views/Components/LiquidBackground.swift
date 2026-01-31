//
//  LiquidBackground.swift
//  MindLog_
//
//  Created by Antigravity on 2026/1/31.
//

import SwiftUI

/// 动态渐变背景组件
/// 遵循 SwiftUI Expert Skill 性能最佳实践
struct LiquidBackground: View {
    // MARK: - Properties
    
    @State private var animationPhase: CGFloat = 0
    
    private let colorScheme: LiquidColorScheme
    private let animationSpeed: Double
    
    // MARK: - Initialization
    
    init(
        colorScheme: LiquidColorScheme = .default,
        animationSpeed: Double = 8.0
    ) {
        self.colorScheme = colorScheme
        self.animationSpeed = animationSpeed
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // 基础渐变层
            baseGradient
            
            // 动态渐变层
            animatedGradient
                .opacity(0.6)
                .blur(radius: 60)
        }
        .ignoresSafeArea()
        .onAppear {
            // 使用 .animation() modifier 而非 withAnimation（性能优化）
            animationPhase = 1.0
        }
        .animation(
            .easeInOut(duration: animationSpeed).repeatForever(autoreverses: true),
            value: animationPhase
        )
    }
    
    // MARK: - Gradient Components
    
    /// 基础静态渐变
    private var baseGradient: some View {
        LinearGradient(
            colors: colorScheme.baseColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// 动态渐变层
    private var animatedGradient: some View {
        EllipticalGradient(
            colors: colorScheme.animatedColors,
            center: .center,
            startRadiusFraction: 0,
            endRadiusFraction: animationPhase
        )
    }
}

// MARK: - Color Scheme

/// Liquid Background 颜色方案
/// 避免纯色，使用 HSL 调色板
struct LiquidColorScheme {
    let baseColors: [Color]
    let animatedColors: [Color]
    
    static let `default` = LiquidColorScheme(
        baseColors: [
            Color(hue: 0.6, saturation: 0.4, brightness: 0.95),  // 柔和蓝
            Color(hue: 0.75, saturation: 0.35, brightness: 0.92)  // 淡紫
        ],
        animatedColors: [
            Color(hue: 0.65, saturation: 0.3, brightness: 0.9),
            Color(hue: 0.55, saturation: 0.25, brightness: 0.93),
            Color(hue: 0.7, saturation: 0.35, brightness: 0.88)
        ]
    )
    
    static let warm = LiquidColorScheme(
        baseColors: [
            Color(hue: 0.05, saturation: 0.5, brightness: 0.95),  // 柔和橙
            Color(hue: 0.15, saturation: 0.4, brightness: 0.92)   // 金黄
        ],
        animatedColors: [
            Color(hue: 0.1, saturation: 0.35, brightness: 0.9),
            Color(hue: 0.0, saturation: 0.3, brightness: 0.93),
            Color(hue: 0.08, saturation: 0.4, brightness: 0.88)
        ]
    )
    
    static let cool = LiquidColorScheme(
        baseColors: [
            Color(hue: 0.5, saturation: 0.4, brightness: 0.95),  // 青色
            Color(hue: 0.6, saturation: 0.35, brightness: 0.92)  // 天蓝
        ],
        animatedColors: [
            Color(hue: 0.55, saturation: 0.3, brightness: 0.9),
            Color(hue: 0.48, saturation: 0.25, brightness: 0.93),
            Color(hue: 0.58, saturation: 0.35, brightness: 0.88)
        ]
    )
    
    static let sunset = LiquidColorScheme(
        baseColors: [
            Color(hue: 0.95, saturation: 0.5, brightness: 0.9),  // 粉红
            Color(hue: 0.05, saturation: 0.6, brightness: 0.85)  // 橙红
        ],
        animatedColors: [
            Color(hue: 0.0, saturation: 0.4, brightness: 0.88),
            Color(hue: 0.08, saturation: 0.5, brightness: 0.82),
            Color(hue: 0.92, saturation: 0.45, brightness: 0.86)
        ]
    )
}

// MARK: - Dark Mode Support

extension LiquidColorScheme {
    /// Dark Mode 自适应方案
    static func adaptive(for colorScheme: ColorScheme) -> LiquidColorScheme {
        if colorScheme == .dark {
            return LiquidColorScheme(
                baseColors: [
                    Color(hue: 0.6, saturation: 0.3, brightness: 0.2),   // 深蓝
                    Color(hue: 0.75, saturation: 0.25, brightness: 0.18)  // 深紫
                ],
                animatedColors: [
                    Color(hue: 0.65, saturation: 0.25, brightness: 0.22),
                    Color(hue: 0.55, saturation: 0.2, brightness: 0.24),
                    Color(hue: 0.7, saturation: 0.28, brightness: 0.19)
                ]
            )
        } else {
            return .default
        }
    }
}

// MARK: - View Extension

extension View {
    /// 为视图添加 Liquid 背景
    func liquidBackground(
        _ scheme: LiquidColorScheme = .default,
        animationSpeed: Double = 8.0
    ) -> some View {
        background(
            LiquidBackground(colorScheme: scheme, animationSpeed: animationSpeed)
        )
    }
}

// MARK: - Previews

#Preview("Default Scheme") {
    VStack {
        Text("Liquid Background")
            .font(.largeTitle)
            .bold()
            .foregroundStyle(.primary)
    }
    .liquidBackground()
}

#Preview("Multiple Schemes") {
    ScrollView {
        VStack(spacing: 0) {
            schemePreview(name: "Default", scheme: .default)
            schemePreview(name: "Warm", scheme: .warm)
            schemePreview(name: "Cool", scheme: .cool)
            schemePreview(name: "Sunset", scheme: .sunset)
        }
    }
    .ignoresSafeArea()
}

private func schemePreview(name: String, scheme: LiquidColorScheme) -> some View {
    ZStack {
        LiquidBackground(colorScheme: scheme, animationSpeed: 5)
        
        Text(name)
            .font(.title)
            .bold()
            .foregroundStyle(.white)
            .shadow(radius: 10)
    }
    .frame(height: 200)
}
