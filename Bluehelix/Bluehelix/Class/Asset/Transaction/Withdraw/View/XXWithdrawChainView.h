//
//  XXWithdrawChainView.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXWithdrawFeeView.h"
#import "XXWithdrawSpeedView.h"
#import "XXWithdrawTipView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXWithdrawChainView : UIScrollView

/** 提币主视图 */
@property (strong, nonatomic) UIView *mainView;

/** 手续费 */
@property (strong, nonatomic) XXWithdrawFeeView *feeView;

/** 提币加速视图 */
@property (strong, nonatomic) XXWithdrawSpeedView *speedView;

/** 提示语视图 */
@property (strong, nonatomic) XXWithdrawTipView *tipView;


@end

NS_ASSUME_NONNULL_END
