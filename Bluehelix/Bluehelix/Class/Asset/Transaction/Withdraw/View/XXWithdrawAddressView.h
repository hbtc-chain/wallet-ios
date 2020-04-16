//
//  XXWithdrawAddressView.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/08.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXWithdrawAddressView : UIView

/** 名称标签 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 背景图 */
@property (strong, nonatomic) UIView *banView;

/** 单位标签 */
@property (strong, nonatomic) XXLabel *unitLabel;

/** 输入框 */
@property (strong, nonatomic) XXTextField *textField;

/// 扫码
@property (strong, nonatomic) XXButton *codeButton;

/// 扫码回调
@property (copy, nonatomic) void(^codeBlock)(void);
@end

NS_ASSUME_NONNULL_END
