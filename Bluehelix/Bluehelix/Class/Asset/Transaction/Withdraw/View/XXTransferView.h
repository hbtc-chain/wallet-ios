//
//  XXTransferView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/04/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXWithdrawAddressView.h"
#import "XXWithdrawAmountView.h"
#import "XXWithdrawAmountReceivedView.h"
#import "XXWithdrawFeeView.h"
#import "XXWithdrawSpeedView.h"
#import "XXWithdrawTipView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXTransferView : UIScrollView

/** 转账主视图 */
@property (strong, nonatomic) UIView *mainView;

/** 转账地址视图 */
@property (strong, nonatomic) XXWithdrawAddressView *addressView;

/** 转账数量 */
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
