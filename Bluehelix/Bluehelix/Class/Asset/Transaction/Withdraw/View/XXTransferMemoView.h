//
//  XXTransferMemoView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/7/24.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXTransferMemoView : UIView

/** 名称标签 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 背景图 */
@property (strong, nonatomic) UIView *banView;

/** 单位标签 */
@property (strong, nonatomic) XXLabel *unitLabel;

/** 输入框 */
@property (strong, nonatomic) XXTextField *textField;

@end

NS_ASSUME_NONNULL_END
