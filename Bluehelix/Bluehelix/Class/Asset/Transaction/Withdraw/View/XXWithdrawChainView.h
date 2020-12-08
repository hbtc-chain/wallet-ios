//
//  XXWithdrawChainView.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXWithdrawFeeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXWithdrawChainView : UIScrollView

@property (strong, nonatomic) UIView *mainView;

/** 手续费 */
@property (strong, nonatomic) XXWithdrawFeeView *feeView;


@end

NS_ASSUME_NONNULL_END
