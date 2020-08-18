//
//  XXMarketSortButton.h
//  Bhex
//
//  Created by Bhex on 2018/9/4.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXShadowView.h"

@interface XXMarketSortButton : XXShadowView

/** 状态 0.排序 1. 降序 2. 升序 */
@property (assign, nonatomic) NSInteger status;

/** 标签 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 排序图标 */
@property (strong, nonatomic) UIImage *sortImage;

/** 降序图标 */
@property (strong, nonatomic) UIImage *sortDownImage;

/** 升序图标 */
@property (strong, nonatomic) UIImage *sortUpImage;

/** 状态改变回调 */
@property (strong, nonatomic) void(^sortStatusBlock)(void);
@end
