#!/bin/bash

# 古籍阅读 iOS App - 快速开始脚本

echo "================================"
echo "古籍阅读 iOS App - 快速开始"
echo "================================"
echo ""

# 检查是否安装了 Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ 未检测到 Xcode"
    echo "请先从 App Store 安装 Xcode"
    exit 1
fi

echo "✅ 已检测到 Xcode"
echo ""

# 显示项目信息
echo "📱 项目信息"
echo "-----------"
echo "项目名称: 古籍阅读 (GuJiReader)"
echo "项目路径: $(pwd)"
echo "Swift 文件数: $(find . -name "*.swift" -type f | wc -l)"
echo ""

# 列出主要文件
echo "📁 项目文件"
echo "-----------"
echo "核心文件:"
ls -1 GuJiReader/GuJiReader/*.swift 2>/dev/null | sed 's|^|  |'

echo ""
echo "视图文件:"
ls -1 GuJiReader/GuJiReader/Views/*.swift 2>/dev/null | sed 's|^|  |'

echo ""
echo "服务文件:"
ls -1 GuJiReader/GuJiReader/Services/*.swift 2>/dev/null | sed 's|^|  |'

echo ""
echo "工具文件:"
ls -1 GuJiReader/GuJiReader/Utils/*.swift 2>/dev/null | sed 's|^|  |'

echo ""
echo "================================"
echo "下一步操作"
echo "================================"
echo ""
echo "1. 打开 Xcode"
echo "2. 创建新的 iOS App 项目:"
echo "   - Product Name: GuJiReader"
echo "   - Interface: SwiftUI"
echo "   - Language: Swift"
echo "   - 保存位置: $(pwd)"
echo ""
echo "3. 将项目文件添加到 Xcode:"
echo "   - 删除默认的 ContentView.swift"
echo "   - 拖入所有 .swift 文件到项目"
echo "   - 确保勾选 'Copy items if needed'"
echo ""
echo "4. 运行项目:"
echo "   - 选择模拟器或真机"
echo "   - 按 Cmd + R 运行"
echo ""
echo "================================"
echo "详细文档"
echo "================================"
echo ""
echo "📖 README.md - 项目介绍和功能说明"
echo "⚙️  SETUP_GUIDE.md - 详细的设置指南"
echo "🎨 ICON_GUIDE.md - 应用图标设计指南"
echo ""
echo "================================"
echo "📚 开始您的古籍阅读之旅！"
echo "================================"
