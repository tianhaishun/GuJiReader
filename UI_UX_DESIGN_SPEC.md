# 📜 宋代美学阅读页 UI/UX 设计规范

**版本**: 2.0 - Song Dynasty Aesthetic Edition
**更新日期**: 2025-01-17
**设计理念**: 雅致、留白、质朴、理性

---

## 🎨 设计哲学

### 核心理念
> "计白当黑，大美无言"

**宋代美学关键词**：
- **雅致** - 不张扬，有内涵
- **留白** - 大量空间，呼吸感
- **质朴** - 材质真实，不矫饰
- **理性** - 结构清晰，逻辑自洽

---

## 🎯 配色体系

### 主色调：五大名窑配色

```swift
// 基础背景色 - 仿宣纸米黄色
Background: RGB(245, 240, 230) // #F5F0E6
Alternative: RGB(235, 230, 216)  // #EBE6D8

// 文字色 - 淡墨色
Primary Text: RGB(43, 43, 43)    // #2B2B2B
Secondary Text: RGB(107, 107, 107) // #6B6B6B
Tertiary Text: RGB(156, 156, 156)   // #9C9C9C

// 强调色 - 汝窑天青
Accent: RGB(112, 144, 160)       // #7090A0

// 分割线 - 极细淡墨
Divider: RGB(51, 38, 26) with 0.15 opacity
```

### 配色应用场景

| 元素 | 颜色 | 说明 |
|-----|------|------|
| 背景基础色 | #F5F0E6 | 宣纸米黄 - 温暖柔和 |
| 纸张纹理 | #2B2B2B @ 0.8% opacity | 极淡的墨点 |
| 页面边缘暗角 | #D9D6CC @ 15% opacity | 模拟书页边缘 |
| 正文文字 | #2B2B2B | 淡墨色 - 非纯黑 |
| 标题文字 | #2B2B2B | 与正文同色，加粗区分 |
| 次要文字 | #6B6B6B | 用于提示信息 |
| 进度条 | #7090A0 @ 60% opacity | 汝窑天青 - 含蓄内敛 |
| 分割线 | #2B2B2B @ 10-15% opacity | 极细淡墨 |

---

## 📐 排版系统

### 字体选择

#### 标题字体 - 宋体（人文气息）
```swift
// iOS 系统字体
.font(.custom("Songti SC", size: 32))
```

#### 正文字体 - 楷体（易读性强）
```swift
// iOS 系统字体
.font(.custom("Kaiti SC", size: 20))
```

**字体回退方案**：
```swift
// 如果系统不支持
.font(.system(size: 20, design: .serif))
```

### 排版参数

| 参数 | 值 | 说明 |
|-----|---|------|
| **正文基础字号** | 18-20px | 适合沉浸阅读 |
| **标题字号** | 28-32px | 层级分明 |
| **辅助字号** | 12-14px | 按钮、标签等 |
| **行间距** | 1.8倍字号 | 宽松舒适 |
| **字间距** | 0.8px | 增加空气感 |
| **段落间距** | 24-32px | 明确区分段落 |
| **页面左右留白** | 48px | 大幅增加呼吸空间 |
| **页面上下留白** | 120-180px | 顶部底部留白 |

### 排版实现代码

```swift
Text(content)
    .font(.custom("Kaiti SC", size: 20))
    .fontWeight(.light)
    .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
    .lineSpacing(20 * 1.8)  // 1.8倍行距
    .kerning(0.8)           // 字间距
    .multilineTextAlignment(.leading)
    .padding(.horizontal, 48)  // 左右留白
```

---

## 🎭 视觉质感

### 纸张纹理实现

#### 方法1：Canvas 绘制细微纤维（已实现）
```swift
Canvas { context, size in
    // 800个细微纤维点
    for _ in 0..<800 {
        let startX = CGFloat.random(in: 0...size.width)
        let startY = CGFloat.random(in: 0...size.height)
        let length = CGFloat.random(in: 1...6)
        let angle = CGFloat.random(in: 0...2 * .pi)

        var path = Path()
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(
            to: CGPoint(
                x: startX + cos(angle) * length,
                y: startY + sin(angle) * length
            )
        )

        // 淡墨色纹理 - 极淡 (0.8% opacity)
        context.stroke(
            path,
            with: .color(Color(red: 0.2, green: 0.15, blue: 0.1).opacity(0.008)),
            lineWidth: 0.3
        )
    }

    // 400个斑点纹理
    for _ in 0..<400 {
        let x = CGFloat.random(in: 0...size.width)
        let y = CGFloat.random(in: 0...size.height)
        let radius = CGFloat.random(in: 0.3...1.5)

        context.fill(
            Path(ellipseIn: CGRect(x: x, y: y, width: radius * 2, height: radius * 2)),
            with: .color(Color(red: 0.3, green: 0.25, blue: 0.2).opacity(0.012))
        )
    }
}
```

