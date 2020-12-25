//
//  XXTransferChooseTokenView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/12/24.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXTransferChooseTokenView : UIView
/** 名称标签 */
@property (nonatomic, strong) XXLabel *nameLabel;

/** 背景图 */
@property (nonatomic, strong) UIView *banView;

/** 输入框 */
@property (nonatomic, strong) XXTextField *textField;

/// 选择币种
@property (nonatomic, strong) XXButton *chooseTokenButton;

// 是否在某链内选择币种
@property (nonatomic, strong) NSString *chain;

/// 回调
@property (nonatomic, copy) void(^chooseTokenBlock)(NSString *);
@end

NS_ASSUME_NONNULL_END
