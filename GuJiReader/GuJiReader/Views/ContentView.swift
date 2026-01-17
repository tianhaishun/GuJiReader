//
//  ContentView.swift
//  GuJiReader
//
//  主视图 - 极简中国美学
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var selectedTab = 0
    @StateObject private var libraryService = BookLibraryService.shared

    var body: some View {
        if !isLoggedIn {
            LoginView(onLoginSuccess: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoggedIn = true
                }
            })
        } else {
            TabView(selection: $selectedTab) {
                BookListView()
                    .tabItem {
                        Text("书库")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .tag(0)

                MyBookshelfView()
                    .tabItem {
                        Text("书架")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .tag(1)

                ProfileView()
                    .tabItem {
                        Text("我的")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .tag(2)
            }
            .onAppear {
                // 设置TabBar外观
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor(red: 0.97, green: 0.96, blue: 0.94, alpha: 1.0)

                // 正常状态文字颜色
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                    .foregroundColor: UIColor.black.withAlphaComponent(0.4),
                    .font: UIFont.systemFont(ofSize: 12, weight: .medium)
                ]

                // 选中状态文字颜色
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                    .foregroundColor: UIColor.black,
                    .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
                ]

                // 边缘布局外观
                appearance.inlineLayoutAppearance.normal.titleTextAttributes = [
                    .foregroundColor: UIColor.black.withAlphaComponent(0.4),
                    .font: UIFont.systemFont(ofSize: 12, weight: .medium)
                ]

                appearance.inlineLayoutAppearance.selected.titleTextAttributes = [
                    .foregroundColor: UIColor.black,
                    .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
                ]

                // 条形布局外观
                appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [
                    .foregroundColor: UIColor.black.withAlphaComponent(0.4),
                    .font: UIFont.systemFont(ofSize: 12, weight: .medium)
                ]

                appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [
                    .foregroundColor: UIColor.black,
                    .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
                ]

                UITabBar.appearance().standardAppearance = appearance
                if #available(iOS 15.0, *) {
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
            }
            .environmentObject(libraryService)
        }
    }
}

// MARK: - 书库列表视图（极简设计）
struct BookListView: View {
    @EnvironmentObject var libraryService: BookLibraryService
    @State private var selectedCategory: BookCategory = .classic
    @StateObject private var progressManager = ReadingProgressManager.shared
    @State private var navigateToReading: Bool = false
    @State private var selectedBook: Book?

    var body: some View {
        NavigationView {
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

                VStack(spacing: 0) {
                    // 顶部标题区 - 极简书法
                    VStack(alignment: .leading, spacing: 5) {
                        Text("藏书")
                            .font(.custom("Kaiti SC", size: 48))
                            .fontWeight(.ultraLight)
                            .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08))
                            .tracking(10)

                        HStack(spacing: 8) {
                            Text("共")
                            Text("\(libraryService.allBooks.count)")
                            Text("部")
                        }
                        .font(.custom("Kaiti SC", size: 12))
                        .fontWeight(.light)
                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.4))
                        .tracking(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 30)
                    .padding(.top, 25)
                    .padding(.bottom, 25)

