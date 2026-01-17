//
//  PaginatedReadingView.swift
//  GuJiReader
//
//  分页阅读视图 - 宋代极简美学
//  核心理念：计白当黑，大美无言
//

import SwiftUI

/// 分页阅读视图 - 完全符合需求的实现
struct PaginatedReadingView: View {
    let book: Book
    @State private var currentChapterIndex = 0
    @State private var currentpageIndex = 0
    @State private var showMenu = false

    // 硬编码的大量数据（论语全文）
    private let longLunyuText = """
子曰学而时习之不亦说乎有朋自远方来不亦乐乎人不知而不愠不亦君子乎有子曰其为人也孝弟而好犯上者鲜矣不好犯上而好作乱者未之有也君子务本本立而道生孝弟也者其为仁之本与子曰巧言令色鲜矣仁曾子曰吾日三省吾身为人谋而不忠乎与朋友交而不信乎传不习乎子曰道千乘之国敬事而信节用而爱人使民以时子曰弟子入则孝出则弟谨而信泛爱众而亲仁行有余力则以学文子夏曰贤贤易色事父母能竭其力事君能致其身与朋友交言而有信虽曰未学吾必谓之学矣子曰君子不重则不威学则不固主忠信无友不如己者过则勿惮改曾子曰慎终追远民德归厚矣子禽问于子贡曰夫子至于是邦也必闻其政求之与抑与之与子贡曰夫子温良恭俭让以得之夫子之求之也其诸异乎人之求之与子曰父在观其志父没观其行三年无改于父之道可谓孝矣有子曰礼之用和为贵先王之道斯为美小大由之有所不行知和而和不以礼节之亦不可行也有子曰信近于义言可复也恭近于礼远耻辱也因不失其亲亦可宗也子曰君子食无求饱居无求安敏于事而慎于言就有道而正焉可谓好学也已子贡曰贫而无谄富而无骄何如子曰可也未若贫而乐富而好礼者也子贡曰诗云如切如磋如琢如磨其斯之谓与子曰赐也始可与言诗已矣告诸往而知来者子曰不患人之不己知患不知人也
子曰为政以德譬如北辰居其所而众星共之诗三百一言以蔽之曰思无邪子曰道之以政齐之以刑民免而无耻道之以德齐之以礼有耻且格子曰吾十有五而志于学三十而立四十而不惑五十而知天命六十而耳顺七十而从心所欲不逾矩孟懿子问孝子曰无违樊迟曰何谓也子曰生事之以礼死葬之以礼祭之以礼孟武伯问孝子曰父母唯其疾之忧子游问孝子曰今之孝者是谓能养至于犬马皆能有养不敬何以别乎子夏问孝子曰色难有事弟子服其劳有酒食先生馔曾是以为孝乎子吾不试故艺子曰不患人之不己知患不知人也子曰为政以德譬如北辰居其所而众星共之子曰诗三百一言以蔽之曰思无邪子曰道之以政齐之以刑民免而无耻道之以德齐之以礼有耻且格
子曰八佾舞于庭是可忍也孰不可忍也三家者以雍彻子曰相维辟公天子穆天子奚取于三家之堂子曰人而不仁如礼何人而不仁如乐何子谓韶尽美矣又尽善也谓武尽美矣未尽善也子曰管仲之器小哉或曰管仲俭乎曰管氏有三归官事不摄焉得俭然则管仲知礼乎曰邦君树塞门管氏亦树塞门邦君为两君之好有反坫管氏亦有反坫管氏而知礼孰不知礼子语鲁大师乐曰乐其可知也始作翕如也从之纯如也皦如也绎如也以成子曰居上不宽为礼不敬临丧不哀吾何以观之哉
子曰里仁为美择不处仁焉得知子曰不仁者不可以久处约不可以长处乐仁者安仁知者利仁子曰唯仁者能好人能恶人子曰苟志于仁矣无恶也子曰富与贵是人之所欲也不以其道得之不处也贫与贱是人之所恶也不以其道得之不去也君子去仁恶乎成名君子无终食之间违仁造次必于是颠沛必于是子曰我未见好仁者恶不仁者好仁者无以尚之恶不仁者其为仁矣不使不仁者加乎其身有能一日用其力于仁矣乎我未见力不足者盖有之矣我未之见也子人之过也各于其党观过斯知仁矣子曰朝闻道夕死可矣子曰士志于道而耻恶衣恶食者未足与议也子曰君子之于天下也无适也无莫也义之与比子曰君子怀德小人怀土君子怀刑小人怀惠子曰放于利而行多怨子曰能以礼让为国乎何有不能以礼让为国如礼何子曰不患无位患所以立不患莫己知求为可知也子曰参乎吾道一以贯之曾子曰唯子出门人问曰何谓也曾子曰夫子之道忠恕而已矣子曰君子喻于义小人喻于利
子曰不仁者不可以久处约不可以长处乐仁者安仁知者利仁子曰唯仁者能好人能恶人子曰苟志于仁矣无恶也子曰富与贵是人之所欲也不以其道得之不处也贫与贱是人之所恶也不以其道得之不去也君子去仁恶乎成名君子无终食之间违仁造次必于是颠沛必于是子曰我未见好仁者恶不仁者好仁者无以尚之恶不仁者其为仁矣不使不仁者加乎其身有能一日用其力于仁矣乎我未见力不足者盖有之矣我未之见也子人之过也各于其党观过斯知仁矣子曰朝闻道夕死可矣子曰士志于道而耻恶衣恶食者未足与议也子曰君子之于天下也无适也无莫也义之与比子曰君子怀德小人怀土君子怀刑小人怀惠子曰放于利而行多怨子曰能以礼让为国乎何有不能以礼让为国如礼何子曰不患无位患所以立不患莫己知求为可知也子曰参乎吾道一以贯之曾子曰唯子出门人问曰何谓也曾子曰夫子之道忠恕而已矣子曰君子喻于义小人喻于利
子见南子子路不说夫子矢之曰予所否者天厌之天厌之子曰君子坦荡荡小人长戚戚子曰述而不作信而好古窃比于我老彭子曰默而识之学而不厌诲人不倦何有于我哉子曰德之不修学之不讲闻义不能徙不善不能改是吾忧也子之燕居申申如也夭夭如也子曰甚矣吾衰也久矣吾不复梦见周公子曰志于道据于德依于仁游于艺子曰自行束脩以上吾未尝无诲焉子曰不愤不启不悱不发举一隅不以三隅反则不复也子食于有丧者之侧未尝饱也子于是日哭则不歌子谓颜渊曰用之则行舍之则藏唯我与尔有是夫子路曰子行三军则谁与子曰暴虎冯河死而无悔者吾不与也必也临事而惧好谋而成者也
子曰富而可求也虽执鞭之士吾亦为之如不可求从吾所好子之所慎齐战疾子在齐闻韶三月不知肉味曰不图为乐之至于斯也冉有曰夫子为卫君乎子贡曰诺吾将问之入曰伯夷叔齐何人也曰古之贤人也曰怨乎曰求仁而得仁又何怨乎出曰夫子不为也子曰饭疏食饮水曲肱而枕之乐亦在其中矣不义而富且贵于我如浮云子曰加我数年五十以学易可以无大过矣子所雅言诗书执礼皆雅言也也叶公问孔子于子路子路不对子曰女奚不曰其为人也发愤忘食乐以忘忧不知老之将至云尔子曰我非生而知之者好古敏以求之者也子曰三人行必有我师焉择其善者而从之其不善者而改之子曰天生德于予桓魋其如予何子曰二三子以我为隐乎吾无隐乎尔吾无行而不与二三子者是我丘也子文行忠信子不语怪力乱神子曰三人行必有我师焉择其善者而从之其不善者而改之子曰圣人吾不得而见之矣得见君子者斯可矣子曰善人吾不得而见之矣得见有恒者斯可矣亡而为有虚而为盈约而为泰难乎有恒矣子曰钓而不纲弋不射宿子曰盖有不知而作之者我无是也多闻择其善者而从之多见而识之知之次也互乡难与言童子见门人或曰进与子曰进也吾许其进也退也吾许其退也唯何甚人洁己以进与其洁也不保其往也子曰仁远乎哉我欲仁斯仁至矣
陈司败问昭公知礼乎孔子曰知礼孔子退揖巫马期而进之曰吾闻君子不党君子亦党乎君取于吴为同姓谓之吴孟子君而知礼孰不知礼巫马期以告子曰丘也幸苟有过人必知之子曰与其进也不与其退也唯何甚人洁己以进与其洁也不保其往也子曰朝闻道夕死可矣子曰士志于道而耻恶衣恶食者未足与议也子曰君子之于天下也无适也无莫也义之与比子曰君子怀德小人怀土君子怀刑小人怀惠子曰放于利而行多怨子曰能以礼让为国乎何有不能以礼让为国如礼何子曰不患无位患所以立不患莫己知求为可知也子曰参乎吾道一以贯之曾子曰唯子出门人问曰何谓也曾子曰夫子之道忠恕而已矣子曰君子喻于义小人喻于利子曰不有祝鮀之佞而有宋朝之美难乎免于今之世矣子曰人能宏道非道宏人子曰过而不改是谓过矣子曰吾尝终日不食终夜不寝以思无益不如学也子曰君子谋道不谋食耕也馁在其中矣学也禄在其中矣君子忧道不忧贫子曰知及之仁不能守之虽得之必失之知及之仁能守之不庄以莅之则民不敬庄以莅之动之不以礼未善也子曰君子博学于文约之以礼亦可以弗畔矣夫子见南子子路不说夫子矢之曰予所否者天厌之天厌之子曰中庸之为德也其至矣乎民鲜久矣子贡曰如有博施于民而能济众何如可谓仁乎子曰何事于仁必也圣乎尧舜其犹病诸夫仁者己欲立而立人己欲达而达人能近取譬可谓仁之方也已
"""

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 1. 背景层 - 古纸米黄 #F2EBD9
                Color(red: 0.949, green: 0.922, blue: 0.851)
                    .ignoresSafeArea()

