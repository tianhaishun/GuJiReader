//
//  BookmarkManager.swift
//  GuJiReader
//
//  书签管理器 - 添加、删除、编辑书签
//

import Foundation
import SwiftUI
import Combine

/// 书签管理器
class BookmarkManager: ObservableObject {
    static let shared = BookmarkManager()

    @Published var bookmarks: [Bookmark] = []
    private let userDefaultsKey = "bookmarks"

    private init() {
        loadBookmarks()
    }

    // MARK: - 添加书签
    func addBookmark(
        bookID: String,
        bookTitle: String,
        chapterIndex: Int,
        chapterTitle: String,
        charOffset: Int = 0,
        content: String,
        note: String? = nil
    ) {
        // 检查是否已存在该书签
        let existingIndex = bookmarks.firstIndex { bookmark in
            bookmark.bookID == bookID &&
            bookmark.chapterIndex == chapterIndex
        }

        if let index = existingIndex {
            // 已存在，更新笔记
            bookmarks[index].note = note
            bookmarks[index].charOffset = charOffset
            saveToDisk()
            return
        }

        // 摘录原文片段（前50个字符）
        let excerpt = String(content.prefix(50))

        let bookmark = Bookmark(
            id: UUID().uuidString,
            bookID: bookID,
            bookTitle: bookTitle,
            chapterIndex: chapterIndex,
            chapterTitle: chapterTitle,
            charOffset: charOffset,
            excerpt: excerpt,
            note: note,
            createdAt: Date()
        )

        bookmarks.append(bookmark)
        saveToDisk()

        // 触发触觉反馈
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        #if DEBUG
        print("✅ 已添加书签：\(bookTitle) - \(chapterTitle)")
        #endif
    }

    // MARK: - 删除书签
    func deleteBookmark(_ bookmark: Bookmark) {
        bookmarks.removeAll { $0.id == bookmark.id }
        saveToDisk()

        // 触发触觉反馈
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)

        #if DEBUG
        print("🗑️ 已删除书签：\(bookmark.bookTitle)")
        #endif
    }

    // MARK: - 更新书签笔记
    func updateBookmarkNote(_ bookmark: Bookmark, note: String) {
        if let index = bookmarks.firstIndex(where: { $0.id == bookmark.id }) {
            bookmarks[index].note = note
            saveToDisk()
        }
    }

    // MARK: - 获取某本书的所有书签
    func getBookmarks(for bookID: String) -> [Bookmark] {
        return bookmarks
            .filter { $0.bookID == bookID }
            .sorted { $0.createdAt > $1.createdAt }
    }

    // MARK: - 检查当前章节是否有书签
    func hasBookmark(for bookID: String, chapterIndex: Int) -> Bool {
        return bookmarks.contains { $0.bookID == bookID && $0.chapterIndex == chapterIndex }
    }

    // MARK: - 获取当前章节的书签
    func getBookmark(for bookID: String, chapterIndex: Int) -> Bookmark? {
        return bookmarks.first { $0.bookID == bookID && $0.chapterIndex == chapterIndex }
    }

    // MARK: - 获取所有书签（按时间排序）
    func getAllBookmarks() -> [Bookmark] {
        return bookmarks.sorted { $0.createdAt > $1.createdAt }
    }

    // MARK: - 按书籍分组书签
    func getBookmarksByBook() -> [(bookTitle: String, bookmarks: [Bookmark])] {
        let grouped = Dictionary(grouping: bookmarks) { $0.bookTitle }
        return grouped.map { (bookTitle: $0.key, bookmarks: $0.value.sorted { $0.chapterIndex < $1.chapterIndex }) }
            .sorted { $0.bookTitle < $1.bookTitle }
    }

    // MARK: - 持久化
    private func saveToDisk() {
        if let data = try? JSONEncoder().encode(bookmarks) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    private func loadBookmarks() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let decoded = try? JSONDecoder().decode([Bookmark].self, from: data) else {
            return
        }
        bookmarks = decoded
    }
}

