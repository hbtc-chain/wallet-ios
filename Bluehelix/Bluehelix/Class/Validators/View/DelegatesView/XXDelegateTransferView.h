//
//  XXDelegateTransferView.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXValidatorPrefixHeader.h"
#import "XXDelegateAddressView.h"
#import "XXTransferAmountView.h"
#import "XXWithdrawFeeView.h"
#import "XXWithdrawSpeedView.h"
#import "XXWithdrawTipView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXDelegateTransferView : UIScrollView
@property (nonatomic, assign) XXDelegateNodeType delegateNodeType;
/** 主视图 */
@property (strong, nonatomic) UIView *mainView;

/** 委托数量 */
@property (strong, nonatomic) XXDelegateAddressView *addressView;

/** 转账数量 */
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
