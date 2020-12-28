//
//  XXDelegateTransferView.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXValidatorPrefixHeader.h"
#import "XXTransferTipView.h"
#import "XXDelegateAddressView.h"
#import "XXTransferAmountView.h"
#import "XXWithdrawFeeView.h"
#import "XXWithdrawSpeedView.h"
#import "XXWithdrawTipView.h"
#import "XXHadDelegateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXDelegateTransferView : UIScrollView
@property (nonatomic, assign) XXDelegateNodeType delegateNodeType;
/** 主视图 */
@property (strong, nonatomic) UIView *mainView;

@property (nonatomic, strong) XXTransferTipView *transferTipView;
/** 委托地址 */
@property (strong, nonatomic) XXDelegateAddressView *addressView;

/** 委托数量 */
@property (strong, nonatomic) XXTransferAmountView *amountView;

/**实际委托数量*/
@property (strong, nonatomic) XXWithdrawFeeView *trueAmountView;

/** 手续费 */
@property (strong, nonatomic) XXWithdrawFeeView *feeView;

/** 提示语视图 */
@property (strong, nonatomic) XXWithdrawTipView *tipView;

/**刷新资产可用*/
- (void)refreshAssets:(XXTokenModel*)tokenModel;
/**刷新解委托可解*/
- (void)refreshRelieveAssets:(XXHadDelegateModel*)hadDelegateModel;
@end

NS_ASSUME_NONNULL_END
