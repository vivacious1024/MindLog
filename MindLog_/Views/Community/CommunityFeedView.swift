import SwiftUI

/// 社区广场视图（Tab 3）
struct CommunityFeedView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景
                themeManager.current.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Header Title
                        VStack(alignment: .leading, spacing: 4) {
                            Text("主题工坊")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundStyle(themeManager.current.text)
                            
                            Text("发现并应用你喜欢的界面风格")
                                .font(.subheadline)
                                .foregroundStyle(themeManager.current.text.opacity(0.6))
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        // Feed List
                        LazyVStack(spacing: 0) {
                            ForEach(ThemeType.allCases) { themeType in
                                ThemePostCard(themeType: themeType)
                                    .padding(.bottom, 16)
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("社区")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

/// 主题帖子卡片视图
struct ThemePostCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let themeType: ThemeType
    
    // 检查是否是当前正在使用的主题
    var isCurrentTheme: Bool {
        themeManager.currentType == themeType
    }
    
    // 获取该卡片对应主题的配色（用于预览）
    var cardTheme: AppTheme {
        themeType.theme
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // 1. 用户信息行 (Mock)
            HStack(spacing: 12) {
                // 头像
                ZStack {
                    Circle()
                        .fill(cardTheme.primary.opacity(0.2))
                    
                    Image(systemName: "paintpalette.fill")
                        .font(.caption)
                        .foregroundStyle(cardTheme.primary)
                }
                .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("MindLog 官方设计")
                        .font(.headline)
                        .foregroundStyle(themeManager.current.text)
                    
                    Text("刚刚发布的更新")
                        .font(.caption)
                        .foregroundStyle(themeManager.current.text.opacity(0.6))
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(themeManager.current.text.opacity(0.5))
                }
            }
            .padding(.horizontal)
            
            // 2. 文字内容
            VStack(alignment: .leading, spacing: 8) {
                Text(themeType.displayName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(themeManager.current.text)
                
                Text(themeType.description)
                    .font(.body)
                    .foregroundStyle(themeManager.current.text.opacity(0.8))
                    .lineLimit(3)
            }
            .padding(.horizontal)
            
            // 3. 视觉预览 (Mood Board)
            VStack(spacing: 12) {
                // 色卡条
                HStack(spacing: 0) {
                    ColorPreviewStrip(color: cardTheme.background, name: "背景")
                    ColorPreviewStrip(color: cardTheme.primary, name: "主色")
                    ColorPreviewStrip(color: cardTheme.secondary, name: "辅助")
                    ColorPreviewStrip(color: cardTheme.accent, name: "点缀")
                }
                .frame(height: 80)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(themeManager.current.text.opacity(0.05), lineWidth: 1)
                )
                
                // 模拟 UI 元素展示
                HStack(spacing: 12) {
                    // 模拟卡片
                    RoundedRectangle(cornerRadius: 16)
                        .fill(cardTheme.surface)
                        .frame(height: 60)
                        .overlay(
                            HStack {
                                Circle().fill(cardTheme.primary).frame(width: 24, height: 24)
                                RoundedRectangle(cornerRadius: 4).fill(cardTheme.text.opacity(0.2)).frame(width: 80, height: 8)
                            }
                        )
                        .shadow(color: cardTheme.primary.opacity(0.1), radius: 5, y: 3)
                    
                    // 模拟按钮
                    Capsule()
                        .fill(cardTheme.primary)
                        .frame(width: 80, height: 40)
                        .overlay(
                            Text("Button")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.white)
                        )
                }
            }
            .padding(.horizontal)
            
            // 4. 操作栏
            HStack {
                // 切换主题按钮
                Button(action: {
                    themeManager.switchTo(themeType)
                }) {
                    HStack {
                        if isCurrentTheme {
                            Image(systemName: "checkmark")
                            Text("已在用")
                        } else {
                            Image(systemName: "sparkles")
                            Text("试用主题")
                        }
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(isCurrentTheme ? themeManager.current.text.opacity(0.5) : .white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        Capsule()
                            .fill(isCurrentTheme ? Color.gray.opacity(0.2) : cardTheme.primary)
                    )
                }
                .disabled(isCurrentTheme)
                
                Spacer()
                
                // 社交按钮 (装饰用)
                HStack(spacing: 20) {
                    SocialButton(icon: "heart", text: "2.4k")
                    SocialButton(icon: "message", text: "86")
                    SocialButton(icon: "square.and.arrow.up", text: "")
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            Divider()
                .padding(.leading)
        }
        .padding(.vertical, 12)
        .background(themeManager.current.surface.opacity(0.5)) // 稍微透出一点背景
    }
}

struct ColorPreviewStrip: View {
    let color: Color
    let name: String
    
    var body: some View {
        ZStack {
            color
            Text(name)
                .font(.caption2)
                .foregroundColor(.black.opacity(0.3))
        }
    }
}

struct SocialButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            if !text.isEmpty {
                Text(text)
                    .font(.caption)
            }
        }
        .foregroundStyle(themeManager.current.text.opacity(0.6))
    }
}

#Preview {
    CommunityFeedView()
        .environmentObject(ThemeManager())
}
