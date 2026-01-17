//
//  BookLibraryService.swift
//  GuJiReader
//
//  书库服务 - 管理书籍数据
//

import Foundation
import SwiftUI
import Combine

class BookLibraryService: ObservableObject {
    static let shared = BookLibraryService()

    @Published var allBooks: [Book] = []
    @Published var downloadedBooks: [Book] = []

    private let userDefaultsKey = "downloadedBooks"

    private init() {
        loadBooks()
        loadDownloadedBooks()
    }

    // MARK: - 加载书籍数据
    private func loadBooks() {
        allBooks = [
            // 经典类
            Book(
                id: "lunyu",
                title: "论语",
                author: "孔子",
                description: "儒家经典著作之一，记录了孔子及其弟子的言行，是儒家学派的核心典籍。全书共20篇，内容涉及政治、教育、文学、哲学以及立身处世的道理等多方面。",
                category: .classic,
                coverColor: "8B4513",
                chapters: lunyuChapters,
                isDownloaded: false
            ),
            Book(
                id: "dao_de_jing",
                title: "道德经",
                author: "老子",
                description: "道家哲学思想的重要来源，是中国历史上首部完整的哲学著作。全书分《道经》和《德经》两篇，共81章。",
                category: .classic,
                coverColor: "2F4F4F",
                chapters: daoDeJingChapters,
                isDownloaded: false
            ),
            Book(
                id: "mengzi",
                title: "孟子",
                author: "孟子",
                description: "儒家学派经典著作之一，记录了孟子的言行和政治观点。全书共7篇，是战国时期孟子的言论汇编。",
                category: .classic,
                coverColor: "654321",
                chapters: mengziChapters,
                isDownloaded: false
            ),

            // 历史类
            Book(
                id: "shi_ji",
                title: "史记",
                author: "司马迁",
                description: "中国历史上第一部纪传体通史，记载了上至上古传说中的黄帝时代，下至汉武帝太初四年间共3000多年的历史。",
                category: .history,
                coverColor: "8B0000",
                chapters: [Chapter(id: "1", title: "五帝本纪", content: "黄帝者少典之子姓公孙名曰轩辕生而神灵弱而能言幼而徇齐长而敦敏成而聪明", order: 1)],
                isDownloaded: false
            ),
            Book(
                id: "zi_zhi_tong_jian",
                title: "资治通鉴",
                author: "司马光",
                description: "中国第一部编年体通史，记录了从战国到五代共1362年的史事。",
                category: .history,
                coverColor: "800000",
                chapters: [Chapter(id: "1", title: "周纪一", content: "初鲁肃闻刘表卒言于孙权曰荆州与国邻接江东险固沃野万里士民殷富若据而有之二天子也", order: 1)],
                isDownloaded: false
            ),

            // 哲学类
            Book(
                id: "zhuangzi",
                title: "庄子",
                author: "庄子",
                description: "道家经典著作，又称《南华经》。全书共33篇，反映了庄子的哲学、艺术、美学取向与人生观。",
                category: .philosophy,
                coverColor: "191970",
                chapters: zhuangziChapters,
                isDownloaded: false
            ),
            Book(
                id: "yi_jing",
                title: "易经",
                author: "周文王",
                description: "中国传统思想文化中自然哲学与人文实践的理论根源，是古代汉民族思想、智慧的结晶。",
                category: .philosophy,
                coverColor: "4B0082",
                chapters: yiJingChapters,
                isDownloaded: false
            ),

            // 文学类
            Book(
                id: "gu_wen_guan_zhi",
                title: "古文观止",
                author: "吴楚材",
                description: "清代以来最为流行的古代散文选本之一，选录了从先秦到明代的文章222篇。",
                category: .literature,
                coverColor: "006400",
                chapters: [Chapter(id: "1", title: "郑伯克段于鄢", content: "初郑武公娶于申曰武姜生庄公及共叔段庄公寤生惊姜氏故不爱", order: 1)],
                isDownloaded: false
            ),

            // 诗词类
            Book(
                id: "tang_shi_san_bai_shou",
                title: "唐诗三百首",
                author: "蘅塘退士",
                description: "最畅销的诗歌选集，收录了77位诗人的共311首诗。",
                category: .poetry,
                coverColor: "B8860B",
                chapters: tangShiChapters,
                isDownloaded: false
            ),
            Book(
                id: "song_ci_san_bai_shou",
                title: "宋词三百首",
                author: "朱孝臧",
                description: "最流行的宋词选本，收录了宋代词人的优秀作品。",
                category: .poetry,
                coverColor: "DAA520",
                chapters: songCiChapters,
                isDownloaded: false
            )
        ]
    }

