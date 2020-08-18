//
//  XXBusinessPriceView.h
//  Bhex
//
//  Created by Bhex on 2018/9/5.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXShadowView.h"
#import "XXFloadtTextField.h"

@interface XXBusinessPriceView : XXShadowView

/** 价格 */
@property (strong, nonatomic) NSString *price;

/** 上下幅度 */
@property (assign, nonatomic) CGFloat midPrice;

/** 市价标签 */
@property (strong, nonatomic) XXLabel *marketPriceLable;

/** 输入框 */
@property (strong, nonatomic) XXFloadtTextField *textField;

/** 单位标签 */
@property (strong, nonatomic) XXLabel *tokenNameLabel;

/** 分割线 */
@property (strong, nonatomic) UIView *lineView;

/** - 按钮 */
@property (strong, nonatomic) XXButton *reduceButton;

/** 分割线2 */
@property (strong, nonatomic) UIView *lineTwoView;

/** + 按钮 */
@property (strong, nonatomic) XXButton *addButton;

/** 值变化 */
@property (strong, nonatomic) void(^priceValueChange)(void);

@end
