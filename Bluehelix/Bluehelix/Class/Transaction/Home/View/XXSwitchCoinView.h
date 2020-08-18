//
//  XXSwitchCoinView.h
//  Bhex
//
//  Created by Bhex on 2019/5/21.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXSwitchCoinView : UIView

/** 是否币对详情选择 */
@property (assign, nonatomic) BOOL isSymbolDetail;

/** 回调 1. 清理数据 2. 消失重新订阅 */
@property (strong, nonatomic, nullable) void(^detailSymbolBlock)(NSInteger index);

#pragma mark - 3. show
- (void)show;

#pragma mark - 4. dismiss
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
