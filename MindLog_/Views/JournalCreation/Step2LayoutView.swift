import SwiftUI

struct Step2LayoutView: View {
    @Bindable var draft: JournalDraft
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 24) {
                // 标题
                VStack(spacing: 8) {
                    Text("选择你的手帐风格")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("三种精心设计的布局，总有一款适合你")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top)
                
                // 风格卡片
                VStack(spacing: 16) {
                    ForEach(LayoutStyle.allCases) { layout in
                        LayoutCardView(
                            layout: layout,
                            isSelected: draft.selectedLayout == layout
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3)) {
                                draft.selectedLayout = layout
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct LayoutCardView: View {
    let layout: LayoutStyle
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 预览区域
            ZStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [layout.backgroundColor, layout.backgroundColor.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                VStack(spacing: 4) {
                    Text(layout.rawValue)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(layout.primaryColor)
                    
                    Text(layout.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 150)
            
            // 信息区域
            VStack(alignment: .leading, spacing: 12) {
                Text(layout.rawValue)
                    .font(.headline)
                
                Text(layout.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                // 色板
                HStack(spacing: 8) {
                    ForEach(layout.colors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .clipShape(.rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.pink : Color.clear, lineWidth: 3)
        )
        .shadow(color: isSelected ? Color.pink.opacity(0.3) : Color.black.opacity(0.05), radius: 8)
        .scaleEffect(isSelected ? 1.02 : 1.0)
    }
}

#Preview {
    @Previewable @State var draft = JournalDraft()
    draft.selectedLayout = .vintage
    
    return Step2LayoutView(draft: draft)
}