                    // 继续阅读卡片
                    if let lastProgress = progressManager.getLastReadBook(),
                       let book = libraryService.allBooks.first(where: { $0.id == lastProgress.bookID }) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("继续阅读")
                                .font(.custom("Kaiti SC", size: 14))
                                .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.5))
                                .padding(.leading, 30)

                            ContinueReadingCard(progress: lastProgress) {
                                selectedBook = book
                                navigateToReading = true
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 15)
                    }

                    // 分类选择器 - 纯文字
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 30) {
                            ForEach(BookCategory.allCases, id: \.self) { category in
                                Button(action: {
                                    withAnimation(.easeOut(duration: 0.4)) {
                                        selectedCategory = category
                                    }
                                }) {
                                    Text(category.rawValue)
                                        .font(.custom("Kaiti SC", size: selectedCategory == category ? 16 : 14))
                                        .fontWeight(selectedCategory == category ? .medium : .light)
                                        .foregroundColor(selectedCategory == category ? Color(red: 0.15, green: 0.12, blue: 0.08) : Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.35))
                                        .tracking(4)
                                        .overlay(
                                            selectedCategory == category ?
                                            Rectangle()
                                                .fill(Color(red: 0.7, green: 0.15, blue: 0.15).opacity(0.6))
                                                .frame(height: 2)
                                                .offset(y: 5)
                                            : nil
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                    .padding(.bottom, 20)

                    // 分隔线 - 水墨渐变
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.1),
                                    Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.02),
                                    Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.1)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 1)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)

                    // 书籍列表 - 极简古籍卡片
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 20),
                            GridItem(.flexible(), spacing: 20)
                        ], spacing: 20) {
                            ForEach(filteredBooks) { book in
                                NavigationLink(destination: BookDetailView(book: book)) {
                                    AncientBookCard(book: book)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .background(
                NavigationLink(
                    destination: selectedBook.map { ReadingView(book: $0) },
                    isActive: $navigateToReading,
                    label: { EmptyView() }
                )
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var filteredBooks: [Book] {
        libraryService.allBooks.filter { $0.category == selectedCategory }
    }
}

// MARK: - 古籍卡片（宋代美学）
struct AncientBookCard: View {
    let book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 书籍封面 - 古籍线装书风格
            ZStack {
                // 宣纸质感
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(hex: book.coverColor))
                    .frame(height: 200)

                // 竖排书名
                VStack(spacing: 0) {
                    ForEach(Array(book.title.map { String($0) }), id: \.self) { char in
                        Text(char)
                            .font(.custom("Kaiti SC", size: 18))
                            .fontWeight(.light)
                            .foregroundColor(.white.opacity(0.95))
                            .lineLimit(1)
                    }
                }
                .padding(.top, 20)

                // 作者名 - 竖排小字
                VStack(spacing: 0) {
                    ForEach(Array(book.author.map { String($0) }), id: \.self) { char in
                        Text(char)
                            .font(.custom("Kaiti SC", size: 10))
                            .fontWeight(.ultraLight)
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(1)
                    }
                }
                .padding(.bottom, 20)
                .padding(.trailing, 15)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }

            // 书籍信息 - 极简
            VStack(alignment: .leading, spacing: 6) {
                Text(book.title)
                    .font(.custom("Kaiti SC", size: 15))
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08))
                    .lineLimit(1)

                Text(book.author)
                    .font(.custom("Kaiti SC", size: 11))
                    .fontWeight(.light)
                    .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.5))

                HStack(spacing: 10) {
                    Text(book.category.rawValue)
                        .font(.custom("Kaiti SC", size: 9))
                        .fontWeight(.light)
                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.35))

                    Rectangle()
                        .fill(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.2))
                        .frame(width: 1, height: 8)

                    Text("\(book.chapters.count)章")
                        .font(.custom("Kaiti SC", size: 9))
                        .fontWeight(.light)
                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.35))
                }
            }
        }
    }
}

// MARK: - 我的书架视图（藏书楼风格）
struct MyBookshelfView: View {
    @EnvironmentObject var libraryService: BookLibraryService

    var body: some View {
        NavigationView {
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

                Group {
                    if libraryService.downloadedBooks.isEmpty {
                        // 空状态 - 古代书法
                        VStack(spacing: 30) {
                            Text("书架空虚")
                                .font(.custom("Kaiti SC", size: 24))
                                .fontWeight(.ultraLight)
                                .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.4))
                                .tracking(5)

                            VStack(spacing: 12) {
                                Text("移步入藏书阁")
                                Text("择善本而藏之")
                            }
                            .font(.custom("Kaiti SC", size: 13))
                            .fontWeight(.light)
                            .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.35))
                            .tracking(2)
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 20),
                                GridItem(.flexible(), spacing: 20)
                            ], spacing: 20) {
                                ForEach(libraryService.downloadedBooks) { book in
                                    NavigationLink(destination: BookDetailView(book: book)) {
                                        AncientBookCard(book: book)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 30)
                            .padding(.top, 20)
                        }
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Color 扩展
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
