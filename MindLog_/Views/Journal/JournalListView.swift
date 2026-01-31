//
//  JournalListView.swift
//  MindLog_
//
//  Created by Siegfried on 2026/1/29.
//  Refactored with Liquid Glass by Antigravity on 2026/1/31
//

import SwiftUI
import SwiftData

/// 手帐列表视图（Tab 1）
/// 应用 Liquid Glass 设计系统
struct JournalListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]
    
    @State private var showingEditor = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 保持原先的纯白色背景
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if entries.isEmpty {
                    // 空状态 - Glass 卡片样式
                    emptyStateView
                } else {
                    // 日记列表 - LazyVStack 性能优化
                    journalListView
                }
                

            }
            .navigationTitle("手帐")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingEditor) {
                JournalEditorView(entry: nil)
            }
        }
    }
    
    // MARK: - Empty State View
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 8) {
                Text("还没有日记")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("点击底部 + 创建你的第一篇日记")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .glassCardStyle(.subtle, cornerRadius: AppConstants.CornerRadius.large)
        .padding(40)
    }
    
    // MARK: - Journal List View
    
    private var journalListView: some View {
        ScrollView {
            // LazyVStack 性能优化 (SwiftUI Skill)
            LazyVStack(spacing: 16) {
                ForEach(entries) { entry in
                    NavigationLink {
                        JournalDetailView(entry: entry)
                    } label: {
                        JournalRowView(entry: entry)
                    }
                    .buttonStyle(.plain) // 避免默认按钮样式
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 100) // 为 FAB 留出空间
        }
        .scrollIndicators(.hidden)
    }
    
    // MARK: - Delete Action
    
    private func deleteEntry(_ entry: JournalEntry) {
        withAnimation {
            modelContext.delete(entry)
        }
    }
}

#Preview("With Entries") {
    JournalListView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}

#Preview("Empty State") {
    let container = try! ModelContainer(for: JournalEntry.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    return JournalListView()
        .modelContainer(container)
}
