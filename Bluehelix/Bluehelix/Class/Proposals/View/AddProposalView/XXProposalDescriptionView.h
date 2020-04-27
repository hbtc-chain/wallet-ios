//
//  XXProposalDescriptionView.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/24.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSInteger MaxCount = 2500;

@interface XXProposalDescriptionView : UIView <UITextViewDelegate>
/** 名称标签 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 背景图 */
@property (strong, nonatomic) UIView *banView;

/** 单位标签 */
@property (strong, nonatomic) XXLabel *unitLabel;

/** 输入框 */
@property (strong, nonatomic) UITextView *textView;

@property (nonatomic, strong) XXLabel *countLabel;

@end

NS_ASSUME_NONNULL_END
