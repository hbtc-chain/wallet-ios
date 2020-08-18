//
//  XXCoinView.h
//  Bhex
//
//  Created by Bhex on 2019/1/8.
//  Copyright © 2019年 Bhex. All rights reserved.
//

#import "XXTradeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXCoinView : XXTradeView

/** 显示隐藏回调 */
@property (strong, nonatomic) void(^scrollBlock)(BOOL isShowTab);

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
