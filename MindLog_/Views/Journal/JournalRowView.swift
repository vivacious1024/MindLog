//
//  JournalRowView.swift
//  MindLog_
//
//  Created by Siegfried on 2026/1/29.
//  Refactored with Liquid Glass by Antigravity on 2026/1/31
//

import SwiftUI

/// 日记行视图组件 - Liquid Glass 风格
struct JournalRowView: View {
    let entry: JournalEntry
    
    var body: some View {
        GlassCard(style: .regular, cornerRadius: AppConstants.CornerRadius.medium) {
            VStack(alignment: .leading, spacing: 12) {
                // 标题和心情
                HStack(alignment: .top) {
                    Text(entry.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if let mood = entry.mood {
                        moodBadge(mood)
                    }
                }
                
                // 内容预览
                if let content = entry.textContent {
                    Text(content)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                // AI 标签（如果有）
                if let tags = entry.aiTags, !tags.isEmpty {
                    FlowLayout(spacing: 8) {
                        ForEach(tags.prefix(3), id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .foregroundStyle(.purple)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(.purple.opacity(0.15))
                                )
                        }
                    }
                }
                
                // 底部元数据
                HStack(spacing: 12) {
                    // 日期
                    Label(
                        entry.createdAt.formatted(date: .abbreviated, time: .omitted),
                        systemImage: "calendar"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    
                    // 附件数量
                    if let attachments = entry.attachments, !attachments.isEmpty {
                        Label("\\(attachments.count)", systemImage: "photo")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    // 心情评分（如果有）
                    if let score = entry.aiSentimentScore {
                        sentimentIndicator(score)
                    }
                }
            }
            .padding(16)
        }
    }
    
    // MARK: - Mood Badge
    
    private func moodBadge(_ mood: MoodType) -> some View {
        HStack(spacing: 4) {
            Text(mood.rawValue)
                .font(.title3)
            
            Text(mood.description)
                .font(.caption)
                .foregroundStyle(mood.color)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(mood.color.opacity(0.15))
        )
    }
    
    // MARK: - Sentiment Indicator
    
    private func sentimentIndicator(_ score: Double) -> some View {
        HStack(spacing: 4) {
            Image(systemName: sentimentIcon(score))
                .font(.caption)
            Text(String(format: "%.0f%%", score * 100))
                .font(.caption2)
        }
        .foregroundStyle(sentimentColor(score))
    }
    
    private func sentimentIcon(_ score: Double) -> String {
        if score >= 0.7 {
            return "face.smiling.fill"
        } else if score >= 0.4 {
            return "face.smiling"
        } else {
            return "face.dashed"
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
}

#Preview("Journal Rows") {
    ZStack {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        
        ScrollView {
            LazyVStack(spacing: 16) {
                JournalRowView(
                    entry: JournalEntry(
                        title: "美好的一天",
                        textContent: "今天天气很好，心情也很棒！去公园散步了，看到了很多美丽的花朵。春天真的来了，一切都充满了希望。",
                        mood: .happy,
                        aiTags: ["生活", "自然", "快乐"],
                        aiSentimentScore: 0.85
                    )
                )
                
                JournalRowView(
                    entry: JournalEntry(
                        title: "工作总结",
                        textContent: "今天完成了项目的重要里程碑，团队很给力！虽然有些累，但是看到成果很有成就感。",
                        mood: .amazing,
                        aiTags: ["工作", "成就", "团队"],
                        aiSentimentScore: 0.75
                    )
                )
                
                JournalRowView(
                    entry: JournalEntry(
                        title: "有点焦虑",
                        textContent: "今天工作压力有点大，需要调整心态。深呼吸，一切都会好起来的。",
                        mood: .anxious,
                        aiTags: ["情绪", "压力"],
                        aiSentimentScore: 0.35
                    )
                )
            }
            .padding(16)
        }
    }
}
