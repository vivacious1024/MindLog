#!/bin/bash

# MindLog GitHub 推送脚本
# 使用 gh CLI 简化推送流程

echo "🚀 准备推送 MindLog 到 GitHub..."
echo ""

cd /Users/jacob/Desktop/MindLog

# 检查是否安装了 gh CLI
if command -v gh &> /dev/null; then
    echo "✅ 找到 GitHub CLI"
    echo ""
    echo "正在使用 gh CLI 推送..."
    
    # 使用 gh 创建仓库并推送
    gh repo create vivacious1024/MindLog --public --source=. --remote=origin --push
    
else
    echo "❌ 未找到 GitHub CLI"
    echo ""
    echo "请选择以下方法之一："
    echo ""
    echo "方法 1: 安装 GitHub CLI"
    echo "  brew install gh"
    echo "  gh auth login"
    echo "  然后重新运行此脚本"
    echo ""
    echo "方法 2: 使用 GitHub Desktop"
    echo "  1. 打开 GitHub Desktop"
    echo "  2. File -> Add Local Repository"
    echo "  3. 选择 /Users/jacob/Desktop/MindLog"
    echo "  4. Publish repository"
    echo ""
    echo "方法 3: 手动推送"
    echo "  cd /Users/jacob/Desktop/MindLog"
    echo "  git push -u origin main"
    echo "  (需要输入 GitHub 用户名和 Personal Access Token)"
fi
