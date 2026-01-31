//
//  AIAnalysisResultView.swift
//  MindLog_
//
//  Created by AI Assistant on 2026/1/31.
//

import SwiftUI

/// AI 分析结果展示视图
struct AIAnalysisResultView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isApplying = false

    let result: AIAnalysisResult
    let onApply: (AIAnalysisResult) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 标签
                    if let tags = result.tags, !tags.isEmpty {
                        section(title: "标签") {
                            FlowLayout(spacing: 12) {
                                ForEach(tags, id: \.self) { tag in
                                    TagChip(text: tag)
                                }
                            }
                        }
                    }

                    // 总结
                    if let summary = result.summary {
                        section(title: "总结") {
                            Text(summary)
                                .font(.body)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }

                    // 情感评分
                    if let score = result.sentimentScore {
                        section(title: "情感分析") {
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
                        section(title: "待办事项") {
                            VStack(spacing: 12) {
                                ForEach(todos) { todo in
                                    TodoRow(todo: todo)
                                }
                            }
                        }
                    }

                    // 购物清单
                    if let shoppingList = result.shoppingList, !shoppingList.isEmpty {
                        section(title: "购物清单") {
                            VStack(spacing: 12) {
                                ForEach(shoppingList) { item in
                                    ShoppingItemRow(item: item)
                                }
                            }
                        }
                    }

                    // 日程安排
                    if let schedule = result.schedule, !schedule.isEmpty {
                        section(title: "日程安排") {
                            VStack(spacing: 12) {
                                ForEach(schedule) { item in
                                    ScheduleItemRow(item: item)
                                }
                            }
                        }
                    }
                }
                .padding(20)
            }
            .navigationTitle("AI 分析结果")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        applyResult()
                    } label: {
                        if isApplying {
                            ProgressView()
                                .progressViewStyle(.circular)
                        } else {
                            Text("应用")
                                .bold()
                        }
                    }
                    .disabled(isApplying)
                }
            }
        }
    }

    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)

                content()
                    .padding(16)
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

    private func applyResult() {
        isApplying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            onApply(result)
            dismiss()
        }
    }
}

/// 标签芯片
struct TagChip: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.blue)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.blue.opacity(0.3), lineWidth: 1)
            )
    }
}

/// 待办事项行
struct TodoRow: View {
    let todo: ExtractedTodo

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "circle")
                .font(.title3)
                .foregroundColor(priorityColor)

            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.body)
                    .foregroundColor(.primary)

                Text(todo.priority)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }

    private var priorityColor: Color {
        switch todo.priority {
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
}

/// 购物清单项行
struct ShoppingItemRow: View {
    let item: ExtractedShoppingItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "cart.fill")
                .font(.title3)
                .foregroundColor(.green)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.body)
                    .foregroundColor(.primary)

                if let quantity = item.quantity, let category = item.category {
                    HStack(spacing: 8) {
                        Text(quantity)
                        Text("·")
                        Text(category)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

/// 日程安排项行
struct ScheduleItemRow: View {
    let item: ExtractedScheduleItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: "calendar")
                    .font(.title3)
                    .foregroundColor(.purple)

                Text(item.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Spacer()
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
        .padding(.vertical, 8)
    }
}

#Preview {
    AIAnalysisResultView(result: AIAnalysisResult(
        tags: ["生活", "美食", "快乐"],
        summary: "今天和朋友去了一家很棒的餐厅，享受了美食和愉快的时光。",
        sentimentScore: 0.85,
        todos: [
            ExtractedTodo(title: "预约下周的餐厅", priority: "中"),
            ExtractedTodo(title: "写日记记录今天", priority: "高")
        ],
        shoppingList: [
            ExtractedShoppingItem(name: "牛奶", quantity: "2瓶", category: "食品"),
            ExtractedShoppingItem(name: "面包", quantity: "1袋", category: "食品")
        ],
        schedule: [
            ExtractedScheduleItem(title: "和朋友聚餐", location: "市中心餐厅", notes: "晚上7点")
        ]
    )) { _ in }
}
