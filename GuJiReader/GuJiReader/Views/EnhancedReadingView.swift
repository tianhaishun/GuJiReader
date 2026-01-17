//
//  EnhancedReadingView.swift
//  GuJiReader
//
//  宋代美学阅读页 - 雅致、留白、质朴
//  核心理念：计白当黑，大美无言
//

import SwiftUI

/// 增强版阅读视图 - 宋代极简美学
struct EnhancedReadingView: View {
    let book: Book
    let chapter: Chapter
    @Binding var currentPageIndex: Int
    @Binding var showMenu: Bool

    @State private var dragOffset: CGFloat = 0
    @State private var dragAmount: CGFloat = 0
    @State private var isDragging: Bool = false
    @State private var showPageTransition: Bool = false

    // 阅读设置
    @State private var settings = ReadingSettings.default

    // 翻页方向
    enum PageDirection {
        case next, previous
    }

    var body: some View {
        ZStack {
            // 1. 背景层 - 宋代汝窑配色 + 宣纸纹理
            songDynastyBackground
                .ignoresSafeArea()

            // 2. 主内容层
            GeometryReader { geometry in
                ZStack {
                    // 当前页
                    pageContent
                        .offset(x: dragOffset)
                        .scaleEffect(isDragging ? 0.95 : 1.0)
                        .opacity(showPageTransition ? 0 : 1)
                        .animation(.easeOut(duration: 0.3), value: showPageTransition)

                    // 下一页（预加载效果）
                    if dragOffset < -50 {
                        nextPageContent
                            .offset(x: dragOffset + geometry.size.width)
                            .opacity(Double(min(abs(dragOffset) / 200, 1)))
                    }

                    // 上一页（预加载效果）
                    if dragOffset > 50 {
                        previousPageContent
                            .offset(x: dragOffset - geometry.size.width)
                            .opacity(Double(min(abs(dragOffset) / 200, 1)))
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation(.interactiveSpring()) {
                                isDragging = true
                                dragOffset = value.translation.width
                                dragAmount = value.translation.width
                            }
                        }
                        .onEnded { value in
                            handleGestureEnd(value: value, geometry: geometry)
                        }
                )
                . onTapGesture(count: 1) { location in
                    handleTap(at: location, in: geometry)
                }
            }

            // 3. 顶部菜单（淡入淡出）
            if showMenu {
                topMenu
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            // 4. 底部菜单（淡入淡出）
            if showMenu {
                bottomMenu
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            // 5. 阅读进度指示器（左侧边距）
            readingProgressIndicator
        }
        .statusBar(hidden: !showMenu)
        .animation(.easeInOut(duration: 0.25), value: showMenu)
    }

    // MARK: - 背景层（宋代美学）
    private var songDynastyBackground: some View {
        ZStack {
            // 基础色 - 仿宣纸米黄色
            Color(red: 0.96, green: 0.94, blue: 0.90)

            // 纸张纹理层 - 极致细腻
            Canvas { context, size in
                // 细微纤维纹理（模拟宣纸）
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

                    // 淡墨色纹理 - 极淡
                    context.stroke(
                        path,
                        with: .color(Color(red: 0.2, green: 0.15, blue: 0.1).opacity(0.008)),
                        lineWidth: 0.3
                    )
                }

                // 斑点纹理（增加纸质感）
                for _ in 0..<400 {
                    let x = CGFloat.random(in: 0...size.width)
                    let y = CGFloat.random(in: 0...size.height)
                    let radius = CGFloat.random(in: 0.3...1.5)

                    context.fill(
                        Path(ellipseIn: CGRect(x: x, y: y, width: radius * 2, height: radius * 2)),
                        with: .color(Color(red: 0.3, green: 0.25, blue: 0.2).opacity(0.012))
                    )
                }

                // 边缘暗角（营造书页感）
                let gradientColors = [
                    Color(red: 0.85, green: 0.82, blue: 0.76).opacity(0.15),
                    Color.clear,
                    Color.clear,
                    Color(red: 0.85, green: 0.82, blue: 0.76).opacity(0.15)
                ]

                let gradient = Gradient(stops: [
                    Gradient.Stop(color: gradientColors[0], location: 0),
                    Gradient.Stop(color: gradientColors[1], location: 0.15),
                    Gradient.Stop(color: gradientColors[2], location: 0.85),
                    Gradient.Stop(color: gradientColors[3], location: 1)
                ])

                let rect = CGRect(origin: .zero, size: size)
                context.fill(
                    Path(rect),
                    with: .linearGradient(
                        gradient,
                        startPoint: CGPoint(x: 0, y: size.height / 2),
                        endPoint: CGPoint(x: size.width, y: size.height / 2)
                    )
                )
            }
        }
    }

    // MARK: - 页面内容
    private var pageContent: some View {
        VStack(spacing: 0) {
            // 顶部留白 - 呼吸空间
            Spacer()
                .frame(height: 120)

            // 章节标题 - 宋刻本风格
            chapterTitle

            // 分割线 - 极细淡墨
            Rectangle()
                .fill(Color(red: 0.2, green: 0.15, blue: 0.1).opacity(0.15))
                .frame(width: 60, height: 1)
                .padding(.vertical, 24)

            // 正文内容 - 楷体/宋体
            chapterContent

            // 底部留白
            Spacer()
                .frame(height: 180)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 48) // 大幅增加左右留白
    }

    // MARK: - 章节标题
    private var chapterTitle: some View {
        Text(chapter.title)
            .font(.custom("Songti SC", size: 32)) // 宋体 - 人文气息
            .fontWeight(.medium)
            .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1)) // 淡墨色
            .lineSpacing(8)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
    }

    // MARK: - 正文内容
    private var chapterContent: some View {
        ScrollView(showsIndicators: false) {
            Text(chapter.content)
                .font(.custom("Kaiti SC", size: CGFloat(settings.fontSize))) // 楷体
                .fontWeight(.light)
                .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1)) // 淡墨色
                .lineSpacing(CGFloat(settings.fontSize) * 1.8) // 行间距 1.8倍
                .kerning(0.8) // 字间距 - 增加空气感
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
        }
    }

    // MARK: - 顶部菜单
    private var topMenu: some View {
        VStack(spacing: 0) {
            HStack {
                // 返回按钮
                Button(action: { /* 返回逻辑 */ }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                        .frame(width: 44, height: 44)
                }

                Spacer()

                // 书名
                Text(book.title)
                    .font(.custom("Songti SC", size: 17))
                    .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1).opacity(0.8))

                Spacer()

                // 设置按钮
                Button(action: { /* 打开设置 */ }) {
                    Image(systemName: "textformat.size")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1).opacity(0.8))
                        .frame(width: 44, height: 44)
                }
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
    }

    // MARK: - 底部菜单
    private var bottomMenu: some View {
        VStack(spacing: 0) {
            // 进度条
            VStack(spacing: 8) {
                // 章节滑块
                HStack(spacing: 12) {
                    Text("第 \(currentPageIndex + 1) 章")
                        .font(.custom("Songti SC", size: 13))
                        .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1).opacity(0.6))

                    Slider(
                        value: Binding(
                            get: { Double(currentPageIndex) },
                            set: { currentPageIndex = Int($0) }
                        ),
                        in: 0...Double(book.chapters.count - 1),
                        step: 1
                    )
                    .tint(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.6))

                    Text("共 \(book.chapters.count) 章")
                        .font(.custom("Songti SC", size: 13))
                        .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1).opacity(0.6))
                }
                .padding(.horizontal, 32)

                // 进度信息
                Text("阅读进度：\(Int((Double(currentPageIndex + 1) / Double(book.chapters.count)) * 100))%")
                    .font(.custom("Songti SC", size: 12))
                    .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1).opacity(0.4))
            }
            .padding(.top, 16)

            // 分割线
            Rectangle()
                .fill(Color(red: 0.2, green: 0.15, blue: 0.1).opacity(0.1))
                .frame(height: 0.5)
                .padding(.horizontal, 24)

            // 底部工具栏
            HStack(spacing: 0) {
                // 上一章
                Button(action: { goToPreviousChapter() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.up")
                        Text("上一章")
                    }
                    .font(.custom("Songti SC", size: 14))
                    .foregroundColor(currentPageIndex > 0 ? Color(red: 0.2, green: 0.15, blue: 0.1) : Color(red: 0.2, green: 0.15, blue: 0.1).opacity(0.3))
                }
                .disabled(currentPageIndex == 0)

                Spacer()

                // 书签
                Button(action: { /* 书签功能 */ }) {
                    VStack(spacing: 4) {
                        Image(systemName: "bookmark")
                        Text("书签")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                }
                .frame(width: 60)

                Spacer()

                // 目录
                Button(action: { /* 目录功能 */ }) {
                    VStack(spacing: 4) {
                        Image(systemName: "list.bullet")
                        Text("目录")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                }
                .frame(width: 60)

                Spacer()

                // 下一章
                Button(action: { goToNextChapter() }) {
                    HStack(spacing: 6) {
                        Text("下一章")
                        Image(systemName: "chevron.down")
                    }
                    .font(.custom("Songti SC", size: 14))
                    .foregroundColor(currentPageIndex < book.chapters.count - 1 ? Color(red: 0.2, green: 0.15, blue: 0.1) : Color(red: 0.2, green: 0.15, blue: 0.1).opacity(0.3))
                }
                .disabled(currentPageIndex == book.chapters.count - 1)
            }
            .padding(.horizontal, 32)
            .padding(.top, 12)
            .padding(.bottom, 24)
            .background(
                Color(red: 0.96, green: 0.94, blue: 0.90)
                    .opacity(0.95)
                    .blur(radius: 1)
            )
        }
    }

    // MARK: - 阅读进度指示器
    private var readingProgressIndicator: some View {
        VStack {
            GeometryReader { geometry in
                VStack(spacing: 4) {
                    ForEach(0..<book.chapters.count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 1)
                            .fill(index <= currentPageIndex ?
                                  Color(red: 0.2, green: 0.15, blue: 0.1).opacity(0.2) :
                                  Color(red: 0.2, green: 0.15, blue: 0.1).opacity(0.05))
                            .frame(width: 2, height: 3)
                    }
                }
                .frame(maxHeight: geometry.size.height * 0.4)
                .padding(.leading, 16)
            }
            Spacer()
        }
    }

    // MARK: - 交互处理

    /// 处理点击手势
    private func handleTap(at location: CGPoint, in geometry: GeometryProxy) {
        let screenWidth = geometry.size.width
        let screenHeight = geometry.size.height

        // 左右20%区域：翻页
        // 中间60%区域：呼出菜单
        let leftThreshold = screenWidth * 0.2
        let rightThreshold = screenWidth * 0.8

        if location.x < leftThreshold {
            // 点击左侧 - 上一页
            goToPreviousChapter()
        } else if location.x > rightThreshold {
            // 点击右侧 - 下一页
            goToNextChapter()
        } else {
            // 点击中间 - 呼出/隐藏菜单
            withAnimation(.easeInOut(duration: 0.25)) {
                showMenu.toggle()
            }
        }

        // 触觉反馈
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }

    /// 处理拖拽手势结束
    private func handleGestureEnd(value: DragGesture.Value, geometry: GeometryProxy) {
        let threshold: CGFloat = 100

        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isDragging = false

            if dragAmount < -threshold {
                // 向左滑动 - 下一章
                if currentPageIndex < book.chapters.count - 1 {
                    showPageTransition = true
                    dragOffset = -geometry.size.width

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        currentPageIndex += 1
                        dragOffset = geometry.size.width
                        showPageTransition = false
                        dragOffset = 0
                    }
                } else {
                    dragOffset = 0
                }
            } else if dragAmount > threshold {
                // 向右滑动 - 上一章
                if currentPageIndex > 0 {
                    showPageTransition = true
                    dragOffset = geometry.size.width

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        currentPageIndex -= 1
                        dragOffset = -geometry.size.width
                        showPageTransition = false
                        dragOffset = 0
                    }
                } else {
                    dragOffset = 0
                }
            } else {
                // 未达到阈值 - 回弹
                dragOffset = 0
            }

            dragAmount = 0
        }
    }

    /// 下一章
    private func goToNextChapter() {
        guard currentPageIndex < book.chapters.count - 1 else { return }

        withAnimation(.easeInOut(duration: 0.3)) {
            currentPageIndex += 1
        }

        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }

    /// 上一章
    private func goToPreviousChapter() {
        guard currentPageIndex > 0 else { return }

        withAnimation(.easeInOut(duration: 0.3)) {
            currentPageIndex -= 1
        }

        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }

    // MARK: - 下一页内容（预加载）
    private var nextPageContent: some View {
        VStack {
            Text(currentPageIndex + 1 < book.chapters.count ? book.chapters[currentPageIndex + 1].title : "")
                .font(.custom("Songti SC", size: 32))
                .fontWeight(.medium)
                .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(songDynastyBackground)
    }

    // MARK: - 上一页内容（预加载）
    private var previousPageContent: some View {
        VStack {
            Text(currentPageIndex - 1 >= 0 ? book.chapters[currentPageIndex - 1].title : "")
                .font(.custom("Songti SC", size: 32))
                .fontWeight(.medium)
                .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(songDynastyBackground)
    }
}

// MARK: - 预览
struct EnhancedReadingView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedReadingView(
            book: BookLibraryService.sampleBook,
            chapter: BookLibraryService.sampleBook.chapters[0],
            currentPageIndex: .constant(0),
            showMenu: .constant(true)
        )
    }
}
