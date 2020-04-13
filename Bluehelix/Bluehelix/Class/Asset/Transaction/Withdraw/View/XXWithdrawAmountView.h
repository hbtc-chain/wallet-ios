//
//  XXWithdrawAmountView.h
//  Bhex
//
//  Created by Bhex on 2019/12/17.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXFloadtTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXWithdrawAmountView : UIView

/** 名称标签 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 字标签 */
@property (strong, nonatomic) XXLabel *subLabel;

/** 背景图 */
@property (strong, nonatomic) UIView *banView;

/** 全部按钮 */
@property (strong, nonatomic) XXButton *allButton;

/** 输入框 */
@property (strong, nonatomic) XXFloadtTextField *textField;

/** 币种 */
@property (strong, nonatomic) NSString *tokenName;

/** 风险资产标签 */
@property (strong, nonatomic, nullable) XXLabel *riskAssetLabel;

/** 提示按钮 */
@property (strong, nonatomic, nullable) XXButton *alertButton;

/** 当前可提 */
@property (strong, nonatomic) NSString *currentlyAvailable;

/** 输入框输入回调 */
@property (strong, nonatomic) void(^textFieldBoock)(void);
@end

NS_ASSUME_NONNULL_END
