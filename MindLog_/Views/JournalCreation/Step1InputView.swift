import SwiftUI

struct Step1InputView: View {
    @Bindable var draft: JournalDraft
    @State private var testText: String = ""
    
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
                
                // 测试输入框 - 使用 TextField
                VStack(alignment: .leading, spacing: 12) {
                    Text("测试输入框（单行）")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    TextField("试试在这里输入...", text: $testText)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                        .background(Color(.systemBackground))
                        .clipShape(.rect(cornerRadius: 12))
                    
                    if !testText.isEmpty {
                        Text("✅ 输入成功: \(testText)")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }
                
                Divider()
                    .padding(.vertical)
                
                // 主输入框 - TextEditor
                VStack(alignment: .trailing, spacing: 8) {
                    Text("日记输入框（多行）")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextEditor(text: $draft.text)
                        .frame(height: 200)
                        .padding(8)
                        .background(Color(.systemBackground))
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.pink, lineWidth: 2)
                        )
                        .onChange(of: draft.text) {
                            extractKeywords()
                        }
                    
                    Text("\(draft.text.count)/300")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                // 快捷输入按钮
                VStack(alignment: .leading, spacing: 12) {
                    Text("快捷测试")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 12) {
                        Button("填充示例文本") {
                            draft.text = "今天天气真好，阳光明媚。早上去公园散步，看到很多鸟儿在树上歌唱。中午和朋友在咖啡馆喝了大麦茶，聊了很多关于未来的计划。下午读了一本诗集，感觉很放松。晚上看到美丽的晚霞，吃了一碗热腾腾的面条。这样平凡而美好的一天，值得被记录下来。"
                            extractKeywords()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.pink)
                        
                        Button("清空") {
                            draft.text = ""
                            testText = ""
                            draft.keywords = Keywords()
                        }
                        .buttonStyle(.bordered)
                    }
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
    return Step1InputView(draft: draft)
}
