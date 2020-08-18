//
//  XXSystem.h
//  Bhex
//
//  Created by Bhex on 2019/10/21.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXSystem : NSObject
singleton_interface(XXSystem)

/** 程序是否处于激活状态 */
@property (assign, nonatomic) BOOL isActive;

/** 1. 是否夜色模式 */
@property (assign, nonatomic) BOOL isDarkStyle;

/** 2. 状态栏设置为白色 */
- (void)statusBarSetUpWhiteColor;

/** 3. 状态栏设置为黑色 */
- (void)statusBarSetUpDarkColor;

/** 4. 状态栏设置为默认色 */
- (void)statusBarSetUpDefault;

/** 5. 程序激活 */
- (void)applicationActive;

/** 6. 程序退出 */
- (void)applicationDropOut;

/** 加载App-Config */
- (void)requestAppConfig;

//#pragma mark - 9. 加载【config】
//- (void)requestBasicConfig;

//#pragma mark - 10. 加载版本信息
//- (void)requestVersionNumber;
@end

NS_ASSUME_NONNULL_END
