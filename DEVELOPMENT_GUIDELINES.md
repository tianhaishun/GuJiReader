# 📋 GuJiReader 开发规范与最佳实践

**版本**: 1.0
**更新日期**: 2025-01-17
**维护者**: 开发团队

---

## 🎯 文档目的

本文档记录开发过程中遇到的问题、解决方案和最佳实践，避免重复犯错，提高代码质量和开发效率。

---

## ⚠️ 常见错误与解决方案

### 1. Combine框架导入问题

#### ❌ 错误示例
```swift
import Foundation
import SwiftUI

class MyManager: ObservableObject {
    @Published var data: [String] = []  // ❌ 编译错误
    // Protocol requires property 'objectWillChange'
    // Initializer 'init(wrappedValue:)' is not available
}
```

#### ✅ 正确写法
```swift
import Foundation
import SwiftUI
import Combine  // ✅ 必须导入

class MyManager: ObservableObject {
    @Published var data: [String] = []
}
```

#### 📌 规则
**所有使用 `@Published` 属性包装器的类，必须导入 `Combine` 框架。**

#### 🔍 检查清单
- [ ] 文件中是否使用了 `ObservableObject` 协议？
- [ ] 是否使用了 `@Published` 属性包装器？
- [ ] 如果是，**必须**在文件顶部添加 `import Combine`

#### 📂 本项目中的文件
以下文件已正确导入Combine：
- ✅ `Services/BookLibraryService.swift`
- ✅ `Services/ReadingProgressManager.swift`
- ✅ `Services/BookmarkManager.swift`
- ✅ `Utils/ThemeManager.swift`
- ✅ `Utils/PageTransitionManager.swift`

---

### 2. 字符串转义问题

#### ❌ 错误示例
```swift
// ❌ 多行字符串语法错误
let mappings: [String: String] = [
    "「": """
    "」": """,
]
```

#### ✅ 正确写法
```swift
// ✅ 使用反斜杠转义
let mappings: [String: String] = [
    "「": "\"",
    "」": "\"",
]

// 或使用多行字符串字面量
let mappings: [String: String] = [
    "「": #"""#,
    "」": #"""#,
]
```

#### 📌 规则
**字符串中包含引号时，必须使用反斜杠转义。**

#### 🔍 常见转义字符
```swift
\"  // 双引号
\'  // 单引号
\\  // 反斜杠
\n  // 换行
\t  // 制表符
\0  // 空字符
```

---

### 3. 方法名冲突（重复声明）

#### ❌ 错误示例
```swift
class Converter {
    // 私有方法
    private func toSimplified(_ text: String) -> String {
        // 实现...
    }

    // 公共方法 - ❌ 方法名冲突
    func toSimplified(_ text: String) -> String {
        return convert(text, mode: .traditionalToSimplified)
    }
}
```

#### ✅ 正确写法
```swift
class Converter {
    // 私有实现（不同的命名）
    private func performToSimplifiedConversion(_ text: String) -> String {
        // 实现...
    }

    // 公共接口
    func toSimplified(_ text: String) -> String {
        return performToSimplifiedConversion(text)
    }
}
```

#### 📌 规则
**私有方法和公共方法不应重名，建议私有方法使用描述性名称（如 `perform` 前缀）。**

---

### 4. Color的Codable实现

#### ⚠️ 限制说明
```swift
extension Color: Codable {
    public init(from decoder: Decoder) throws {
        // ✅ 可以解码：从RGB值创建Color
    }

    public func encode(to encoder: Encoder) throws {
        // ❌ 无法编码：SwiftUI.Color不提供获取RGB值的接口
        // 只能编码为空或使用其他方案
    }
}
```

#### ✅ 推荐方案
```swift
// 方案1：使用String存储hex颜色值
struct Book: Codable {
    var coverColor: String  // "8B4513"
}

// 方案2：使用UIColor
import UIKit

struct ColorData: Codable {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double

    var color: Color {
        Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
```

