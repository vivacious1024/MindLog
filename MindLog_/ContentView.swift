//
//  ContentView.swift
//  MindLog_
//
//  Created by Siegfried on 2026/1/29.
//  Unified Capsule TabBar Style
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 1  // 默认选中手帐
    @State private var showingEditor = false
    @State private var showingJournalCreation = false
    @State private var showingProfile = false
    
    var body: some View {
        ZStack {
            // 主内容区域
            TabView(selection: $selectedTab) {
                // Tab 0: 社区
                CommunityFeedView()
                    .tag(0)
                
                // Tab 1: 手帐
                JournalListView()
                    .tag(1)
            }
            
            // 左上角"我的"按钮
            VStack {
                HStack {
                    Button(action: { showingProfile = true }) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.primary)
                            .frame(width: 44, height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.regularMaterial)
                                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                            )
                    }
                    .buttonStyle(GlassButtonPressStyle())
                    .padding(.leading,10)
                    .padding(.top, 8)
                    
                    Spacer()
                }
                Spacer()
            }
            .zIndex(10)  // 确保在最上层
            
            // 底部导航栏
            VStack {
                Spacer()
                CustomTabBar(
                    selectedTab: $selectedTab,
                    onAddTapped: {
                        showingJournalCreation = true
                    }
                )
            }
            .ignoresSafeArea(.keyboard)
        }
        .sheet(isPresented: $showingEditor) {
            JournalEditorView(entry: nil)
        }
        .sheet(isPresented: $showingJournalCreation) {
            JournalCreationView()
        }
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
    }
}

/// 自定义底部导航栏 - 统一胶囊容器
struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let onAddTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            // 左侧：社区
            Button(action: { selectedTab = 0 }) {
                Image(systemName: selectedTab == 0 ? "person.3.fill" : "person.3")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(selectedTab == 0 ? .primary : .secondary)
                    .frame(width: 50, height: 44)
            }
            .buttonStyle(TabButtonPressStyle())
            
            // 中央：添加按钮
            Button(action: onAddTapped) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(width: 50, height: 44)
            }
            .buttonStyle(TabButtonPressStyle())
            
            // 右侧：手帐
            Button(action: { selectedTab = 1 }) {
                Image(systemName: selectedTab == 1 ? "book.fill" : "book")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(selectedTab == 1 ? .primary : .secondary)
                    .frame(width: 50, height: 44)
            }
            .buttonStyle(TabButtonPressStyle())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(.regularMaterial)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.12), radius: 16, y: -8)
        .padding(.bottom,-10)
    }
}

/// 按钮按压样式 - 轻量级反馈
struct TabButtonPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// 玻璃按钮按压样式
struct GlassButtonPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.90 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}
