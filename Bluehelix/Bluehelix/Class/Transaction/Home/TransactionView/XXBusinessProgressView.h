//
//  XXBusinessProgressView.h
//  Bhex
//
//  Created by BHEX on 2018/7/4.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXBusinessProgressView : UIView

/** 设置百分比 */
@property (assign, nonatomic) double proportion;

/** 点击或拖动回调 */
@property (strong, nonatomic) void(^progressProportionBlock)(double proportion);

/**
 初始到0点
 */
- (void)reloadUI;

@end