#### 📌 规则
**尽量避免在数据模型中直接使用SwiftUI.Color作为Codable属性。使用String或自定义ColorData结构体代替。**

---

### 5. TextEditor占位符实现

#### ❌ 错误示例
```swift
// ❌ TextEditor没有placeholder属性
TextEditor(text: $note)
    .placeholder("添加笔记...")  // 方法不存在
```

#### ✅ 正确写法
```swift
// ✅ 使用overlay实现
TextEditor(text: $note)
    .overlay(
        Text("添加笔记...")
            .foregroundColor(.secondary)
            .opacity(note.isEmpty ? 1 : 0),
        alignment: .topLeading
    )
```

#### 📌 规则
**SwiftUI的TextEditor不提供placeholder，需要使用overlay手动实现。**

---

## 🏗️ 项目架构规范

### 文件组织结构
```
GuJiReader/
├── Models/              # 数据模型
│   └── Models.swift     # 所有数据结构定义
├── Views/               # 视图层
│   ├── ContentView.swift
│   ├── ReadingView.swift
│   └── ...
├── Services/            # 业务逻辑层
│   ├── BookLibraryService.swift
│   ├── ReadingProgressManager.swift
│   └── BookmarkManager.swift
├── Utils/               # 工具类
│   ├── ThemeManager.swift
│   ├── ChineseConverter.swift
│   └── ...
└── Resources/           # 资源文件
    └── ...
```

### 命名规范

#### 类名（UpperCamelCase）
```swift
class BookmarkManager: ObservableObject { }
struct ReadingProgress: Codable { }
enum ReadingTheme: String { }
```

#### 属性名（lowerCamelCase）
```swift
@Published var bookmarks: [Bookmark] = []
var currentChapterIndex: Int = 0
```

#### 常量（lowerCamelCase）
```swift
private let userDefaultsKey = "bookmarks"
static let shared = BookmarkManager()
```

---

## 📦 依赖管理

### 必需的导入
```swift
// 所有SwiftUI视图
import SwiftUI

// 所有使用@Published的类
import Combine

// 数据模型
import Foundation

// 触觉反馈
import UIKit
```

### 导入顺序
```swift
// 1. 系统框架（按字母顺序）
import Combine
import Foundation
import SwiftUI
import UIKit

// 2. 项目模块（如果有）
```

---

## 🎨 UI开发规范

### 视图修饰器顺序
```swift
struct MyView: View {
    var body: some View {
        Text("Hello")
            .font(.title)              // 1. 字体
            .foregroundColor(.blue)    // 2. 颜色
            .padding()                 // 3. 内边距
            .background(Color.white)   // 4. 背景
            .cornerRadius(12)          // 5. 圆角
            .shadow(radius: 2)         // 6. 阴影
            .onTapGesture { }          // 7. 手势
    }
}
```

### 状态管理
```swift
// 本地状态
@State private var showModal = false

// 双向绑定
@Binding var isPresented: Bool

// 全局状态（单例）
@StateObject private var manager = MyManager.shared

// 环境对象
@EnvironmentObject var libraryService: BookLibraryService
```

---

## 💾 数据持久化规范

### UserDefaults使用
```swift
// ✅ 适合存储简单数据
private func saveData() {
    UserDefaults.standard.set(value, forKey: "key")
}

private func loadData() {
    let value = UserDefaults.standard.string(forKey: "key")
}
```

### 复杂数据存储
```swift
// ✅ 使用JSON编码
private func saveBookmarks(_ bookmarks: [Bookmark]) {
    if let data = try? JSONEncoder().encode(bookmarks) {
        UserDefaults.standard.set(data, forKey: "bookmarks")
    }
}

private func loadBookmarks() -> [Bookmark]? {
    guard let data = UserDefaults.standard.data(forKey: "bookmarks"),
          let decoded = try? JSONDecoder().decode([Bookmark].self, from: data) else {
        return nil
    }
    return decoded
}
```

