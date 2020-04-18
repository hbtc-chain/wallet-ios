//
//  XXDelegateAddressView.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXDelegateAddressView : UIView
/** 名称标签 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 背景图 */
@property (strong, nonatomic) UIView *banView;

/** 单位标签 */
@property (strong, nonatomic) XXLabel *unitLabel;

/** 输入框 */
@property (strong, nonatomic) XXTextField *textField;

/** 选择按钮*/
@property (strong, nonatomic) XXButton *selectAddressButton;

@end

NS_ASSUME_NONNULL_END
