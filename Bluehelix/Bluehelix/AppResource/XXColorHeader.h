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
#define KNavigation_BackgroundColor (kWhite100)
#define KNavigationBar_TitleColor  (kDark100)
#define kViewBackgroundColor (kWhite100)

// 用于绘制不透明所用 【交易进度条】
#define kGrayColor  kIsNight ? KRGBA(34,51,73,100) : KRGBA(244, 245, 245, 100)

// 分隔线颜色
#define KLine_Color (kIsNight ? KRGBA(27,43,63,100) : KRGBA(36,43,50,5))
#define KBigLine_Color (kIsNight ? KRGBA(8,23,36,100) : KRGBA(36,43,50,5))

// 主颜色【一级主色调】
#define kBlue100   kIsNight ? KRGBA(50,117,224,100) : KRGBA(50,117,224,100)
#define kBlue80   kIsNight ? KRGBA(50,117,224,80) : KRGBA(50,117,224,80)
#define kBlue50   kIsNight ? KRGBA(50,117,224,50) : KRGBA(50,117,224,50)
#define kBlue20   kIsNight ? KRGBA(50,117,224,20) : KRGBA(50,117,224,20)
#define kBlue10   kIsNight ? KRGBA(50,117,224,10) : KRGBA(50,117,224,10)
#define kBlue5   kIsNight ? KRGBA(50,117,224,5) : KRGBA(50,117,224,5)

// 主色调【蓝色】背景下的字体颜色
#define kMainTextColor [UIColor whiteColor]

// 辅助颜色【二级主色调】
#define kOrange100   kIsNight ? KRGBA(255,190,0,100) : KRGBA(255,143,0,100)
#define kOrange80   kIsNight ? KRGBA(255,190,0,80) : KRGBA(255,143,0,80)
#define kOrange50   kIsNight ? KRGBA(255,190,0,50) : KRGBA(255,143,0,50)
#define kOrange20   kIsNight ? KRGBA(255,190,0,20) : KRGBA(255,143,0,20)
#define kOrange10   kIsNight ? KRGBA(255,190,0,10) : KRGBA(255,143,0,10)
#define kOrange5   kIsNight ? KRGBA(255,190,0,5) : KRGBA(255,143,0,5)

// 字体颜色
#define kDark100   kIsNight ? KRGBA(207,210,233,100) : KRGBA(36,43,50,100)
#define kDark80   kIsNight ? KRGBA(207,210,233,80) : KRGBA(36,43,50,80)
#define kDark50   kIsNight ? KRGBA(110,134,168,100) : KRGBA(36,43,50,50)
#define kDark20   kIsNight ? KRGBA(207,210,233,20) : KRGBA(36,43,50,20)
#define kDark10   kIsNight ? KRGBA(207,210,233,10) : KRGBA(36,43,50,10)
#define kDark5   kIsNight ? KRGBA(207,210,233,5) : KRGBA(36,43,50,5)

// 背景颜色
#define kWhite100   kIsNight ? KRGBA(19,31,47,100) : KRGBA(255,255,255,100)
#define kWhite80   kIsNight ? KRGBA(19,31,47,80) : KRGBA(255,255,255,80)
#define kWhite50   kIsNight ? KRGBA(19,31,47,50) : KRGBA(255,255,255,50)
#define kWhite20   kIsNight ? KRGBA(19,31,47,20) : KRGBA(255,255,255,20)
#define kWhite10   kIsNight ? KRGBA(19,31,47,10) : KRGBA(255,255,255,10)
#define kWhite5   kIsNight ? KRGBA(19,31,47,5) : KRGBA(255,255,255,5)

// 涨颜色
#define kGreen100  kIsNight ? KRGBA(1,172,143,100) : KRGBA(1,172,143,100)
#define kGreen80   kIsNight ? KRGBA(1,172,143,80) : KRGBA(1,172,143,80)
#define kGreen50   kIsNight ? KRGBA(1,172,143,50) : KRGBA(1,172,143,50)
#define kGreen20   kIsNight ? KRGBA(1,172,143,20) : KRGBA(1,172,143,20)
#define kGreen10   kIsNight ? KRGBA(1,172,143,10) : KRGBA(1,172,143,10)
#define kGreen5    kIsNight ? KRGBA(1,172,143,5) : KRGBA(1,172,143,5)

// 跌颜色
#define kRed100   kIsNight ? KRGBA(209,76,99,100) : KRGBA(209,76,99,100)
#define kRed80    kIsNight ? KRGBA(209,76,99,80) : KRGBA(209,76,99,80)
#define kRed50    kIsNight ? KRGBA(209,76,99,50) : KRGBA(209,76,99,50)
#define kRed20    kIsNight ? KRGBA(209,76,99,20) : KRGBA(209,76,99,20)
#define kRed10    kIsNight ? KRGBA(209,76,99,10) : KRGBA(209,76,99,10)
#define kRed5     kIsNight ? KRGBA(209,76,99,5) : KRGBA(209,76,99,5)


#endif /* XXColorHeader_h */
