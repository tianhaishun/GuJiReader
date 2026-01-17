//
//  ReadingProgressManager.swift
//  GuJiReader
//
//  阅读进度管理器 - 自动保存和恢复阅读位置
//

import Foundation
import SwiftUI
import Combine

/// 阅读进度数据模型
struct ReadingProgress: Codable, Identifiable {
    var id: String  // bookID
    var bookID: String
    var bookTitle: String
    var chapterIndex: Int
    var chapterTitle: String
    var scrollOffset: CGFloat  // 滚动位置（可选，未来扩展）
    var lastReadTime: Date
    var readingTime: Int  // 累计阅读时长（秒）
}

/// 阅读进度管理器
class ReadingProgressManager: ObservableObject {
    static let shared = ReadingProgressManager()

    @Published var readingProgress: [String: ReadingProgress] = [:]  // bookID -> progress
    private let userDefaultsKey = "readingProgress"

    private init() {
        loadProgress()
    }

    // MARK: - 保存阅读进度
    func saveProgress(
        bookID: String,
        bookTitle: String,
        chapterIndex: Int,
        chapterTitle: String,
        scrollOffset: CGFloat = 0
    ) {
        let progress = ReadingProgress(
            id: bookID,
            bookID: bookID,
            bookTitle: bookTitle,
            chapterIndex: chapterIndex,
            chapterTitle: chapterTitle,
            scrollOffset: scrollOffset,
            lastReadTime: Date(),
            readingTime: getReadingTime(for: bookID) + 1  // 每次保存增加1秒
        )

        readingProgress[bookID] = progress
        saveToDisk()

        #if DEBUG
        print("✅ 已保存阅读进度：\(bookTitle) - 第\(chapterIndex + 1)章")
        #endif
    }

    // MARK: - 获取阅读进度
    func getProgress(for bookID: String) -> ReadingProgress? {
        return readingProgress[bookID]
    }

    // MARK: - 获取上次阅读的书籍
    func getLastReadBook() -> ReadingProgress? {
        guard !readingProgress.isEmpty else { return nil }

        // 按最后阅读时间排序
        let sorted = readingProgress.values
            .sorted { $0.lastReadTime > $1.lastReadTime }

        return sorted.first
    }

    // MARK: - 获取所有阅读进度
    func getAllProgress() -> [ReadingProgress] {
        return readingProgress.values
            .sorted { $0.lastReadTime > $1.lastReadTime }
    }

    // MARK: - 删除阅读进度
    func deleteProgress(for bookID: String) {
        readingProgress.removeValue(forKey: bookID)
        saveToDisk()
    }

    // MARK: - 清除所有进度
    func clearAllProgress() {
        readingProgress.removeAll()
        saveToDisk()
    }

    // MARK: - 获取累计阅读时长
    func getReadingTime(for bookID: String) -> Int {
        return readingProgress[bookID]?.readingTime ?? 0
    }

    // MARK: - 格式化阅读时长
    func formatReadingTime(_ seconds: Int) -> String {
        if seconds < 60 {
            return "\(seconds)秒"
        } else if seconds < 3600 {
            let minutes = seconds / 60
            return "\(minutes)分钟"
        } else {
            let hours = seconds / 3600
            let minutes = (seconds % 3600) / 60
            return minutes > 0 ? "\(hours)小时\(minutes)分钟" : "\(hours)小时"
        }
    }

    // MARK: - 持久化
    private func saveToDisk() {
        if let data = try? JSONEncoder().encode(readingProgress) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    private func loadProgress() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let decoded = try? JSONDecoder().decode([String: ReadingProgress].self, from: data) else {
            return
        }
        readingProgress = decoded
    }
}

// MARK: - 扩展：继续阅读卡片
struct ContinueReadingCard: View {
    var progress: ReadingProgress
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "book.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("继续阅读")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(progress.bookTitle)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("第\(progress.chapterIndex + 1)章")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(progress.chapterTitle)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }

                // 进度指示器
                HStack(spacing: 8) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text("上次阅读：\(progress.lastReadTime, style: .relative)")
                        .font(.caption2)
                }
                .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