#### 方法2：边缘渐变暗角（已实现）
```swift
let gradient = Gradient(stops: [
    Gradient.Stop(color: Color(red: 0.85, green: 0.82, blue: 0.76).opacity(0.15), location: 0),
    Gradient.Stop(color: Color.clear, location: 0.15),
    Gradient.Stop(color: Color.clear, location: 0.85),
    Gradient.Stop(color: Color(red: 0.85, green: 0.82, blue: 0.76).opacity(0.15), location: 1)
])

context.fill(
    Path(Rectangle(origin: .zero, size: size)),
    with: .linearGradient(
        gradient,
        startPoint: CGPoint(x: 0, y: size.height / 2),
        endPoint: CGPoint(x: size.width, y: size.height / 2)
    )
)
```

### 质感层次

| 层级 | 元素 | 透明度 | 作用 |
|-----|------|--------|------|
| 基础层 | 宣纸底色 | 100% | 主背景 |
| 纹理层1 | 纤维点 | 0.8% | 纸张质感 |
| 纹理层2 | 斑点 | 1.2% | 自然瑕疵 |
| 氛围层 | 边缘暗角 | 15% | 书页感 |

---

## 💬 布局与留白

### 留白原则

**"计白当黑" - 留白即内容**

| 区域 | 留白值 | 说明 |
|-----|--------|------|
| **页面左右** | 48px | 大幅增加呼吸感 |
| **页面顶部** | 120px | 标题与状态栏距离 |
| **页面底部** | 180px | 内容与菜单距离 |
| **章节标题前后** | 24px | 章节内的留白 |
| **段落间距** | 32px | 明确区分段落 |
| **组件间距** | 16-24px | 统一间距系统 |

### 布局网格

```
┌──────────────────────────────────────────────────┐
│                   顶部留白 (120px)                 │
├──────────────────────────────────────────────────┤
│  左留白(48) │  内容区域  │ 右留白(48)             │
│      (48)    │            │      (48)             │
│              │            │                      │
│              │   正文     │                      │
│              │   内容     │                      │
│              │            │                      │
│              │            │                      │
├──────────────────────────────────────────────────┤
│                  底部留白 (180px)                 │
└──────────────────────────────────────────────────┘
```

---

## 👆 交互设计

### 点击区域划分

```
┌──────────────────────────────────────────────┐
│                                              │
│  翻页区   │     呼出菜单区     │   翻页区    │
│  (20%)   │      (60%)       │   (20%)    │
│          │                  │            │
│  点击:    │   点击:          │   点击:     │
│  上一章   │   显示/隐藏菜单  │   下一章    │
│          │                  │            │
│  ←       │      ☰          │       →    │
│                                              │
└──────────────────────────────────────────────┘
```

### 翻页交互

#### 1. 点击翻页
- **左侧20%区域**：上一章
- **右侧20%区域**：下一章
- **中间60%区域**：显示/隐藏菜单

#### 2. 滑动翻页（手势）
```swift
DragGesture()
    .onChanged { value in
        // 实时跟随手指
        dragOffset = value.translation.width
    }
    .onEnded { value in
        // 滑动超过100px触发翻页
        let threshold: CGFloat = 100
        if value.translation.width < -threshold {
            // 向左滑动 → 下一章
        } else if value.translation.width > threshold {
            // 向右滑动 → 上一章
        }
    }
```

#### 3. 动画参数
```swift
// 翻页动画
.spring(response: 0.4, dampingFraction: 0.8)

// 菜单显示/隐藏
.easeInOut(duration: 0.25)

// 页面切换
.easeOut(duration: 0.3)
```

### 触觉反馈

```swift
// 轻触 - 点击翻页
UIImpactFeedbackGenerator(style: .light)

// 中等 - 菜单操作
UIImpactFeedbackGenerator(style: .medium)

// 成功 - 添加书签
UINotificationFeedbackGenerator()
    .notificationOccurred(.success)
```

---

## 🎭 菜单设计

### 顶部菜单

**设计原则**：
- 淡入淡出动画
- 半透明背景模糊
- 极简设计

```swift
VStack(spacing: 0) {
    HStack {
        // 返回按钮 (44x44)
        // 书名 (居中)
        // 设置按钮 (44x44)
    }
    .padding(.horizontal, 24)
    .padding(.top, 12)
    .padding(.bottom, 8)
    .background(
        Color(red: 0.96, green: 0.94, blue: 0.90)
            .opacity(0.95)
            .blur(radius: 1)
    )
}
```

### 底部菜单

**设计原则**：
- 进度条 + 章节信息
- 工具按钮对称布局
- 统一间距系统

