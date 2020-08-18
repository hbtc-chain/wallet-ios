//
//  XXBusinessNumberView.h
//  Bhex
//
//  Created by BHEX on 2018/7/4.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXShadowView.h"
#import "XXFloadtTextField.h"

@interface XXBusinessAmountView : XXShadowView

/** 输入框 */
@property (strong, nonatomic) XXFloadtTextField *textField;

/** 单位标签 */
@property (strong, nonatomic) XXLabel *tokenNameLabel;

@end
