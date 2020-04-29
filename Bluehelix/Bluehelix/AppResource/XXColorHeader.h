//
//  XXColorHeader.h
//  Bhex
//
//  Created by Bhex on 2018/8/29.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#ifndef XXColorHeader_h
#define XXColorHeader_h

#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define KRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a/100.0]

// 是否深色模式
#define KIsDarkModel ((@available(iOS 13.0, *) && UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ? YES : NO)

/** 状态栏的状态 */
#define KStatusBarStyleDefault (KUser.isNightType ? KStatusBarWhiteStyle : KStatusBarDarkStyle)
#define KStatusBarWhiteStyle (KIsDarkModel ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent)
#define KStatusBarDarkStyle (KIsDarkModel ? UIStatusBarStyleDarkContent : UIStatusBarStyleDefault)

/** 导航栏 */
#define KNavigation_BackgroundColor (kWhiteColor)
#define KNavigationBar_TitleColor  (kGray900)
#define kViewBackgroundColor (kWhiteColor)

// 用于绘制不透明所用 【交易进度条】
#define kGrayColor  kIsNight ? KRGBA(34,51,73,100) : KRGBA(244, 245, 245, 100)

// 分隔线颜色
#define KLine_Color (kIsNight ? KRGBA(27,43,63,100) : KRGBA(36,43,50,5))
#define KBigLine_Color (kIsNight ? KRGBA(8,23,36,100) : KRGBA(36,43,50,5))

// 主色调【蓝色】背景下的字体颜色
#define kMainTextColor kIsNight ? [UIColor colorWithHexString:@"#141A27"] : [UIColor colorWithHexString:@"#FFFFFF"]

// 字体颜色

#endif /* XXColorHeader_h */
