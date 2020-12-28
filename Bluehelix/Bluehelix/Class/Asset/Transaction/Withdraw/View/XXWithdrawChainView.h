//
//  XXWithdrawChainView.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXWithdrawFeeView.h"
#import "XXTransferTipView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXWithdrawChainView : UIScrollView

@property (strong, nonatomic) UIView *mainView;
/// 提示
@property (nonatomic, strong) XXTransferTipView *tipView;
@property (nonatomic, strong) XXLabel *createFeeNameLabel;
@property (nonatomic, strong) XXLabel *feeNameLabel;
@property (nonatomic, strong) XXLabel *createFeeLabel;
@property (nonatomic, strong) XXLabel *feeLabel;

@end

NS_ASSUME_NONNULL_END
