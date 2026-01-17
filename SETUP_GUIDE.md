# 古籍阅读 iOS App - Xcode 项目设置指南

## 项目创建步骤

### 方法一：使用 Xcode 创建新项目（推荐）

1. **打开 Xcode**
   - 点击 "Create a new Xcode project"
   - 选择 "iOS" -> "App"
   - 点击 "Next"

2. **配置项目信息**
   - Product Name: `GuJiReader`
   - Team: 选择你的开发团队
   - Organization Identifier: `com.yourname`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - 取消勾选 "Use Core Data"
   - 取消勾选 "Include Tests"
   - 点击 "Next"

3. **保存位置**
   - 选择 `/Users/justin/ZCodeProject/` 目录
   - 点击 "Create"

4. **添加项目文件**

   在 Xcode 中：
   - 删除默认生成的 `ContentView.swift`（我们已经创建了新的）
   - 将以下文件从 `GuJiReader/GuJiReader/` 文件夹拖入 Xcode 项目：
     - `GuJiReaderApp.swift`
     - `Models/Models.swift`
     - `Views/` 目录下的所有文件
     - `Services/BookLibraryService.swift`
     - `Utils/ThemeManager.swift`
     - `Utils/Helpers.swift`

   确保勾选 "Copy items if needed" 和目标 Target。

### 方法二：使用命令行创建

```bash
# 1. 创建项目目录结构
cd /Users/justin/ZCodeProject/GuJiReader

# 2. 创建一个 Package.swift（如果使用 Swift Package Manager）
# 或者直接在 Xcode 中创建项目

# 3. 将所有 .swift 文件添加到 Xcode 项目中
```

## 项目配置

### Info.plist 设置

在 Xcode 中，打开 `Info.plist`，添加以下权限和配置：

```xml
<key>UIFileSharingEnabled</key>
<true/>
<key>UISupportsDocumentBrowser</key>
<true/>
<key>UILaunchScreen</key>
<dict>
    <key>UIImageName</key>
    <string>LaunchImage</string>
</dict>
```

### Bundle Identifier

- 在 Xcode 中选择项目
- 选择 Target
- General -> Bundle Identifier: `com.yourname.GuJiReader`

### Deployment Info

- iOS Deployment Target: `iOS 15.0`
- iPhone: 勾选
- iPad: 勾选（可选）

## 运行项目

1. **选择模拟器或设备**
   - 点击 Xcode 顶部的设备选择器
   - 选择 iPhone 14 Pro 或其他模拟器
   - 或者连接真机

2. **构建并运行**
   - 按 `Cmd + R` 或点击运行按钮
   - 等待构建完成

3. **首次运行**
   - App 会显示登录界面
   - 输入任意用户名和密码即可登录（演示版本）

## 常见问题

### 编译错误

1. **找不到 SwiftUI 模块**
   - 确保 iOS Deployment Target 至少为 iOS 15.0
   - Clean Build Folder (Cmd + Shift + K)

2. **Canvas 相关错误**
   - 这是正常的，某些 Canvas API 在不同 Xcode 版本中可能有差异
   - 可以尝试注释掉 TextureLayer1 和 TextureLayer2

### 界面显示问题

1. **文本显示不正常**
   - 确保设备上有中文字体支持
   - 如果楷体（Kaiti）不可用，会自动降级到系统字体

2. **背景纹理不显示**
   - 这是正常现象，某些 Canvas 效果在不同设备上可能不同
   - 可以在 ThemeManager.swift 中调整纹理参数

## 自定义配置

### 修改应用名称

在 `GuJiReaderApp.swift` 中修改：

```swift
static let appName = "你的应用名称"
```

### 修改主题颜色

在 `ThemeManager.swift` 中修改颜色定义：

```swift
extension Color {
    static let paperBackground = Color(red: 0.98, green: 0.96, blue: 0.92)
    static let inkBlack = Color(red: 0.2, green: 0.2, blue: 0.2)
    // ...
}
```

### 添加更多书籍

在 `BookLibraryService.swift` 的 `loadSampleBooks()` 方法中添加更多书籍数据。

## 真机部署

### 配置签名

1. 在 Xcode 中选择项目
2. 选择 Target -> Signing & Capabilities
3. 选择你的 Team
4. Xcode 会自动处理签名

### 安装到设备

1. 连接 iPhone 到 Mac
2. 在 Xcode 中选择你的设备
3. 按 `Cmd + R` 运行
4. 在 iPhone 上信任开发者证书
   - 设置 -> 通用 -> VPN与设备管理
   - 找到你的开发者证书并信任

## 架构说明

项目采用 MVVM 架构：

- **Model**: 数据模型（Models.swift）
- **View**: 视图组件（Views/ 目录）
- **ViewModel**: 业务逻辑（分散在各个 View 中）
- **Service**: 数据服务（Services/ 目录）
- **Utils**: 工具类和配置（Utils/ 目录）

## 发布准备

### 发布前检查清单

- [ ] 更新 Bundle Identifier
- [ ] 添加应用图标
- [ ] 配置启动屏幕
- [ ] 测试所有功能
- [ ] 优化性能
- [ ] 添加隐私政策
- [ ] 准备 App Store 截图
- [ ] 撰写应用描述

### 应用图标

在 Xcode 中：
1. 找到 Assets.xcassets
2. 添加 AppIcon
3. 拖入不同尺寸的图标文件

---

**需要帮助？**
- 查看项目 README.md
- 检查代码注释
- 参考 SwiftUI 官方文档
