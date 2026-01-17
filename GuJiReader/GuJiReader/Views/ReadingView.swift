//
//  ReadingView.swift
//  GuJiReader
//
//  阅读视图 - 专业级体验
//

import SwiftUI

struct ReadingView: View {
    let book: Book
    @State private var currentChapterIndex = 0
    @State private var showTableOfContents = false
    @State private var showSettings = false
    @State private var showBookmarkSheet = false
    @State private var settings = ReadingSettings.default
    @Environment(\.presentationMode) var presentationMode

    // 阅读进度管理
    @StateObject private var progressManager = ReadingProgressManager.shared
    @StateObject private var bookmarkManager = BookmarkManager.shared

    private var currentChapter: Chapter {
        book.chapters[currentChapterIndex]
    }

    // 当前章节是否有书签
    private var hasBookmark: Bool {
        bookmarkManager.hasBookmark(for: book.id, chapterIndex: currentChapterIndex)
    }

    // 根据设置转换繁简
    private var convertedContent: String {
        let content = currentChapter.content
        if settings.useTraditionalChinese {
            return ChineseConverter.shared.toTraditional(content)
        } else {
            return content
        }
    }

    var body: some View {
        ZStack {
            // 背景色
            settings.theme.backgroundColor
                .ignoresSafeArea()

            // 主内容
            VStack(spacing: 0) {
                // 顶部导航栏 - 清晰可见
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("返回")
                                .font(.system(size: 15))
                        }
                        .foregroundColor(settings.theme.textColor.opacity(0.8))
                    }

                    Spacer()

                    Text(book.title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(settings.theme.textColor.opacity(0.7))
                        .lineLimit(1)

                    Spacer()

                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "textformat.size")
                            .font(.system(size: 18))
                            .foregroundColor(settings.theme.textColor.opacity(0.8))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 8)

                // 章节标题
                VStack(spacing: 12) {
                    Text(currentChapter.title)
                        .font(.custom("Kaiti SC", size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(settings.theme.textColor)

                    HStack {
                        Text("第 \(currentChapterIndex + 1) 章")
                            .font(.system(size: 13))
                            .foregroundColor(settings.theme.textColor.opacity(0.6))
                        Text("/ \(book.chapters.count) 章")
                            .font(.system(size: 13))
                            .foregroundColor(settings.theme.textColor.opacity(0.6))
                    }
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 20)

                // 阅读内容 - 竖排
                ScrollView {
                    VerticalReadingView(
                        text: convertedContent,
                        fontSize: settings.fontSize,
                        textColor: settings.theme.textColor
                    )
                }

                // 底部控制栏
                HStack(spacing: 40) {
                    // 上一章
                    Button(action: previousChapter) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.up")
                                .font(.system(size: 14, weight: .semibold))
                            Text("上一章")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(currentChapterIndex > 0 ? settings.theme.textColor : settings.theme.textColor.opacity(0.3))
                    }
                    .disabled(currentChapterIndex == 0)

                    // 书签按钮
                    Button(action: {
                        if hasBookmark {
                            // 删除书签
                            if let bookmark = bookmarkManager.getBookmark(for: book.id, chapterIndex: currentChapterIndex) {
                                bookmarkManager.deleteBookmark(bookmark)
                            }
                        } else {
                            // 显示添加书签弹窗
                            showBookmarkSheet = true
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: hasBookmark ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 14, weight: .semibold))
                            Text(hasBookmark ? "已书签" : "书签")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(hasBookmark ? Color.blue : settings.theme.textColor)
                    }

                    // 目录
                    Button(action: { showTableOfContents = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 14, weight: .semibold))
                            Text("目录")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(settings.theme.textColor)
                    }

                    // 下一章
                    Button(action: nextChapter) {
                        HStack(spacing: 6) {
                            Text("下一章")
                                .font(.system(size: 14, weight: .medium))
                            Image(systemName: "chevron.down")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(currentChapterIndex < book.chapters.count - 1 ? settings.theme.textColor : settings.theme.textColor.opacity(0.3))
                    }
                    .disabled(currentChapterIndex == book.chapters.count - 1)
                }
                .padding(.vertical, 18)
                .background(settings.theme.backgroundColor.opacity(0.95))
                .overlay(
                    Rectangle()
                        .fill(settings.theme.textColor.opacity(0.1))
                        .frame(height: 0.5),
                    alignment: .top
                )
            }
        }
        .navigationBarHidden(true)
        .statusBar(hidden: false)
        .sheet(isPresented: $showTableOfContents) {
            TableOfContentsView(
                book: book,
                currentChapterIndex: $currentChapterIndex,
                isPresented: $showTableOfContents
            )
        }
        .sheet(isPresented: $showSettings) {
            ReadingSettingsView(settings: $settings)
        }
        .sheet(isPresented: $showBookmarkSheet) {
            AddBookmarkSheet(
                bookID: book.id,
                bookTitle: book.title,
                chapterIndex: currentChapterIndex,
                chapterTitle: currentChapter.title,
                content: currentChapter.content,
                isPresented: $showBookmarkSheet
            )
        }
        .onAppear {
            // 恢复阅读进度
            if let progress = progressManager.getProgress(for: book.id) {
                currentChapterIndex = progress.chapterIndex
                #if DEBUG
                print("✅ 恢复阅读进度：第\(currentChapterIndex + 1)章")
                #endif
            }
        }
        .onChange(of: currentChapterIndex) { newIndex in
            // 章节切换时保存进度
            saveReadingProgress()
        }
        .onDisappear {
            // 离开页面时保存进度
            saveReadingProgress()
        }
    }

    // MARK: - 保存阅读进度
    private func saveReadingProgress() {
        progressManager.saveProgress(
            bookID: book.id,
            bookTitle: book.title,
            chapterIndex: currentChapterIndex,
            chapterTitle: currentChapter.title
        )
    }

    private func previousChapter() {
        guard currentChapterIndex > 0 else { return }
        withAnimation { currentChapterIndex -= 1 }

        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }

    private func nextChapter() {
        guard currentChapterIndex < book.chapters.count - 1 else { return }
        withAnimation { currentChapterIndex += 1 }

        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}

