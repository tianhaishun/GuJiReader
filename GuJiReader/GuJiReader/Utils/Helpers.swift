//
//  Helpers.swift
//  GuJiReader
//
//  工具类函数
//

import SwiftUI

// MARK: - 视图修饰符
struct ShadowModifier: ViewModifier {
    var color: Color = .black
    var radius: CGFloat = 5
    var x: CGFloat = 0
    var y: CGFloat = 2

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.2), radius: radius, x: x, y: y)
    }
}

extension View {
    func cardShadow() -> some View {
        self.modifier(ShadowModifier())
    }
}

// MARK: - 震动反馈
struct HapticFeedback {
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    static func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }

    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
}

// MARK: - 格式化工具
struct FormattingHelper {
    static func formatReadingTime(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes)分钟"
        } else {
            let hours = minutes / 60
            let mins = minutes % 60
            return mins > 0 ? "\(hours)小时\(mins)分钟" : "\(hours)小时"
        }
    }

    static func formatChapterCount(_ count: Int) -> String {
        return "\(count)章"
    }
}

// MARK: - 屏幕尺寸辅助
struct ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height

    static var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }

    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}
