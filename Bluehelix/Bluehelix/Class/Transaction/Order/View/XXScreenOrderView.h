//
//  XXScreenOrderView.h
//  Bhex
//
//  Created by BHEX on 2018/7/23.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXScreenOrderView : UIView

/** 是否处于显示状态 */
@property (assign, nonatomic) BOOL isShowing;

- (void)show;

- (void)dismiss;

/** 完成回调 */
@property (strong, nonatomic) void(^finishBlock)(NSString *baseToken, NSString *quoteToken, NSString *side);
@end
