//
//  BookDetailView.swift
//  GuJiReader
//
//  书籍详情视图 - 古代牌匾风格
//

import SwiftUI

struct BookDetailView: View {
    let book: Book
    @EnvironmentObject var libraryService: BookLibraryService
    @State private var isReading = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            // 宣纸背景
            Color(red: 0.98, green: 0.97, blue: 0.95)
                .overlay(
                    Canvas { context, size in
                        for _ in 0..<600 {
                            let startX = CGFloat.random(in: 0...size.width)
                            let startY = CGFloat.random(in: 0...size.height)
                            let length = CGFloat.random(in: 2...10)
                            let angle = CGFloat.random(in: 0...2 * .pi)

                            var path = Path()
                            path.move(to: CGPoint(x: startX, y: startY))
                            path.addLine(
                                to: CGPoint(
                                    x: startX + cos(angle) * length,
                                    y: startY + sin(angle) * length
                                )
                            )

                            context.stroke(
                                path,
                                with: .color(Color(red: 0.3, green: 0.25, blue: 0.2).opacity(0.012)),
                                lineWidth: 0.5
                            )
                        }
                    }
                )

            ScrollView {
                VStack(spacing: 0) {
                    // 顶部返回按钮 - 纯文字
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("返")
                                .font(.custom("Kaiti SC", size: 16))
                                .fontWeight(.light)
                                .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.6))
                        }

                        Spacer()

                        // 下载按钮 - 印章风格
                        Button(action: toggleDownload) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(book.isDownloaded ? Color(red: 0.5, green: 0.5, blue: 0.5).opacity(0.5) : Color(red: 0.7, green: 0.15, blue: 0.15).opacity(0.6), lineWidth: 1.2)
                                    .frame(width: 45, height: 45)

                                Text(book.isDownloaded ? "藏" : "收")
                                    .font(.custom("Kaiti SC", size: 18))
                                    .fontWeight(.medium)
                                    .foregroundColor(book.isDownloaded ? Color(red: 0.5, green: 0.5, blue: 0.5).opacity(0.7) : Color(red: 0.7, green: 0.15, blue: 0.15).opacity(0.8))
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 15)
                    .padding(.bottom, 20)

                    // 书籍展示 - 古籍线装书风格
                    VStack(spacing: 25) {
                        // 书籍封面 - 竖排版式
                        ZStack {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(hex: book.coverColor))
                                .frame(width: 160, height: 240)
                                .shadow(color: Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.15), radius: 8, x: 0, y: 4)

                            // 竖排书名
                            VStack(spacing: 0) {
                                ForEach(Array(book.title.map { String($0) }), id: \.self) { char in
                                    Text(char)
                                        .font(.custom("Kaiti SC", size: 20))
                                        .fontWeight(.light)
                                        .foregroundColor(.white.opacity(0.95))
                                        .lineLimit(1)
                                }
                            }
                            .padding(.top, 25)

                            // 作者名 - 竖排小字
                            VStack(spacing: 0) {
                                ForEach(Array(book.author.map { String($0) }), id: \.self) { char in
                                    Text(char)
                                        .font(.custom("Kaiti SC", size: 11))
                                        .fontWeight(.ultraLight)
                                        .foregroundColor(.white.opacity(0.7))
                                        .lineLimit(1)
                                }
                            }
                            .padding(.bottom, 25)
                            .padding(.trailing, 12)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }

                        // 书籍信息 - 古代文书风格
                        VStack(alignment: .leading, spacing: 12) {
                            // 书名
                            Text(book.title)
                                .font(.custom("Kaiti SC", size: 28))
                                .fontWeight(.medium)
                                .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08))
                                .tracking(3)

                            // 作者
                            Text(book.author)
                                .font(.custom("Kaiti SC", size: 14))
                                .fontWeight(.light)
                                .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.6))
                                .tracking(2)

                            // 分类和章节数
                            HStack(spacing: 15) {
                                HStack(spacing: 6) {
                                    Rectangle()
                                        .fill(Color(red: 0.7, green: 0.15, blue: 0.15).opacity(0.6))
                                        .frame(width: 1, height: 12)

                                    Text(book.category.rawValue)
                                        .font(.custom("Kaiti SC", size: 11))
                                        .fontWeight(.light)
                                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.5))
                                }

                                HStack(spacing: 6) {
                                    Rectangle()
                                        .fill(Color(red: 0.7, green: 0.15, blue: 0.15).opacity(0.6))
                                        .frame(width: 1, height: 12)

                                    Text("\(book.chapters.count)章")
                                        .font(.custom("Kaiti SC", size: 11))
                                        .fontWeight(.light)
                                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.5))
                                }
                            }
                        }
                    }
                    .padding(.vertical, 30)

                    // 分隔线
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.15),
                                    Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.02),
                                    Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.15)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 1)
                        .padding(.horizontal, 40)

                    // 作品简介
                    VStack(alignment: .leading, spacing: 15) {
                        Text("提要")
                            .font(.custom("Kaiti SC", size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.7))
                            .tracking(3)

                        Text(book.description)
                            .font(.custom("Kaiti SC", size: 13))
                            .fontWeight(.light)
                            .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.8))
                            .lineSpacing(6)
                            .tracking(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 30)
                    .padding(.horizontal, 35)

                    // 目录
                    VStack(alignment: .leading, spacing: 15) {
                        Text("目录")
                            .font(.custom("Kaiti SC", size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.7))
                            .tracking(3)

                        VStack(spacing: 0) {
                            ForEach(Array(book.chapters.prefix(8).enumerated()), id: \.element.id) { index, chapter in
                                HStack {
                                    Text("\(index + 1)")
                                        .font(.custom("Kaiti SC", size: 11))
                                        .fontWeight(.light)
                                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.4))

                                    Text(chapter.title)
                                        .font(.custom("Kaiti SC", size: 13))
                                        .fontWeight(.light)
                                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.8))

                                    Spacer()
                                }
                                .padding(.vertical, 10)

                                if index < min(7, book.chapters.count - 1) {
                                    Rectangle()
                                        .fill(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.06))
                                        .frame(height: 1)
                                }
                            }

                            if book.chapters.count > 8 {
                                Text("共\(book.chapters.count)章")
                                    .font(.custom("Kaiti SC", size: 11))
                                    .fontWeight(.light)
                                    .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.4))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 15)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 30)
                    .padding(.horizontal, 35)
                    .padding(.bottom, 120)
                }
            }

            // 底部阅读按钮 - 印章风格
            VStack {
                Spacer()

                Button(action: { isReading = true }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(red: 0.7, green: 0.15, blue: 0.15).opacity(0.85))
                            .frame(height: 55)

                        HStack(spacing: 10) {
                            Text("阅")
                            Text("读")
                        }
                        .font(.custom("Kaiti SC", size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.95))
                        .tracking(8)
                    }
                }
                .padding(.horizontal, 35)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .background(
            NavigationLink(
                destination: PaginatedReadingView(book: book),
                isActive: $isReading,
                label: { EmptyView() }
            )
        )
    }

    private func toggleDownload() {
        if book.isDownloaded {
            libraryService.removeBook(book)
        } else {
            libraryService.downloadBook(book)
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(book: BookLibraryService.sampleBook)
    }
}
