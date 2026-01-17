//
//  VerticalReadingView.swift
//  GuJiReader
//
//  竖排文本组件 - 真实古籍阅读体验
//

import SwiftUI

struct VerticalReadingView: View {
    let text: String
    let fontSize: Int
    let textColor: Color

    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false

    var body: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                LazyHStack(spacing: columnSpacing) {
                    ForEach(Array(columnRanges.enumerated()), id: \.offset) { index, range in
                        VStack(spacing: characterSpacing) {
                            // 列首标号（可选，增加古籍感）
                            if index % 10 == 0 && index > 0 {
                                Text("第\(index)列")
                                    .font(.custom("Kaiti SC", size: CGFloat(fontSize) * 0.5))
                                    .foregroundColor(textColor.opacity(0.3))
                                    .frame(height: CGFloat(fontSize) * 0.8)
                            }

                            ForEach(Array(range.enumerated()), id: \.offset) { _, charIndex in
                                let charIndex = text.index(text.startIndex, offsetBy: charIndex)
                                let char = String(text[charIndex])

                                Text(char)
                                    .font(.custom("Kaiti SC", size: CGFloat(fontSize)))
                                    .fontWeight(.light)
                                    .foregroundColor(textColor)
                                    .frame(width: characterWidth, height: characterHeight)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                            }
                        }
                        .padding(.vertical, verticalPadding)
                        .background(
                            // 每列的微弱背景，增加层次感
                            RoundedRectangle(cornerRadius: 2)
                                .fill(textColor.opacity(0.015))
                                .frame(width: columnWidth)
                        )
                    }
                }
                .padding(.trailing, trailingPadding)
                .padding(.leading, leadingPadding)
                .padding(.vertical, verticalPadding)
            }
            .background(
                // 宣纸纹理效果
                Canvas { context, size in
                    for _ in 0..<300 {
                        let startX = CGFloat.random(in: 0...size.width)
                        let startY = CGFloat.random(in: 0...size.height)
                        let length = CGFloat.random(in: 2...8)
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
                            with: .color(textColor.opacity(0.02)),
                            lineWidth: 0.3
                        )
                    }
                }
            )
        }
    }

    // MARK: - 计算属性（精细调整）

    private var characterWidth: CGFloat {
        CGFloat(fontSize) * 1.15
    }

    private var characterHeight: CGFloat {
        CGFloat(fontSize) * 1.15
    }

    private var characterSpacing: CGFloat {
        CGFloat(fontSize) * 0.35
    }

    private var columnSpacing: CGFloat {
        CGFloat(fontSize) * 2.2
    }

    private var columnWidth: CGFloat {
        characterWidth + 8
    }

    private var verticalPadding: CGFloat {
        CGFloat(fontSize) * 0.8
    }

    private var leadingPadding: CGFloat {
        CGFloat(fontSize) * 1.5
    }

    private var trailingPadding: CGFloat {
        CGFloat(fontSize) * 2.5
    }

    // MARK: - 文本分列处理

    private var columnRanges: [Range<Int>] {
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let totalChars = cleanText.count

        // 根据字号动态调整每列字符数
        let charsPerColumn: Int
        if fontSize <= 18 {
            charsPerColumn = 20
        } else if fontSize <= 22 {
            charsPerColumn = 18
        } else if fontSize <= 26 {
            charsPerColumn = 16
        } else {
            charsPerColumn = 14
        }

        var ranges: [Range<Int>] = []
        var startIndex = 0

        while startIndex < totalChars {
            let endIndex = min(startIndex + charsPerColumn, totalChars)
            ranges.append(startIndex..<endIndex)
            startIndex = endIndex
        }

        return ranges
    }
}

// MARK: - 预览
struct VerticalReadingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VerticalReadingView(
                text: sampleText,
                fontSize: 20,
                textColor: Color(red: 0.2, green: 0.15, blue: 0.1)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.95, green: 0.93, blue: 0.88))
        }
    }
}

// 示例文本 - 完整章节
private let sampleText = """
子曰学而时习之不亦说乎有朋自远方来不亦乐乎人不知而不愠不亦君子乎有子曰其为人也孝弟而好犯上者鲜矣不好犯上而好作乱者未之有也君子务本本立而道生孝弟也者其为仁之本与子曰巧言令色鲜矣仁曾子曰吾日三省吾身为人谋而不忠乎与朋友交而不信乎传不习乎子曰道千乘之国敬事而信节用而爱人使民以时子曰弟子入则孝出则弟谨而信泛爱众而亲仁行有余力则以学文子夏曰贤贤易色事父母能竭其力事君能致其身与朋友交言而有信虽曰未学吾必谓之学矣子曰君子不重则不威学则不固主忠信无友不如己者过则勿惮改曾子曰慎终追远民德归厚矣子禽问于子贡曰夫子至于是邦也必闻其政求之与抑与之与子贡曰夫子温良恭俭让以得之夫子之求之也其诸异乎人之求之与子曰父在观其志父没观其行三年无改于父之道可谓孝矣有子曰礼之用和为贵先王之道斯为美小大由之有所不行知和而和不以礼节之亦不可行也有子曰信近于义言可复也恭近于礼远耻辱也因不失其亲亦可宗也子曰君子食无求饱居无求安敏于事而慎于言就有道而正焉可谓好学也已子贡曰贫而无谄富而无骄何如子曰可也未若贫而乐富而好礼者也子贡曰诗云如切如磋如琢如磨其斯之谓与子曰赐也始可与言诗已矣告诸往而知来者子曰不患人之不己知患不知人也
"""