---

## 🔧 调试与日志

### DEBUG标记
```swift
#if DEBUG
print("✅ 已保存书签：\(bookmark.title)")
#endif
```

### 日志级别
```swift
// ✅ 成功操作
print("✅ 已保存阅读进度")

// ❌ 错误
print("❌ 保存失败：\(error.localizedDescription)")

// ⚠️ 警告
print("⚠️ 书签已存在")

// 🔍 调试信息
print("🔍 当前章节：第\(index)章")
```

---

## ✅ 代码审查清单

### 提交前检查

#### 功能完整性
- [ ] 功能是否按需求实现？
- [ ] 边界情况是否处理？
- [ ] 错误处理是否完善？

#### 代码质量
- [ ] 是否遵循命名规范？
- [ ] 是否有必要的注释？
- [ ] 是否有重复代码？

#### 性能
- [ ] 是否有内存泄漏？
- [ ] 是否有不必要的重绘？
- [ ] 大数据是否分页/懒加载？

#### 兼容性
- [ ] 是否支持暗色模式？
- [ ] 是否适配不同屏幕尺寸？
- [ ] 是否处理了iOS版本差异？

---

## 🚀 开发工作流

### 功能开发流程
1. **需求分析** → 明确功能目标
2. **设计阶段** → UI/UX设计
3. **开发阶段** → 编写代码
4. **测试阶段** → 单元测试+集成测试
5. **代码审查** → 使用本清单
6. **提交代码** → 遵循Git规范

### Git提交规范
```bash
# 功能开发
git commit -m "feat: 添加书签功能"

# Bug修复
git commit -m "fix: 修复繁简转换崩溃问题"

# 性能优化
git commit -m "perf: 优化阅读进度保存性能"

# 文档更新
git commit -m "docs: 更新开发规范文档"
```

---

## 📚 技术债务追踪

### 当前已知问题

#### 1. Color.Codable实现不完整
- **状态**: 已记录
- **影响**: 无法正确序列化Color属性
- **优先级**: 中
- **解决方案**: 改用String(hex)存储颜色

#### 2. 数据库缺失
- **状态**: 已规划
- **影响**: 大量数据时性能下降
- **优先级**: 高
- **解决方案**: 集成GRDB数据库

#### 3. 缺少单元测试
- **状态**: 待实施
- **影响**: 代码质量无保障
- **优先级**: 中
- **解决方案**: 添加XCTest测试用例

---

## 🎓 学习资源

### 官方文档
- [SwiftUI](https://developer.apple.com/documentation/swiftui)
- [Combine](https://developer.apple.com/documentation/combine)
- [Swift](https://docs.swift.org/)

### 推荐实践
- [SwiftUI by Example](https://www.hackingwithswift.com/quick-start/swiftui)
- [iOS Good Practices](https://github.com/kharrison/CodeExamples)

---

## 📝 更新日志

### v1.0 (2025-01-17)
- ✅ 初始版本
- ✅ 记录5个常见错误及解决方案
- ✅ 制定项目架构规范
- ✅ 添加代码审查清单

---

## 🔖 快速参考

### 常用代码片段

#### ObservableObject模板
```swift
import Foundation
import SwiftUI
import Combine  // ⚠️ 必需

class MyManager: ObservableObject {
    static let shared = MyManager()

    @Published var data: [String] = []
    private let key = "UserDefaultsKey"

    private init() {
        loadData()
    }

    private func loadData() {
        // 实现...
    }

    private func saveData() {
        // 实现...
    }
}
```

#### 数据模型模板
```swift
struct MyModel: Identifiable, Codable {
    var id: String
    var title: String
    var createdAt: Date

    // 避免使用Color，使用String代替
    var colorHex: String
}
```

---

**维护提示**: 遇到新的问题或解决方案时，请及时更新本文档！

**最后更新**: 2025-01-17
**文档版本**: 1.0