```swift
VStack(spacing: 0) {
    // 1. 进度滑块
    HStack {
        Text("第 X 章")
        Slider(value: ...)
        Text("共 Y 章")
    }

    // 2. 分割线 (0.5px)
    Rectangle()
        .fill(Color(...).opacity(0.1))

    // 3. 工具栏
    HStack {
        Button("上一章") {}
        Spacer()
        Button("书签") {}
        Spacer()
        Button("目录") {}
        Spacer()
        Button("下一章") {}
    }
}
```

---

## 📱 页面状态

### 1. 默认状态（菜单隐藏）
```
┌─────────────────────────────────────┐
│                                     │
│         【大留白】                   │
│                                     │
│         章节标题                     │
│         ─────                        │
│                                     │
│         正文内容                     │
│         （可滚动）                   │
│                                     │
│                                     │
│   │  阅读进度指示器                 │
└─────────────────────────────────────┘
```

### 2. 菜单显示状态
```
┌─────────────────────────────────────┐
│ ← 返回    书名          设置 ⚙️   │
├─────────────────────────────────────┤
│                                     │
│         章节标题                     │
│         ─────                        │
│                                     │
│         正文内容                     │
│                                     │
├─────────────────────────────────────┤
│ 进度条：━━━━●━━━━━━━━               │
│ ──────────────────────────────────── │
│ 上一章  书签  目录  下一章          │
└─────────────────────────────────────┘
```

### 3. 翻页过渡状态
```
当前页 ← 滑动中 → 下一页预览
[淡化]  ←  →  [渐显]
```

---

## 🎬 动画规范

### 翻页动画类型

| 动画类型 | 参数 | 应用场景 |
|---------|------|---------|
| **Spring弹性** | response: 0.4, damping: 0.8 | 滑动翻页 |
| **EaseOut缓出** | duration: 0.3 | 页面切换 |
| **EaseInOut缓动** | duration: 0.25 | 菜单显示/隐藏 |

### 动画时机

```swift
// 1. 章节切换动画
withAnimation(.easeOut(duration: 0.3)) {
    currentPageIndex += 1
}

// 2. 菜单显示动画
withAnimation(.easeInOut(duration: 0.25)) {
    showMenu.toggle()
}

// 3. 滑动回弹动画
withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
    dragOffset = 0
}
```

---

## 📏 尺寸规范

### 按钮尺寸
```swift
// 最小点击区域（iOS人机交互指南）
44x44 pt

// 工具栏按钮
60x60 pt

// 返回/设置按钮
44x44 pt
```

### 间距系统
```swift
// 单位：8px
4pt:  0.5x (极小间距)
8pt:  1x   (小间距)
12pt: 1.5x (文字间距)
16pt: 2x   (组件内间距)
24pt: 3x   (组件间间距)
32pt: 4x   (大间距)
48pt: 6x   (页面级留白)
```

---

## 🔄 集成指南

### 替换现有ReadingView

**步骤1**: 导入新视图
```swift
// 在ReadingView.swift中
var body: some View {
    EnhancedReadingView(
        book: book,
        chapter: currentChapter,
        currentPageIndex: $currentChapterIndex,
        showMenu: $showMenu
    )
}
```

**步骤2**: 添加状态管理
```swift
@State private var showMenu = false
@State private var currentChapterIndex = 0
```

**步骤3**: 连接现有数据
```swift
private var currentChapter: Chapter {
    book.chapters[currentChapterIndex]
}
```

---

## ✅ 质量检查清单

### 视觉质量
- [ ] 背景色为仿宣纸米黄色 (#F5F0E6)
- [ ] 文字色为淡墨色 (#2B2B2B)
- [ ] 纸张纹理细腻自然
- [ ] 留白充足（左右48px）
- [ ] 边缘暗角效果明显

### 交互质量
- [ ] 左侧点击翻到上一章
- [ ] 右侧点击翻到下一章
- [ ] 中间点击显示/隐藏菜单
- [ ] 滑动翻页流畅自然
- [ ] 触觉反馈恰当

### 排版质量
- [ ] 行间距1.8倍
- [ ] 字间距0.8px
- [ ] 字号18-20px
- [ ] 字体为楷体/宋体
- [ ] 段落间距充足

---

## 🎯 未来扩展

### 短期优化
- [ ] 竖排文字模式（传统古籍阅读）
- [ ] 字体切换（宋体、楷体、黑体）
- [ ] 自定义字号范围
- [ ] 夜间模式优化

### 中期规划
- [ ] 手势放大功能
- [ ] 选择文本高亮
- [ ] 批注笔记
- [ ] 生僻字注音

### 长期愿景
- [ ] AI 辅助阅读
- [ ] 社区分享
- [ ] 跨设备同步

---

**设计师**: Z Code AI Design Team
**技术实现**: SwiftUI + iOS 15+
**参考风格**: 宋代五大名窑、古籍善本

**更新日期**: 2025-01-17
**版本**: 2.0 Song Dynasty Aesthetic
