//
//  PageTransitionManager.swift
//  GuJiReader
//
//  翻页动画管理器
//

import SwiftUI
import Combine

// MARK: - 翻页动画修饰器
struct PageTransitionModifier: ViewModifier {
    let isAnimating: Bool
    let style: PageTransitionStyle
    let duration: Double

    func body(content: Content) -> some View {
        content
            .modifier(transitionModifier(for: style))
    }

    private func transitionModifier(for style: PageTransitionStyle) -> AnyViewModifier {
        switch style {
        case .slide:
            return AnyViewModifier(
                SlideTransitionModifier(isAnimating: isAnimating, duration: duration)
            )
        case .fade:
            return AnyViewModifier(
                FadeTransitionModifier(isAnimating: isAnimating, duration: duration)
            )
        case .flip:
            return AnyViewModifier(
                FlipTransitionModifier(isAnimating: isAnimating, duration: duration)
            )
        }
    }
}

// MARK: - 滑动动画修饰器
struct SlideTransitionModifier: ViewModifier {
    let isAnimating: Bool
    let duration: Double

    func body(content: Content) -> some View {
        content
            .offset(x: isAnimating ? UIScreen.main.bounds.width : 0)
            .opacity(isAnimating ? 0 : 1)
            .animation(.easeInOut(duration: duration), value: isAnimating)
    }
}

// MARK: - 渐隐动画修饰器
struct FadeTransitionModifier: ViewModifier {
    let isAnimating: Bool
    let duration: Double

    func body(content: Content) -> some View {
        content
            .opacity(isAnimating ? 0 : 1)
            .scaleEffect(isAnimating ? 0.95 : 1.0)
            .animation(.easeInOut(duration: duration), value: isAnimating)
    }
}

// MARK: - 翻书动画修饰器
struct FlipTransitionModifier: ViewModifier {
    let isAnimating: Bool
    let duration: Double
    @State private var isFlipped = false

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(isAnimating ? 90 : 0),
                axis: (x: 0, y: 1, z: 0)
            )
            .opacity(isAnimating ? 0 : 1)
            .shadow(
                color: isAnimating ? .black.opacity(0.3) : .clear,
                radius: isAnimating ? 20 : 0
            )
            .animation(.easeInOut(duration: duration), value: isAnimating)
    }
}

// MARK: - AnyViewModifier 包装器
struct AnyViewModifier: ViewModifier {
    private let _body: (Content) -> AnyView

    init<M: ViewModifier>(_ modifier: M) {
        _body = { content in
            AnyView(content.modifier(modifier))
        }
    }

    func body(content: Content) -> some View {
        _body(content)
    }
}

// MARK: - View 扩展
extension View {
    func pageTransition(
        isAnimating: Bool,
        style: PageTransitionStyle,
        duration: Double
    ) -> some View {
        self.modifier(PageTransitionModifier(
            isAnimating: isAnimating,
            style: style,
            duration: duration
        ))
    }
}

// MARK: - 翻页动画管理器
class PageTransitionManager: ObservableObject {
    static let shared = PageTransitionManager()

    @Published var currentStyle: PageTransitionStyle = .slide
    @Published var transitionDuration: Double = 0.3

    private let styleKey = "pageTransitionStyle"
    private let durationKey = "transitionDuration"

    private init() {
        loadSettings()
    }

    func saveSettings() {
        UserDefaults.standard.set(currentStyle.rawValue, forKey: styleKey)
        UserDefaults.standard.set(transitionDuration, forKey: durationKey)
    }

    private func loadSettings() {
        if let styleString = UserDefaults.standard.string(forKey: styleKey),
           let style = PageTransitionStyle(rawValue: styleString) {
            currentStyle = style
        }

        let savedDuration = UserDefaults.standard.double(forKey: durationKey)
        if savedDuration > 0 {
            transitionDuration = savedDuration
        }
    }

    func triggerHapticFeedback() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}
