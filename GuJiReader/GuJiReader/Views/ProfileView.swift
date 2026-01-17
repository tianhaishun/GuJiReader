//
//  ProfileView.swift
//  GuJiReader
//
//  个人资料视图 - 古代文书风格
//

import SwiftUI

struct ProfileView: View {
    @State private var username = "读者"
    @State private var readingDays = 128

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

                ScrollView {
                    VStack(spacing: 0) {
                        // 标题区
                        VStack(spacing: 15) {
                            Text("我的")
                                .font(.custom("Kaiti SC", size: 48))
                                .fontWeight(.ultraLight)
                                .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08))
                                .tracking(10)

                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.2),
                                            Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.02),
                                            Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.2)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(height: 1)
                                .padding(.horizontal, 60)
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 30)

                        // 用户信息卡 - 古代名刺风格
                        VStack(spacing: 20) {
                            // 名号
                            VStack(spacing: 8) {
                                Text("名号")
                                    .font(.custom("Kaiti SC", size: 12))
                                    .fontWeight(.light)
                                    .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.4))
                                    .tracking(3)

                                Text(username)
                                    .font(.custom("Kaiti SC", size: 28))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08))
                                    .tracking(5)
                            }
                            .padding(.vertical, 25)

                            Rectangle()
                                .fill(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.08))
                                .frame(height: 1)
                                .padding(.horizontal, 40)

                            // 阅读统计
                            HStack(spacing: 0) {
                                VStack(spacing: 8) {
                                    Text("\(readingDays)")
                                        .font(.custom("Kaiti SC", size: 32))
                                        .fontWeight(.ultraLight)
                                        .foregroundColor(Color(red: 0.7, green: 0.15, blue: 0.15).opacity(0.85))

                                    Text("日")
                                        .font(.custom("Kaiti SC", size: 13))
                                        .fontWeight(.light)
                                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.5))
                                }

                                Rectangle()
                                    .fill(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.1))
                                    .frame(width: 1)
                                    .padding(.vertical, 10)

                                VStack(spacing: 8) {
                                    Text("勤")
                                        .font(.custom("Kaiti SC", size: 32))
                                        .fontWeight(.ultraLight)
                                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.6))

                                    Text("读")
                                        .font(.custom("Kaiti SC", size: 13))
                                        .fontWeight(.light)
                                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.5))
                                }
                            }
                            .padding(.vertical, 25)
                        }
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.15), lineWidth: 1)
                        )
                        .padding(.horizontal, 35)
                        .padding(.bottom, 30)

                        // 功能菜单 - 极简列表
                        VStack(spacing: 0) {
                            MenuItem(title: "阅读偏好", subtitle: "字号·主题·动画")
                            MenuItem(title: "关于", subtitle: "版本·说明")
                        }
                        .padding(.horizontal, 35)
                        .padding(.top, 20)
                        .padding(.bottom, 60)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - 菜单项
struct MenuItem: View {
    let title: String
    let subtitle: String

    var body: some View {
        Button(action: {}) {
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.custom("Kaiti SC", size: 15))
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08))

                    Text(subtitle)
                        .font(.custom("Kaiti SC", size: 11))
                        .fontWeight(.light)
                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.5))
                }

                Spacer()

                Text(">")
                    .font(.custom("Kaiti SC", size: 14))
                    .fontWeight(.light)
                    .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.3))
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.5))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