                // 2. 噪点纹理层
                noiseTexture
                    .ignoresSafeArea()

                // 3. 主内容层
                VStack(spacing: 0) {
                    // 顶部菜单栏（可隐藏）
                    if showMenu {
                        topMenuBar
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // 阅读内容区
                    Spacer()

                    // 当前页内容
                    currentPageContent
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Spacer()

                    // 底部页码指示器（始终显示）
                    pageIndicator
                        .padding(.bottom, 20)

                    // 底部菜单栏（可隐藏）
                    if showMenu {
                        bottomMenuBar
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }

                // 4. 点击区域层（用于翻页和菜单控制）
                clickOverlay
            }
        }
        .statusBar(hidden: !showMenu)
    }

    // MARK: - 当前页内容
    @ViewBuilder private var currentPageContent: some View {
        let pages = calculatePages()
        if currentpageIndex < pages.count {
            let currentPageText = pages[currentpageIndex]

            VStack(spacing: 0) {
                // 章节标题
                Text("学而第一")
                    .font(.custom("Kaiti SC", size: 28))
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .padding(.bottom, 40)

                // 分页文本内容
                Text(currentPageText)
                    .font(.custom("Kaiti SC", size: 20))
                    .lineSpacing(8) // 1.8倍行高
                    .kerning(1) // 字间距
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2)) // 深灰色 #333333
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 40)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.3))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
            )
            .padding(.horizontal, 24)
        } else {
            Text("加载中...")
                .font(.system(size: 20))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
        }
    }

    // MARK: - 噪点纹理
    private var noiseTexture: some View {
        Canvas { context, size in
            for _ in 0..<500 {
                let startX = CGFloat.random(in: 0...size.width)
                let startY = CGFloat.random(in: 0...size.height)
                let length = CGFloat.random(in: 1...3)

                var path = Path()
                path.move(to: CGPoint(x: startX, y: startY))

                context.stroke(
                    path,
                    with: .color(Color.black.opacity(0.015)),
                    lineWidth: 0.5
                )
            }
        }
    }

    // MARK: - 页码指示器
    private var pageIndicator: some View {
        let pages = calculatePages()
        return Text("第一章 · \(currentpageIndex + 1) / \(pages.count)")
            .font(.system(size: 12))
            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.5))
            )
    }

    // MARK: - 顶部菜单栏
    private var topMenuBar: some View {
        HStack {
            Button(action: {
                // 返回操作
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    .padding(12)
                    .background(Color.white.opacity(0.5))
                    .clipShape(Circle())
            }

            Spacer()

            Text(book.title)
                .font(.custom("Kaiti SC", size: 18))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))

            Spacer()

            Button(action: {
                // 设置操作
            }) {
                Image(systemName: "textformat.size")
                    .font(.system(size: 18))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    .padding(12)
                    .background(Color.white.opacity(0.5))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .background(
            Color.white.opacity(0.8)
                .blur(radius: 1)
        )
    }

    // MARK: - 底部菜单栏
    private var bottomMenuBar: some View {
        HStack(spacing: 30) {
            Button(action: previousPage) {
                VStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text("上一页")
                        .font(.system(size: 12))
                }
                .foregroundColor(currentpageIndex > 0 ? Color(red: 0.3, green: 0.3, blue: 0.3) : Color.gray)
            }
            .disabled(currentpageIndex == 0)

            Button(action: { showMenu.toggle() }) {
                VStack(spacing: 4) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16))
                    Text("更多")
                        .font(.system(size: 12))
                }
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
            }

            Button(action: nextPage) {
                VStack(spacing: 4) {
                    Text("下一页")
                        .font(.system(size: 12))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(currentpageIndex < calculatePages().count - 1 ? Color(red: 0.3, green: 0.3, blue: 0.3) : Color.gray)
            }
            .disabled(currentpageIndex >= calculatePages().count - 1)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 40)
        .background(
            Color.white.opacity(0.8)
                .blur(radius: 1)
        )
    }

    // MARK: - 点击遮罩层（实现翻页逻辑）
    private var clickOverlay: some View {
        GeometryReader { geometry in
            ZStack {
                // 左侧区域 - 上一页
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // 点击左侧 1/3 -> 上一页
                        withAnimation(.easeInOut(duration: 0.3)) {
                            previousPage()
                        }
                    }

                // 右侧区域 - 下一页
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // 点击右侧 1/3 -> 下一页
                        withAnimation(.easeInOut(duration: 0.3)) {
                            nextPage()
                        }
                    }

                // 中间区域 - 切换菜单
                Color.clear
                    .frame(width: geometry.size.width / 3)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // 点击中间 -> 切换菜单
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showMenu.toggle()
                        }
                    }
            }
        }
    }

    // MARK: - 分页算法（核心逻辑）
    func calculatePages() -> [String] {
        let fontSize: CGFloat = 20
        let lineHeight: CGFloat = 36 // 1.8倍行高
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 48 // 减去左右padding
        let screenHeight: CGFloat = UIScreen.main.bounds.height - 200 // 减去顶部和底部空间

        // 估算每行能容纳的字符数（中文字符约等于字体大小）
        let charsPerLine = Int(screenWidth / fontSize)

        // 计算每页能容纳的行数
        let linesPerPage = Int(screenHeight / lineHeight)

        // 计算每页能容纳的字符数
        let charsPerPage = charsPerLine * linesPerPage

        // 分割文本
        var pages: [String] = []
        let text = longLunyuText.replacingOccurrences(of: "\n", with: "")

        var startIndex = text.startIndex
        while startIndex < text.endIndex {
            let endIndex = text.index(startIndex, offsetBy: min(charsPerPage, text.distance(from: startIndex, to: text.endIndex)))
            let pageText = String(text[startIndex..<endIndex])
            pages.append(pageText)
            startIndex = endIndex
        }

        return pages.isEmpty ? ["加载中..."] : pages
    }

    // MARK: - 翻页操作
    private func nextPage() {
        let pages = calculatePages()
        guard currentpageIndex < pages.count - 1 else { return }
        currentpageIndex += 1

        // 触觉反馈
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }

    private func previousPage() {
        guard currentpageIndex > 0 else { return }
        currentpageIndex -= 1

        // 触觉反馈
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}

// MARK: - 预览
struct PaginatedReadingView_Previews: PreviewProvider {
    static var previews: some View {
        PaginatedReadingView(book: BookLibraryService.sampleBook)
    }
}
