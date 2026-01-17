//
//  Models.swift
//  GuJiReader
//
//  数据模型定义
//

import Foundation

// MARK: - 用户模型
struct User: Codable {
    var id: String
    var username: String
    var email: String
    var downloadedBooks: [String] // 已下载书籍ID列表

    static let current = User(
        id: "user_001",
        username: "读者",
        email: "reader@guji.com",
        downloadedBooks: []
    )
}

// MARK: - 书籍模型
struct Book: Identifiable, Codable {
    var id: String
    var title: String
    var author: String
    var description: String
    var category: BookCategory
    var coverColor: String
    var chapters: [Chapter]
    var isDownloaded: Bool

    var coverImage: String {
        return "book_\(id)"
    }
}

// MARK: - 章节模型
struct Chapter: Identifiable, Codable {
    var id: String
    var title: String
    var content: String
    var order: Int
}

// MARK: - 书签模型
struct Bookmark: Identifiable, Codable {
    var id: String
    var bookID: String
    var bookTitle: String
    var chapterIndex: Int
    var chapterTitle: String
    var charOffset: Int  // 字符位置偏移
    var excerpt: String  // 自动摘录原文片段（前50个字符）
    var note: String?    // 可选笔记
    var createdAt: Date
}

// MARK: - 书籍分类
enum BookCategory: String, CaseIterable, Codable {
    case classic = "经典"
    case history = "历史"
    case philosophy = "哲学"
    case literature = "文学"
    case poetry = "诗词"

    var icon: String {
        switch self {
        case .classic: return "book.fill"
        case .history: return "scroll.fill"
        case .philosophy: return "lightbulb.fill"
        case .literature: return "text.book.closed.fill"
        case .poetry: return "quote.bubble.fill"
        }
    }
}

// MARK: - 阅读主题（张艺谋电影风格）
enum ReadingTheme: String, CaseIterable, Codable {
    case ricePaper = "宣纸"
    case white = "白纸"
    case vintage = "复古"
    case night = "夜间"

    var backgroundColor: Color {
        switch self {
        case .ricePaper:
            // 温暖的米黄色，像陈年宣纸
            return Color(red: 0.94, green: 0.91, blue: 0.86)
        case .white:
            // 纯净白色，带极淡的暖色
            return Color(red: 0.98, green: 0.98, blue: 0.96)
        case .vintage:
            // 复古褐色，像古书
            return Color(red: 0.85, green: 0.78, blue: 0.68)
        case .night:
            // 深邃夜色，护眼
            return Color(red: 0.12, green: 0.12, blue: 0.14)
        }
    }

    var textColor: Color {
        switch self {
        case .ricePaper:
            // 浓墨色，接近黑色但不生硬
            return Color(red: 0.18, green: 0.15, blue: 0.12)
        case .white:
            // 柔和黑色
            return Color(red: 0.2, green: 0.2, blue: 0.2)
        case .vintage:
            // 深褐色
            return Color(red: 0.25, green: 0.18, blue: 0.12)
        case .night:
            // 护眼米色
            return Color(red: 0.82, green: 0.82, blue: 0.78)
        }
    }

    var accentColor: Color {
        switch self {
        case .ricePaper:
            return Color(red: 0.55, green: 0.35, blue: 0.2)
        case .white:
            return Color(red: 0.3, green: 0.4, blue: 0.6)
        case .vintage:
            return Color(red: 0.5, green: 0.3, blue: 0.15)
        case .night:
            return Color(red: 0.4, green: 0.55, blue: 0.7)
        }
    }
}

// MARK: - 翻页动画类型
enum PageTransitionStyle: String, CaseIterable, Codable {
    case slide = "滑动"
    case fade = "渐隐"
    case flip = "翻书"

    var icon: String {
        switch self {
        case .slide: return "arrow.right.square.fill"
        case .fade: return "circle.circle"
        case .flip: return "book.fill"
        }
    }
}

// MARK: - 阅读设置
struct ReadingSettings: Codable {
    var fontSize: Int
    var theme: ReadingTheme
    var transitionStyle: PageTransitionStyle
    var transitionDuration: Double
    var useTraditionalChinese: Bool  // 是否使用繁体字

    static let `default` = ReadingSettings(
        fontSize: 20,
        theme: .ricePaper,
        transitionStyle: .slide,
        transitionDuration: 0.3,
        useTraditionalChinese: false
    )
}

// 需要导入 SwiftUI
import SwiftUI

// 扩展 Color 让它支持 Codable
extension Color: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)
        self.init(red: r, green: g, blue: b)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // 注意：这里无法获取Color的RGB值，因为Color不提供这个接口
        // 如果需要序列化Color，建议使用UIColor或CGColor
        // 当前实现：仅用于解码，编码时会跳过
        // 更好的方案是在模型中使用String（hex）代替Color
    }

    enum CodingKeys: String, CodingKey {
        case red, green, blue
    }
}
