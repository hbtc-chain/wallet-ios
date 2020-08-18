//
//  XXIndexModel.h
//  Bhex
//
//  Created by Bhex on 2019/11/5.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXIndexModel : NSObject

/** 模块儿名称 */
@property (strong, nonatomic) NSString *moduleName;

/** 类型 NATIVE H5 PATH */
@property (strong, nonatomic) NSString *jumpType;

/** 除了http、https以外都是NATIVE自定义url */
@property (strong, nonatomic) NSString *jumpUrl;

/** 默认图标 */
@property (strong, nonatomic) NSString *defaultIcon;

/** 选中时图片，可以为空 */
@property (strong, nonatomic) NSString *selectedIcon;

/** 字典 */
@property (strong, nonatomic) NSMutableDictionary *dataDict;

/** 跳转 */
- (void)pushViewController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
