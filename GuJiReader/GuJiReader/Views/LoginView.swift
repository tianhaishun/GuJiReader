//
//  LoginView.swift
//  GuJiReader
//
//  登录视图 - 宋代极简美学
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showRegisterAlert = false
    let onLoginSuccess: () -> Void

    // 测试用的默认账号
    private let testUsername = "读者"
    private let testPassword = "123456"

    var body: some View {
        ZStack {
            // 宣纸质感背景 - 多层纹理
            Color(red: 0.98, green: 0.97, blue: 0.95)
                .overlay(
                    // 第一层：宣纸纤维纹理
                    Canvas { context, size in
                        for _ in 0..<800 {
                            let startX = CGFloat.random(in: 0...size.width)
                            let startY = CGFloat.random(in: 0...size.height)
                            let length = CGFloat.random(in: 3...15)
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
                                with: .color(Color(red: 0.3, green: 0.25, blue: 0.2).opacity(0.015)),
                                lineWidth: 0.5
                            )
                        }
                    }
                )
                .overlay(
                    // 第二层：墨色晕染
                    Canvas { context, size in
                        for _ in 0..<40 {
                            let x = CGFloat.random(in: 0...size.width)
                            let y = CGFloat.random(in: 0...size.height)
                            let radius = CGFloat.random(in: 50...200)

                            context.fill(
                                Path(ellipseIn: CGRect(x: x - radius/2, y: y - radius/2, width: radius, height: radius)),
                                with: .color(Color.black.opacity(0.002))
                            )
                        }
                    }
                )

            VStack(spacing: 0) {
                Spacer()

                // 主标题 - 宋代书法美学
                VStack(spacing: 30) {
                    // "古籍" - 极大楷体
                    Text("古籍")
                        .font(.custom("Kaiti SC", size: 72))
                        .fontWeight(.ultraLight)
                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08))
                        .tracking(20)

                    // 副标题 - 竖排
                    HStack(spacing: 0) {
                        Text("阅")
                        Text("读")
                    }
                    .font(.custom("Kaiti SC", size: 28))
                    .fontWeight(.light)
                    .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.6))
                    .tracking(8)
                    .padding(.leading, 90)
                }
                .padding(.bottom, 80)

                // 登录表单 - 古代文书风格
                VStack(spacing: 35) {
                    // 用户名
                    VStack(alignment: .leading, spacing: 10) {
                        Text("名号")
                            .font(.custom("Kaiti SC", size: 13))
                            .fontWeight(.light)
                            .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.3))
                            .tracking(4)

                        TextField("", text: $username)
                            .font(.custom("Kaiti SC", size: 18))
                            .fontWeight(.light)
                            .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08))
                            .textInputAutocapitalization(.never)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 5)
                            .overlay(
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.15),
                                                Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.05),
                                                Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.15)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(height: 1),
                                alignment: .bottom
                            )
                            .onAppear {
                                username = testUsername
                            }
                    }

                    // 密码
                    VStack(alignment: .leading, spacing: 10) {
                        Text("符信")
                            .font(.custom("Kaiti SC", size: 13))
                            .fontWeight(.light)
                            .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.3))
                            .tracking(4)

                        SecureField("", text: $password)
                            .font(.custom("Kaiti SC", size: 18))
                            .fontWeight(.light)
                            .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 5)
                            .overlay(
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.15),
                                                Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.05),
                                                Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.15)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(height: 1),
                                alignment: .bottom
                            )
                            .onAppear {
                                password = testPassword
                            }
                    }
                }
                .padding(.horizontal, 50)

                Spacer()
                Spacer()

                // 登录按钮 - 古代印章风格
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        onLoginSuccess()
                    }
                }) {
                    ZStack {
                        // 印章边框
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color(red: 0.7, green: 0.15, blue: 0.15).opacity(0.8), lineWidth: 1.5)
                            .frame(width: 120, height: 50)

                        Text("入")
                            .font(.custom("Kaiti SC", size: 24))
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 0.7, green: 0.15, blue: 0.15).opacity(0.9))
                    }
                }
                .padding(.bottom, 60)

                // 底部提示
                Text("已为先生备好凭信")
                    .font(.custom("Kaiti SC", size: 11))
                    .fontWeight(.light)
                    .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.08).opacity(0.25))
                    .tracking(3)
                    .padding(.bottom, 30)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(onLoginSuccess: {})
    }
}
