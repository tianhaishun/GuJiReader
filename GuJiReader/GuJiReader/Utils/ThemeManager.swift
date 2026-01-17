//
//  ThemeManager.swift
//  GuJiReader
//
//  主题管理器
//

import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @Published var currentTheme: ReadingTheme = .ricePaper {
        didSet {
            saveTheme()
        }
    }

    private let userDefaultsKey = "currentTheme"

    private init() {
        loadTheme()
    }

    private func saveTheme() {
        UserDefaults.standard.set(currentTheme.rawValue, forKey: userDefaultsKey)
    }

    private func loadTheme() {
        if let themeString = UserDefaults.standard.string(forKey: userDefaultsKey),
           let theme = ReadingTheme(rawValue: themeString) {
            currentTheme = theme
        }
    }
}
