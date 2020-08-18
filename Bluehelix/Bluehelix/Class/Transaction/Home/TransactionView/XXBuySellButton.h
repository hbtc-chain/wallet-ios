//
//  XXBuySellButton.h
//  Bhex
//
//  Created by Bhex on 2018/9/5.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXShadowView.h"

@interface XXBuySellButton : XXShadowView

/** 回调 */
@property (strong, nonatomic) void(^buySellBlock)(NSInteger index);

/** 索引
    0. buy
    1. sell
 */
@property (assign, nonatomic) NSInteger indexType;
/** buy按钮 */
@property (strong, nonatomic) XXButton *buyButton;

/** sell按钮 */
@property (strong, nonatomic) XXButton *sellButton;

/** 颜色是否相反向 */
@property (assign, nonatomic) BOOL colorIsNegative;

- (void)changeIndex:(NSInteger)index;
@end
