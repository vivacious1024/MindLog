//
//  GlassCard.swift
//  MindLog_
//
//  Created by Antigravity on 2026/1/31.
//

import SwiftUI

/// 可复用的 Liquid Glass 卡片组件
/// 遵循 SwiftUI Expert Skill 最佳实践
struct GlassCard<Content: View>: View {
    // MARK: - Properties
    
    /// 使用 @ViewBuilder let content 而非闭包属性
    @ViewBuilder let content: Content
    
    private let style: GlassStyle
    private let cornerRadius: CGFloat
    
    // MARK: - Initialization
    
    init(
        style: GlassStyle = .regular,
        cornerRadius: CGFloat = AppConstants.CornerRadius.medium,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    // MARK: - Body
    
    var body: some View {
        // NOTE: iOS 26 glassEffect API is not yet available
 		// When iOS 26 is released, add #available(iOS 26, *) condition here
        content
            .background(
                materialBackground
                    .clipShape(.rect(cornerRadius: cornerRadius))
            )
    }
    
    // MARK: - Material Background (Current Implementation)
    
    private var materialBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(style.materialStyle)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
    }
}

// MARK: - Glass Style

enum GlassStyle {
    case regular
    case prominent
    case subtle
    
    var materialStyle: Material {
        switch self {
        case .regular:
            return .ultraThinMaterial
        case .prominent:
            return .regularMaterial
        case .subtle:
            return .thin
        }
    }
}

// MARK: - View Extension

extension View {
    /// 为视图应用 Glass Card 样式
    func glassCardStyle(
        _ style: GlassStyle = .regular,
        cornerRadius: CGFloat = AppConstants.CornerRadius.medium
    ) -> some View {
        GlassCard(style: style, cornerRadius: cornerRadius) {
            self
        }
    }
}

// MARK: - Previews

#Preview("Regular Card") {
    VStack(spacing: 24) {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Today's Journal")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text("This is a beautiful day with the new Liquid Glass design system.")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        
        GlassCard(style: .prominent, cornerRadius: AppConstants.CornerRadius.large) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.title)
                Text("Prominent Style")
                    .font(.title3)
                    .bold()
            }
            .padding()
        }
        
        GlassCard(style: .subtle, cornerRadius: AppConstants.CornerRadius.small) {
            Text("Subtle Glass Effect")
                .padding()
        }
    }
    .padding()
    .background(
        LinearGradient(
            colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}
