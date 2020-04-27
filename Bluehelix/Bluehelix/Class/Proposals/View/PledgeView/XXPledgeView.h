//
//  XXPledgeView.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/26.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTransferTipView.h"
#import "XXTransferAmountView.h"
#import "XXWithdrawFeeView.h"
#import "XXWithdrawSpeedView.h"
#import "XXWithdrawTipView.h"
#import "XXHadDelegateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXPledgeView : UIScrollView

/** 主视图 */
@property (strong, nonatomic) UIView *mainView;

///** 提醒内容 */
@property (strong, nonatomic) XXTransferTipView *transferTipView;

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

/**刷新资产可用*/
- (void)refreshAssets:(XXTokenModel*)tokenModel;
@end

NS_ASSUME_NONNULL_END
