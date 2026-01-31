import UIKit
import SwiftUI

struct JournalRenderer {
    static func render(text: String, keywords: Keywords, layout: LayoutStyle) -> UIImage {
        let size = CGSize(width: 750, height: 1000)
        let renderer = ImageRenderer(content: JournalCanvasView(text: text, keywords: keywords, layout: layout))
        renderer.scale = 3.0
        
        if let image = renderer.uiImage {
            return image
        }
        
        // Fallback: create a simple image
        return createFallbackImage(size: size)
    }
    
    private static func createFallbackImage(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 3.0)
        defer { UIGraphicsEndImageContext() }
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.systemBackground.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}

struct JournalCanvasView: View {
    let text: String
    let keywords: Keywords
    let layout: LayoutStyle
    
    var body: some View {
        ZStack {
            // 背景
            layout.backgroundColor
            
            // 装饰元素
            decorativeElements
            
            // 内容
            VStack(alignment: .leading, spacing: 20) {
                // 日期
                Text(formattedDate)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)
                
                // 日记内容
                Text(text)
                    .font(.system(size: 18))
                    .lineSpacing(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                // 图标
                HStack(spacing: 16) {
                    ForEach(autoIcons.prefix(3), id: \.self) { icon in
                        Text(icon)
                            .font(.system(size: 32))
                    }
                }
            }
            .padding(60)
        }
        .frame(width: 750, height: 1000)
    }
    
    @ViewBuilder
    private var decorativeElements: some View {
        switch layout {
        case .vintage:
            VStack {
                HStack {
                    vintageCorner
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    vintageCorner
                        .rotationEffect(.degrees(180))
                }
            }
            .padding(50)
            
        case .minimal:
            VStack {
                Spacer()
                Rectangle()
                    .fill(layout.primaryColor.opacity(0.3))
                    .frame(height: 2)
                    .padding(.horizontal, 50)
                Spacer()
            }
            
        case .vibrant:
            GeometryReader { geometry in
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(layout.colors[index].opacity(0.1))
                        .frame(width: 200, height: 200)
                        .offset(
                            x: CGFloat(index) * 250,
                            y: CGFloat(index) * 300
                        )
                }
            }
        }
    }
    
    private var vintageCorner: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 100))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 100, y: 0))
        }
        .stroke(layout.primaryColor, lineWidth: 3)
        .frame(width: 100, height: 100)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: Date())
    }
    
    private var autoIcons: [String] {
        var icons: [String] = []
        
        if keywords.food.contains(where: { ["茶", "大麦茶", "咖啡"].contains($0) }) {
            icons.append("☕")
        }
        if keywords.nature.contains(where: { ["鸟", "麻雀"].contains($0) }) {
            icons.append("🐦")
        }
        if keywords.weather.contains(where: { ["阳光", "晴天", "晴朗"].contains($0) }) {
            icons.append("☀️")
        }
        if keywords.objects.contains(where: { ["书", "诗集", "小说"].contains($0) }) {
            icons.append("📖")
        }
        if keywords.nature.contains(where: { ["花", "植物"].contains($0) }) {
            icons.append("🌸")
        }
        
        return icons
    }
}
