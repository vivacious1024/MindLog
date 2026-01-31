import SwiftUI

struct Step1InputView: View {
    @Bindable var draft: JournalDraft
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 标题
                VStack(alignment: .center, spacing: 8) {
                    Text("记录你的瞬间")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("写下今天的故事，AI 将帮你提取关键元素")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
                
                // 输入框 - 修复版本
                VStack(alignment: .trailing, spacing: 8) {
                    ZStack(alignment: .topLeading) {
                        // 占位符
                        if draft.text.isEmpty {
                            Text("在这里输入你的日记...")
                                .foregroundStyle(.secondary.opacity(0.5))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 8)
                        }
                        
                        // 文本编辑器
                        TextEditor(text: $draft.text)
                            .frame(minHeight: 200)
                            .scrollContentBackground(.hidden)
                            .focused($isTextFieldFocused)
                            .onChange(of: draft.text) {
                                extractKeywords()
                            }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isTextFieldFocused ? Color.pink : Color.gray.opacity(0.3), lineWidth: 2)
                    )
                    
                    Text("\(draft.text.count)/300")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                // 关键词显示
                if !draft.keywords.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("✨ 提取的关键元素")
                            .font(.headline)
                        
                        ForEach(draft.keywords.allKeywords, id: \.category) { item in
                            KeywordCategoryView(
                                icon: item.icon,
                                category: item.category,
                                words: item.words
                            )
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(.rect(cornerRadius: 12))
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .onTapGesture {
            // 点击空白处也能激活输入框
            isTextFieldFocused = true
        }
    }
    
    private func extractKeywords() {
        draft.keywords = KeywordExtractor.extract(from: draft.text)
    }
}

struct KeywordCategoryView: View {
    let icon: String
    let category: String
    let words: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Text(icon)
                Text(category)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            
            FlowLayout(spacing: 8) {
                ForEach(words, id: \.self) { word in
                    KeywordTagView(text: word)
                }
            }
        }
    }
}

struct KeywordTagView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                LinearGradient(
                    colors: [Color.pink.opacity(0.1), Color.pink.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundStyle(.pink)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.pink.opacity(0.3), lineWidth: 1))
    }
}

#Preview {
    @Previewable @State var draft = JournalDraft()
    draft.text = "今天天气真好，阳光明媚。早上去公园散步，看到很多鸟儿在树上歌唱。中午和朋友在咖啡馆喝了大麦茶。"
    draft.keywords = KeywordExtractor.extract(from: draft.text)
    
    return Step1InputView(draft: draft)
}