    // MARK: - 下载管理
    func downloadBook(_ book: Book) {
        guard !downloadedBooks.contains(where: { $0.id == book.id }) else {
            return
        }

        var downloadedBook = book
        downloadedBook.isDownloaded = true
        downloadedBooks.append(downloadedBook)

        // 更新主列表中的书籍状态
        if let index = allBooks.firstIndex(where: { $0.id == book.id }) {
            allBooks[index].isDownloaded = true
        }

        saveDownloadedBooks()
    }

    func removeBook(_ book: Book) {
        downloadedBooks.removeAll { $0.id == book.id }

        // 更新主列表中的书籍状态
        if let index = allBooks.firstIndex(where: { $0.id == book.id }) {
            allBooks[index].isDownloaded = false
        }

        saveDownloadedBooks()
    }

    private func saveDownloadedBooks() {
        let bookIDs = downloadedBooks.map { $0.id }
        UserDefaults.standard.set(bookIDs, forKey: userDefaultsKey)
    }

    private func loadDownloadedBooks() {
        guard let bookIDs = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] else {
            return
        }

        downloadedBooks = allBooks.filter { bookIDs.contains($0.id) }
        downloadedBooks.forEach { book in
            if let index = allBooks.firstIndex(where: { $0.id == book.id }) {
                allBooks[index].isDownloaded = true
            }
        }
    }
}

// MARK: - 示例书籍（用于预览）
extension BookLibraryService {
    static var sampleBook: Book {
        Book(
            id: "sample",
            title: "论语·学而",
            author: "孔子",
            description: "《论语》第一篇，主要讲述学习、修身、待人处世等方面的道理。",
            category: .classic,
            coverColor: "8B4513",
            chapters: [
                Chapter(
                    id: "chapter_1",
                    title: "学而第一（一）",
                    content: """
                    子曰学而时习之不亦说乎有朋自远方来不亦乐乎人不知而不愠不亦君子乎其为人也孝弟而好犯上者鲜矣不好犯上而好作乱者未之有也君子务本本立而道生孝弟也者其为仁之本与子曰巧言令色鲜矣仁曾子曰吾日三省吾身为人谋而不忠乎与朋友交而不信乎传不习乎子曰道千乘之国敬事而信节用而爱人使民以时子曰弟子入则孝出则弟谨而信泛爱众而亲仁行有余力则以学文子夏曰贤贤易色事父母能竭其力事君能致其身与朋友交言而有信虽曰未学吾必谓之学矣子曰君子不重则不威学则不固主忠信无友不如己者过则勿惮改曾子曰慎终追远民德归厚矣子禽问于子贡曰夫子至于是邦也必闻其政求之与抑与之与子贡曰夫子温良恭俭让以得之夫子之求之也其诸异乎人之求之与子曰父在观其志父没观其行三年无改于父之道可谓孝矣有子曰礼之用和为贵先王之道斯为美小大由之有所不行知和而和不以礼节之亦不可行也有子曰信近于义言可复也恭近于礼远耻辱也因不失其亲亦可宗也子曰君子食无求饱居无求安敏于事而慎于言就有道而正焉可谓好学也已子贡曰贫而无谄富而无骄何如子曰可也未若贫而乐富而好礼者也子贡曰诗云如切如磋如琢如磨其斯之谓与子曰赐也始可与言诗已矣告诸往而知来者子曰不患人之不己知患不知人也
                    """,
                    order: 1
                ),
                Chapter(
                    id: "chapter_2",
                    title: "学而第一（二）",
                    content: """
                    子曰为政以德譬如北辰居其所而众星共之子曰诗三百一言以蔽之曰思无邪子曰道之以政齐之以刑民免而无耻道之以德齐之以礼有耻且格子曰吾十有五而志于学三十而立四十而不惑五十而知天命六十而耳顺七十而从心所欲不逾矩子曰父母在不远游游必有方子曰三年无改于父之道可谓孝矣有子曰礼之用和为贵先王之道斯为美小大由之有所不行知和而和不以礼节之亦不可行也
                    """,
                    order: 2
                )
            ],
            isDownloaded: true
        )
    }
}

