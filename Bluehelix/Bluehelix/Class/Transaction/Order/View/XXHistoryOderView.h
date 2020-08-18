//
//  XXHistoryOderView.h
//  Bhex
//
//  Created by BHEX on 2018/7/22.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXHistoryOderView : UIView
/** 1. 筛选 */
- (void)screenWithBaseToken:(NSString *)baseToken quoteToken:(NSString *)quoteToken side:(NSString *)side;

/** 初始化接口*/
- (instancetype)initWithFrame:(CGRect)frame;
@end
