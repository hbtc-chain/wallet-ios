//
//  XXCoinPublishApplyView.h
//  Bluehelix
//
//  Created by BHEX on 2020/5/19.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXWithdrawAddressView.h"
#import "XXCoinPublishNameView.h"
#import "XXWithdrawAmountView.h"
#import "XXWithdrawFeeView.h"
#import "XXWithdrawSpeedView.h"
NS_ASSUME_NONNULL_BEGIN

@interface XXCoinPublishApplyView : UIScrollView

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) XXWithdrawAddressView *addressView;

@property (strong, nonatomic) XXCoinPublishNameView *nameView;

@property (strong, nonatomic) XXCoinPublishNameView *amountView;

@property (strong, nonatomic) XXCoinPublishNameView *precisionView;

@property (strong, nonatomic) XXWithdrawFeeView *feeView;

@property (strong, nonatomic) XXWithdrawSpeedView *speedView;

@end

NS_ASSUME_NONNULL_END
