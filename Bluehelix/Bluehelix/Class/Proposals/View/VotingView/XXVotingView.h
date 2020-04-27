//
//  XXVotingView.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/27.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTransferTipView.h"
#import "XXWithdrawFeeView.h"
#import "XXWithdrawSpeedView.h"
#import "XXWithdrawTipView.h"
#import "XXVoteActionView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^XXVoteStingCallBlock) (NSString *voteString);
@interface XXVotingView : UIScrollView

@property (nonatomic, copy) XXVoteStingCallBlock voteStringBlock;
/** 主视图 */
@property (strong, nonatomic) UIView *mainView;

///** 提醒内容 */
@property (strong, nonatomic) XXTransferTipView *transferTipView;

@property (strong, nonatomic) XXVoteActionView *votingActionView;

/** 手续费 */
@property (strong, nonatomic) XXWithdrawFeeView *feeView;

/** 加速视图 */
@property (strong, nonatomic) XXWithdrawSpeedView *speedView;

/** 提示语视图 */
@property (strong, nonatomic) XXWithdrawTipView *tipView;

- (void)refreshAssets:(XXTokenModel*)tokenModel;

@end

NS_ASSUME_NONNULL_END
