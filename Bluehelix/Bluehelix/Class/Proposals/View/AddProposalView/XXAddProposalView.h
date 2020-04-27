//
//  XXAddProposalView.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/24.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXProposalPrefixHeader.h"
#import "XXProposalNormalView.h"
#import "XXProposalDescriptionView.h"
#import "XXTransferAmountView.h"
#import "XXWithdrawFeeView.h"
#import "XXWithdrawSpeedView.h"
#import "XXWithdrawTipView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXAddProposalView : UIScrollView
/** 主视图 */
@property (strong, nonatomic) UIView *mainView;

/** 标题 */
@property (strong, nonatomic) XXProposalNormalView *propotalTitleView;

/** 类型 */
@property (strong, nonatomic) XXProposalNormalView *propotalTypeSelectView;

/**提案描述*/
@property (strong, nonatomic) XXProposalDescriptionView *proposalDescriptionView;

/** 委托数量 */
@property (strong, nonatomic) XXTransferAmountView *amountView;

/**实际委托数量*/
@property (strong, nonatomic) XXWithdrawFeeView *trueAmountView;

/** 手续费 */
@property (strong, nonatomic) XXWithdrawFeeView *feeView;

/** 加速视图 */
@property (strong, nonatomic) XXWithdrawSpeedView *speedView;

/** 提示语视图 */
@property (strong, nonatomic) XXWithdrawTipView *tipView;

- (void)refreshAssets:(XXTokenModel*)tokenModel;
@end

NS_ASSUME_NONNULL_END
