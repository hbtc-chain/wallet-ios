//
//  XXWithdrawView.h
//  Bhex
//
//  Created by Bhex on 2019/12/17.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXWithdrawAddressView.h"
#import "XXWithdrawAmountView.h"
#import "XXWithdrawAmountReceivedView.h"
#import "XXWithdrawFeeView.h"
#import "XXWithdrawSpeedView.h"
#import "XXWithdrawTipView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXWithdrawView : UIScrollView

/** 提币主视图 */
@property (strong, nonatomic) UIView *mainView;

/** 提币地址视图 */
@property (strong, nonatomic) XXWithdrawAddressView *addressView;

/** 提币数量 */
@property (strong, nonatomic) XXWithdrawAmountView *amountView;

/** 到账数量 */
@property (strong, nonatomic) XXWithdrawAmountReceivedView *receivedView;

/** 手续费 */
@property (strong, nonatomic) XXWithdrawFeeView *feeView;

/** 提币加速视图 */
@property (strong, nonatomic) XXWithdrawSpeedView *speedView;

/** 提示语视图 */
@property (strong, nonatomic) XXWithdrawTipView *tipView;

@end

NS_ASSUME_NONNULL_END
