# 应用图标说明

## 应用图标要求

为了完整的应用体验，需要准备以下尺寸的应用图标：

### iPhone
- 60pt @2x (120x120) - iPhone 6/7/8
- 60pt @3x (180x180) - iPhone 6+/7+/8+
- 60pt @2x (120x120) - iPhone X/XS/11 Pro
- 60pt @3x (180x180) - iPhone XS Max/11 Pro Max
- 60pt @2x (120x120) - iPhone XR/11
- 60pt @3x (180x180) - iPhone 12/13/14 Pro
- 60pt @2x (120x120) - iPhone 12/13/14 mini
- 60pt @3x (180x180) - iPhone 12/13/14 Pro Max

### iPad
- 76pt @1x (76x76) - iPad mini
- 76pt @2x (152x152) - iPad mini 2/3/4
- 76pt @2x (152x152) - iPad Pro/2
- 83.5pt @2x (167x167) - iPad Pro 12.9"

### 通用
- 1024x1024 - App Store

## 设计建议

### 设计元素
1. **主题**: 使用古典书籍、宣纸、印章等元素
2. **颜色**:
   - 宣纸色 (#F8F6EB) 作为背景
   - 墨色 (#333333) 用于文字
   - 朱砂红 (#CC3333) 作为点缀
3. **风格**: 简洁、优雅、有中国文化特色

### 设计思路
- 方案1: 使用古书线装效果
- 方案2: 使用印章风格
- 方案3: 使用毛笔字"古籍"二字
- 方案4: 使用卷轴图案

## 临时使用

如果暂时没有设计图标，可以使用以下方法：

### 方法1: 使用 Xcode 默认图标
- 直接运行项目，Xcode 会使用默认的 App 图标

### 方法2: 简单的文字图标
创建一个正方形图片：
- 背景色: #F8F6EB（宣纸色）
- 中心文字: "古籍"（楷体，黑色）
- 文字大小: 约占图标的 60%

### 方法3: 在线生成工具
- 使用 AppIconGenerator 等在线工具
- 或者使用 Canva、Figma 等设计工具

## 添加图标到项目

1. **在 Xcode 中**
   - 打开 `Assets.xcassets`
   - 找到 `AppIcon`
   - 将对应尺寸的图标拖入相应的位置

2. **或使用 AppIcon Generator**
   - 准备一张 1024x1024 的图标
   - 使用在线工具生成所有尺寸
   - 下载并拖入 Xcode

## 推荐工具

1. **AppIcon Generator** (appicon.co)
2. **Canva** (canva.com)
3. **Figma** (figma.com)
4. **Sketch** (sketch.com)

## 注意事项

- 图标必须为 PNG 格式
- 不要添加透明度
- 不要添加圆角（系统会自动添加）
- 确保图标在不同背景下都清晰可见