// MARK: - 书签卡片视图
struct BookmarkCard: View {
    var bookmark: Bookmark
    var onTap: (() -> Void)?
    var onDelete: (() -> Void)?
    var onEdit: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 书籍和章节信息
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(bookmark.bookTitle)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text("第\(bookmark.chapterIndex + 1)章 · \(bookmark.chapterTitle)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // 书签图标
                Image(systemName: "bookmark.fill")
                    .foregroundColor(.blue)
                    .font(.title3)
            }

            // 摘录内容
            if !bookmark.excerpt.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text(bookmark.excerpt)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.1))
                )
            }

            // 笔记（如有）
            if let note = bookmark.note, !note.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "note.text")
                        .font(.caption2)
                        .foregroundColor(.orange)

                    Text(note)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                }
            }

            // 底部信息
            HStack {
                Text("添加于 \(bookmark.createdAt, style: .relative)")
                    .font(.caption2)
                    .foregroundColor(.secondary)

                Spacer()

                // 操作按钮
                HStack(spacing: 16) {
                    if let edit = onEdit {
                        Button(action: edit) {
                            Image(systemName: "pencil")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }

                    if let delete = onDelete {
                        Button(action: delete) {
                            Image(systemName: "trash")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onTap?()
        }
    }
}

// MARK: - 添加书签弹窗
struct AddBookmarkSheet: View {
    var bookID: String
    var bookTitle: String
    var chapterIndex: Int
    var chapterTitle: String
    var content: String
    @Binding var isPresented: Bool

    @State private var note: String = ""
    @State private var isSaved = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("书签信息")) {
                    HStack {
                        Text("书籍")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(bookTitle)
                            .foregroundColor(.primary)
                    }

                    HStack {
                        Text("章节")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("第\(chapterIndex + 1)章 · \(chapterTitle)")
                            .foregroundColor(.primary)
                    }
                }

                Section(header: Text("笔记（可选）")) {
                    TextEditor(text: $note)
                        .frame(minHeight: 100)
                        .overlay(
                            Text("添加您的读书笔记...")
                                .foregroundColor(.secondary)
                                .padding(.leading, 4)
                                .opacity(note.isEmpty ? 1 : 0),
                            alignment: .topLeading
                        )
                }

                Section {
                    Button(action: saveBookmark) {
                        HStack {
                            Spacer()
                            if isSaved {
                                Image(systemName: "checkmark.circle.fill")
                                Text("已添加")
                            } else {
                                Image(systemName: "bookmark.fill")
                                Text("添加书签")
                            }
                            Spacer()
                        }
                    }
                    .foregroundColor(.blue)
                    .disabled(isSaved)
                }
            }
            .navigationTitle("添加书签")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        isPresented = false
                    }
                }
            }
        }
    }

    private func saveBookmark() {
        BookmarkManager.shared.addBookmark(
            bookID: bookID,
            bookTitle: bookTitle,
            chapterIndex: chapterIndex,
            chapterTitle: chapterTitle,
            content: content,
            note: note.isEmpty ? nil : note
        )
        isSaved = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isPresented = false
        }
    }
}

// MARK: - 书签列表视图
struct BookmarkListView: View {
    @StateObject private var bookmarkManager = BookmarkManager.shared
    @State private var selectedBookTitle: String?

    var body: some View {
        List {
            if bookmarkManager.bookmarks.isEmpty {
                // 空状态
                VStack(spacing: 16) {
                    Image(systemName: "bookmark.slash")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)

                    Text("还没有书签")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text("阅读时长按或点击书签按钮添加")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
            } else {
                // 按书籍分组显示
                ForEach(bookmarkManager.getBookmarksByBook(), id: \.bookTitle) { group in
                    Section(header: Text(group.bookTitle)) {
                        ForEach(group.bookmarks) { bookmark in
                            BookmarkCard(bookmark: bookmark) {
                                // 点击书签跳转（需要实现）
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("我的书签")
    }
}
