//
//  XXTransferAmountView.h
//  Bluehelix
//
//  Created by BHEX on 2020/04/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXFloadtTextField.h"
NS_ASSUME_NONNULL_BEGIN

@interface XXTransferAmountView : UIView

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

/** 当前可提 */
@property (strong, nonatomic) NSString *currentlyAvailable;

/** 输入框输入回调 */
@property (strong, nonatomic) void(^textFieldBoock)(void);

/** 所有按钮回调 */
@property (copy, nonatomic) void(^allButtonActionBlock)(void);
@end

NS_ASSUME_NONNULL_END
