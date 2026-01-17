# ✅ 代码审查快速清单

**使用场景**: 提交代码前、PR审查前、功能完成后

---

## 🔍 必查项（阻塞问题）

### 1. 编译相关
- [ ] **所有文件可以成功编译**（`Cmd + B`）
- [ ] **没有编译警告**
- [ ] **所有ObservableObject类已导入Combine**

### 2. 字符串转义
- [ ] **所有引号正确转义**
  ```swift
  // ✅ 正确: "\""
  // ❌ 错误: """
  ```

### 3. 方法命名
- [ ] **没有重复的方法声明**
- [ ] **私有方法与公共方法不重名**

---

## ⚠️ 常见问题检查

### Combine框架
```swift
// ❌ 错误：缺少import Combine
import Foundation
import SwiftUI
class MyClass: ObservableObject { @Published var x = 1 }

// ✅ 正确
import Foundation
import SwiftUI
import Combine  // ← 必需
class MyClass: ObservableObject { @Published var x = 1 }
```

**检查方法**: 在Xcode中搜索 `ObservableObject`，确认对应文件顶部有 `import Combine`

### 字符串字面量
```swift
// ❌ 错误：未转义的引号
let text = """

// ✅ 正确：使用反斜杠
let text = "\""

// ✅ 正确：使用原始字符串（Swift 5+）
let text = #"""#
```

**检查方法**: 搜索所有 `"""` 和 `"""`，确认已正确转义

### Codable实现
```swift
// ⚠️ 警告：Color.Codable编码不完整
extension Color: Codable {
    public func encode(to encoder: Encoder) throws {
        // 这里无法获取RGB值
        // 建议改用String(hex)
    }
}
```

**检查方法**: 避免在Codable模型中使用SwiftUI.Color

---

## 🎯 最佳实践检查

### 命名规范
- [ ] 类名使用UpperCamelCase：`class BookmarkManager`
- [ ] 属性名使用lowerCamelCase：`var currentChapterIndex`
- [ ] 常量使用lowerCamelCase：`let userDefaultsKey`

### 文件组织
- [ ] 模型定义在 `Models/` 目录
- [ ] 视图定义在 `Views/` 目录
- [ ] 服务类定义在 `Services/` 目录
- [ ] 工具类定义在 `Utils/` 目录

### 导入顺序
```swift
// ✅ 推荐顺序
import Combine      // 1. 系统框架
import Foundation
import SwiftUI
import UIKit
```

---

## 🚀 提交前最终检查

- [ ] **编译通过**（最重要！）
- [ ] **核心功能已测试**
- [ ] **没有print调试语句残留**
- [ ] **代码已格式化**
- [ ] **注释清晰完整**
- [ ] **已更新相关文档**

---

## 📋 功能特定检查

### 新增Manager类
- [ ] 导入 `Combine`
- [ ] 继承 `ObservableObject`
- [ ] 使用 `@Published` 标记属性
- [ ] 实现单例模式（如需要）
- [ ] 实现 `load()` 和 `save()` 方法

### 新增UI视图
- [ ] 导入 `SwiftUI`
- [ ] 使用适当的属性包装器（`@State`, `@Binding`, `@StateObject`）
- [ ] 实现预览（`PreviewProvider`）
- [ ] 适配暗色模式

### 新增数据模型
- [ ] 遵守 `Codable` 协议
- [ ] 遵守 `Identifiable` 协议（如需要）
- [ ] 避免使用SwiftUI特定类型（如Color）
- [ ] 使用基础类型（String, Int, Double, Date等）

---

## 🐛 常见错误速查

| 错误信息 | 原因 | 解决方案 |
|---------|-----|---------|
| `Protocol requires property 'objectWillChange'` | 缺少Combine导入 | 添加 `import Combine` |
| `Multi-line string literal closing delimiter` | 字符串未正确转义 | 使用 `\"` 转义引号 |
| `Invalid redeclaration` | 方法重复声明 | 重命名私有方法 |
| `Generic parameter could not be inferred` | placeholder调用错误 | 使用overlay实现 |
| `Cannot convert value of type 'String' to 'Bool'` | placeholder参数错误 | 检查when:参数 |

---

## 📞 需要帮助？

如果遇到本清单未涵盖的问题：

1. 查看完整文档：`DEVELOPMENT_GUIDELINES.md`
2. 搜索项目现有代码中的类似实现
3. 咨询团队成员

---

**版本**: 1.0
**最后更新**: 2025-01-17
