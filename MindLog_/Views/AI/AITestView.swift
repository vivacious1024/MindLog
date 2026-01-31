//
//  AITestView.swift
//  MindLog_
//
//  AI 功能测试演示界面
//

import SwiftUI

/// AI 功能测试界面
struct AITestView: View {
    @State private var inputText = ""
    @State private var isAnalyzing = false
    @State private var analysisResult: AIAnalysisResult?
    @State private var errorMessage: String?

    // 预设示例
    let exampleTexts = [
        "今天和朋友去了一家很棒的意大利餐厅，吃了意面和披萨。我们需要买些食材回家自己做：面粉、番茄酱、橄榄油。下午3点还有个牙医预约在市中心医院。",
        "工作太忙了，感觉压力很大。明天要完成项目报告，周五要开会。记得买咖啡和零食。周末想去爬山放松一下。",
        "今天天气真好，心情特别愉悦！早上跑步5公里，然后去图书馆看了一下午书。打算下周开始学习摄影，需要买一台相机。"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 标题说明
                    VStack(alignment: .leading, spacing: 8) {
                        Text("AI 内容分析演示")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("输入一段文字，AI 会自动提取标签、总结、情感、待办、购物清单和日程。")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // 示例按钮
                    VStack(alignment: .leading, spacing: 12) {
                        Text("快速填入示例：")
                            .font(.headline)

                        ForEach(exampleTexts.indices, id: \.self) { index in
                            Button(action: {
                                inputText = exampleTexts[index]
                            }) {
                                Text("示例 \(index + 1)")
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // 输入区域
                    VStack(alignment: .leading, spacing: 8) {
                        Text("输入内容：")
                            .font(.headline)

                        TextEditor(text: $inputText)
                            .frame(minHeight: 120)
                            .padding(12)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }

                    // 分析按钮
                    Button(action: {
                        Task {
                            await performAnalysis()
                        }
                    }) {
                        HStack {
                            if isAnalyzing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("AI 分析")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(inputText.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(inputText.isEmpty || isAnalyzing)

                    // 错误提示
                    if let error = errorMessage {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }

                    // 分析结果
                    if let result = analysisResult {
                        resultSection(result)
                    }
                }
                .padding(20)
            }
            .navigationTitle("AI 演示")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - 结果展示

    @ViewBuilder
    private func resultSection(_ result: AIAnalysisResult) -> some View {
        VStack(spacing: 20) {
            Divider()

            // 标签
            if let tags = result.tags, !tags.isEmpty {
                sectionCard(title: "标签", icon: "tag.fill", color: .blue) {
                    FlowLayout(spacing: 10) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag)
                                .font(.subheadline)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.15))
                                .foregroundColor(.blue)
                                .cornerRadius(16)
                        }
                    }
                }
            }

            // 总结
            if let summary = result.summary {
                sectionCard(title: "总结", icon: "text.alignleft", color: .green) {
                    Text(summary)
                        .font(.body)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            // 情感评分
            if let score = result.sentimentScore {
                sectionCard(title: "情感分析", icon: "heart.fill", color: .pink) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("情感指数")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(String(format: "%.1f%%", score * 100))
                                .font(.headline)
                                .foregroundColor(sentimentColor(score))
                        }

                        ProgressView(value: score)
                            .tint(sentimentColor(score))

                        Text(sentimentDescription(score))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            // 待办事项
            if let todos = result.todos, !todos.isEmpty {
                sectionCard(title: "待办事项", icon: "checkmark.circle.fill", color: .orange) {
                    VStack(spacing: 10) {
                        ForEach(todos) { todo in
                            HStack(spacing: 12) {
                                Image(systemName: "circle")
                                    .foregroundColor(priorityColor(todo.priority))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(todo.title)
                                        .font(.body)
                                    Text(todo.priority)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }

            // 购物清单
            if let shoppingList = result.shoppingList, !shoppingList.isEmpty {
                sectionCard(title: "购物清单", icon: "cart.fill", color: .green) {
                    VStack(spacing: 10) {
                        ForEach(shoppingList) { item in
                            HStack(spacing: 12) {
                                Image(systemName: "circle")
                                    .foregroundColor(.green)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name)
                                        .font(.body)
                                    if let quantity = item.quantity, let category = item.category {
                                        Text("\(quantity) · \(category)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }

            // 日程安排
            if let schedule = result.schedule, !schedule.isEmpty {
                sectionCard(title: "日程安排", icon: "calendar", color: .purple) {
                    VStack(spacing: 10) {
                        ForEach(schedule) { item in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 8) {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.purple)
                                    Text(item.title)
                                        .font(.body)
                                        .fontWeight(.medium)
                                }
                                if let location = item.location {
                                    HStack(spacing: 6) {
                                        Image(systemName: "mappin.circle.fill")
                                            .font(.caption)
                                        Text(location)
                                            .font(.caption)
                                    }
                                    .foregroundColor(.secondary)
                                }
                                if let notes = item.notes {
                                    Text(notes)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
    }

    // MARK: - 辅助方法

    private func sectionCard<Content: View>(
        title: String,
        icon: String,
        color: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)

                content()
                    .padding(12)
            }
        }
    }

    private func sentimentColor(_ score: Double) -> Color {
        if score >= 0.7 {
            return .green
        } else if score >= 0.4 {
            return .orange
        } else {
            return .red
        }
    }

    private func sentimentDescription(_ score: Double) -> String {
        if score >= 0.8 {
            return "非常积极"
        } else if score >= 0.6 {
            return "积极"
        } else if score >= 0.4 {
            return "中性"
        } else if score >= 0.2 {
            return "消极"
        } else {
            return "非常消极"
        }
    }

    private func priorityColor(_ priority: String) -> Color {
        switch priority {
        case "高":
            return .red
        case "中":
            return .orange
        case "低":
            return .green
        default:
            return .gray
        }
    }

    // MARK: - AI 分析

    private func performAnalysis() async {
        isAnalyzing = true
        errorMessage = nil
        analysisResult = nil

        do {
            let service = KimiService()
            let result = try await service.analyzeContent(text: inputText, base64Images: nil)

            await MainActor.run {
                self.analysisResult = result
                self.isAnalyzing = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isAnalyzing = false
            }
        }
    }
}

#Preview {
    AITestView()
}
