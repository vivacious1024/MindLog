#!/bin/bash

# MindLog iOS App 运行脚本
# 用于添加新文件到 Xcode 项目并运行应用

echo "🚀 准备运行 MindLog iOS App..."
echo ""

# 1. 检查 Xcode 是否已安装
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ 错误: 未找到 Xcode，请先安装 Xcode"
    exit 1
fi

# 2. 进入项目目录
cd "$(dirname "$0")"
PROJECT_DIR="/Users/jacob/Desktop/MindLog/MindLog-main"
cd "$PROJECT_DIR"

echo "📁 项目目录: $PROJECT_DIR"
echo ""

# 3. 列出新创建的文件
echo "📝 新创建的文件："
echo "  Models:"
echo "    - JournalDraft.swift"
echo "    - LayoutStyle.swift"
echo ""
echo "  Services:"
echo "    - KeywordExtractor.swift"
echo "    - JournalRenderer.swift"
echo ""
echo "  Views/JournalCreation:"
echo "    - JournalCreationView.swift"
echo "    - StepIndicatorView.swift"
echo "    - NavigationBarView.swift"
echo "    - Step1InputView.swift"
echo "    - Step2LayoutView.swift"
echo "    - Step3PreviewView.swift"
echo ""

# 4. 打开 Xcode 项目
echo "🔧 打开 Xcode 项目..."
open MindLog_.xcodeproj

echo ""
echo "✅ Xcode 已打开！"
echo ""
echo "📋 接下来的步骤："
echo ""
echo "1️⃣  在 Xcode 中，所有新文件应该已经在项目中了"
echo ""
echo "2️⃣  添加相册权限（如果还没有）："
echo "    - 打开 Info.plist"
echo "    - 添加 'Privacy - Photo Library Additions Usage Description'"
echo "    - 值设为: '需要访问相册以保存您的手帐作品'"
echo ""
echo "3️⃣  选择模拟器："
echo "    - 点击顶部工具栏的设备选择器"
echo "    - 选择 'iPhone 15 Pro' 或其他 iOS 模拟器"
echo ""
echo "4️⃣  运行应用："
echo "    - 按 Cmd + R 或点击运行按钮 ▶️"
echo ""
echo "5️⃣  测试手帐创作功能："
echo "    - 等待应用启动"
echo "    - 点击底部导航栏的 ➕ 按钮"
echo "    - 体验 3 步骤手帐创作流程！"
echo ""
echo "🎉 准备完成！现在可以在 Xcode 中运行应用了！"