// MARK: - 章节数据（完整版）
private let lunyuChapters = [
    Chapter(id: "1", title: "学而第一", content: lunyu01, order: 1),
    Chapter(id: "2", title: "为政第二", content: lunyu02, order: 2),
    Chapter(id: "3", title: "八佾第三", content: lunyu03, order: 3),
    Chapter(id: "4", title: "里仁第四", content: lunyu04, order: 4),
    Chapter(id: "5", title: "公冶长第五", content: lunyu05, order: 5),
    Chapter(id: "6", title: "雍也第六", content: lunyu06, order: 6),
    Chapter(id: "7", title: "述而第七", content: lunyu07, order: 7),
    Chapter(id: "8", title: "泰伯第八", content: lunyu08, order: 8),
    Chapter(id: "9", title: "子罕第九", content: lunyu09, order: 9),
    Chapter(id: "10", title: "乡党第十", content: lunyu10, order: 10),
    Chapter(id: "11", title: "先进第十一", content: lunyu11, order: 11),
    Chapter(id: "12", title: "颜渊第十二", content: lunyu12, order: 12),
    Chapter(id: "13", title: "子路第十三", content: lunyu13, order: 13),
    Chapter(id: "14", title: "宪问第十四", content: lunyu14, order: 14),
    Chapter(id: "15", title: "卫灵公第十五", content: lunyu15, order: 15),
    Chapter(id: "16", title: "季氏第十六", content: lunyu16, order: 16),
    Chapter(id: "17", title: "阳货第十七", content: lunyu17, order: 17),
    Chapter(id: "18", title: "微子第十八", content: lunyu18, order: 18),
    Chapter(id: "19", title: "子张第十九", content: lunyu19, order: 19),
    Chapter(id: "20", title: "尧曰第二十", content: lunyu20, order: 20)
]

private let daoDeJingChapters = [
    Chapter(id: "1", title: "第一章", content: daodejing01, order: 1),
    Chapter(id: "2", title: "第二章", content: daodejing11_20, order: 2)
]

private let mengziChapters = [
    Chapter(id: "1", title: "梁惠王上", content: "孟子见梁惠王王曰叟不远千里而来亦将有以利吾国乎孟子曰王何必曰利亦有仁义而已矣王曰何以利吾国大夫曰何以利吾家士庶人曰何以利吾身上下交征利而国危矣万乘之国弑其君者必千乘之家千乘之国弑其君者必百乘之家万取千焉千取百焉不为不多矣苟为后义而先利不夺不餍未有仁而遗其亲者也未有义而后其君者也王亦曰仁义而已矣何必曰利", order: 1),
    Chapter(id: "2", title: "梁惠王下", content: "庄暴见孟子曰暴见于王王语暴以好乐暴未有以对也曰好乐何如孟子曰王之好乐甚则齐国其庶几乎他日见于王曰王尝语庄子以好乐有诸王变乎色曰寡人非能好先王之乐也直好世俗之乐耳曰王之好乐甚则齐其庶矣今乐犹古乐也曰可得闻与曰独乐乐不如众乐乐少乐乐与众乐乐孰乐曰不若与众曰与少乐乐与众乐乐孰乐曰不若与众臣请为王言乐夫鼓乐于此王闻之举疾首蹙頞而相告曰吾王之好鼓乐此夫何为我使我至于此极也父子不相见兄弟妻子离散今王畋猎于此王闻之举疾首蹙頞而相告曰吾王之好田猎此夫何为我使我至于此极也父子不相见兄弟妻子离散今王田猎于此百姓闻王车马之音见羽旄之美举欣欣然有喜色而相告曰吾王庶几无疾病与何以能田猎也此无他善与民同乐也今王与百姓同乐则王矣", order: 2)
]

private let zhuangziChapters = [
    Chapter(id: "1", title: "逍遥游", content: zhuangzi01, order: 1),
    Chapter(id: "2", title: "齐物论", content: zhuangzi02, order: 2)
]

private let yiJingChapters = [
    Chapter(id: "1", title: "乾卦", content: yijing01, order: 1),
    Chapter(id: "2", title: "坤卦", content: yijing02, order: 2)
]

private let siShuChapters = [
    Chapter(id: "1", title: "大学", content: daxue, order: 1),
    Chapter(id: "2", title: "中庸", content: zhongyong, order: 2)
]

private let sunziChapters = [
    Chapter(id: "1", title: "始计篇", content: sunzi01, order: 1)
]

private let tangShiChapters = [
    Chapter(id: "1", title: "将进酒", content: qijiuxiu, order: 1),
    Chapter(id: "2", title: "水调歌头", content: shuidiaogtou, order: 2)
]

private let songCiChapters = [
    Chapter(id: "1", title: "念奴娇", content: nianruqiao, order: 1)
]
