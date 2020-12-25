//
//  XXTransferView.h
//  Bluehelix
//
//  Created by BHEX on 2020/04/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXWithdrawAddressView.h"
#import "XXTransferAmountView.h"
#import "XXWithdrawFeeView.h"
#import "XXWithdrawSpeedView.h"
#import "XXWithdrawTipView.h"
#import "XXTransferMemoView.h"
#import "XXTransferChooseTokenView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXTransferView : UIScrollView

/** 转账主视图 */
@property (strong, nonatomic) UIView *mainView;

/** 转出地址 */
@property (strong, nonatomic) XXWithdrawAddressView *outAddress;

/** 转账地址视图 */
@property (strong, nonatomic) XXWithdrawAddressView *addressView;

/** 转账数量 */
@property (strong, nonatomic) XXTransferAmountView *amountView;

/** 选择币种 */
@property (strong, nonatomic) XXTransferChooseTokenView *chooseTokenView;

/** 手续费 */
@property (strong, nonatomic) XXWithdrawFeeView *feeView;

/** 提币加速视图 */
@property (strong, nonatomic) XXWithdrawSpeedView *speedView;

/** 提示语视图 */
@property (strong, nonatomic) XXWithdrawTipView *tipView;

/** Memo */
@property (strong, nonatomic) XXTransferMemoView *memoView;
@end

NS_ASSUME_NONNULL_END