// MARK: - 目录视图
struct TableOfContentsView: View {
    let book: Book
    @Binding var currentChapterIndex: Int
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            List {
                ForEach(Array(book.chapters.enumerated()), id: \.element.id) { index, chapter in
                    Button(action: {
                        currentChapterIndex = index
                        isPresented = false
                    }) {
                        HStack {
                            Text(chapter.title)
                                .font(.system(size: 16))
                                .foregroundColor(.primary)

                            if index == currentChapterIndex {
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("目录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        isPresented = false
                    }
                    .font(.system(size: 16))
                }
            }
        }
    }
}

// MARK: - 阅读设置视图
struct ReadingSettingsView: View {
    @Binding var settings: ReadingSettings
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("字号大小")
                                .font(.system(size: 16))
                            Spacer()
                            Text("\(settings.fontSize)")
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                        }

                        Slider(
                            value: Binding(
                                get: { Double(settings.fontSize) },
                                set: { settings.fontSize = Int($0) }
                            ),
                            in: 16...28,
                            step: 1
                        )

                        HStack {
                            Text("小")
                                .font(.system(size: 14))
                            Spacer()
                            Text("大")
                                .font(.system(size: 14))
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }

                Section(header: Text("繁简转换")) {
                    Toggle("显示为繁体字", isOn: Binding(
                        get: { settings.useTraditionalChinese },
                        set: { settings.useTraditionalChinese = $0 }
                    ))
                }

                Section(header: Text("阅读主题")) {
                    ForEach(ReadingTheme.allCases, id: \.self) { theme in
                        Button(action: {
                            settings.theme = theme
                        }) {
                            HStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(theme.backgroundColor)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(theme.textColor, lineWidth: 2)
                                    )

                                Text(theme.rawValue)
                                    .font(.system(size: 16))

                                Spacer()

                                if settings.theme == theme {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationTitle("阅读设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: 16))
                }
            }
        }
    }
}

struct ReadingView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingView(book: BookLibraryService.sampleBook)
    }
}
