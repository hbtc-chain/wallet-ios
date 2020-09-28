//
//  XXVotingView.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/27.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXVotingView.h"
#import "XXTokenModel.h"

@interface XXVotingView ()
@property (nonatomic, strong) XXTokenModel *tokenModel;
@end

@implementation XXVotingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        
        [self setupUI];
        [self loadData];
    }
    return self;
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    self.contentSize = CGSizeMake(0, 800);
    // 提币主视图
    [self addSubview:self.mainView];
    
    /** 提醒内容  */
    [self.mainView addSubview:self.transferTipView];
    
    /** 委托数量 */
    [self.mainView addSubview:self.votingActionView];
    
    /**实际委托数量*/
    //[self.mainView addSubview:self.trueAmountView];

    /** 手续费 */
    [self.mainView addSubview:self.feeView];

//    /** 加速视图 */
//    [self.mainView addSubview:self.speedView];

    /** 提示语视图 */
    [self.mainView addSubview:self.tipView];
}

- (void)loadData{

}
- (void)refreshAssets:(XXTokenModel*)tokenModel{
    self.tokenModel = tokenModel;
    self.feeView.subLabel.text = [NSString stringWithFormat:@"%@ %@ %@",LocalizedString(@"ValidatorAvilable"),self.tokenModel.amount,[kMainToken uppercaseString]];
    self.feeView.textField.text = kMinFee;
}


#pragma mark lazy load
/** 地址视图 */
- (UIView *)mainView {
    if (_mainView == nil) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 500)];
        _mainView.backgroundColor = kWhiteColor;
    }
    return _mainView;
}

- (XXTransferTipView *)transferTipView {
    if (_transferTipView == nil) {
        _transferTipView = [[XXTransferTipView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 136)];
    }
    return _transferTipView;
}
- (XXVoteActionView *)votingActionView{
    if (!_votingActionView) {
        @weakify(self)
        _votingActionView = [[XXVoteActionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.transferTipView.frame)+ 16, kScreen_Width, 260)];
        _votingActionView.itemsArray = [NSMutableArray arrayWithArray:@[LocalizedString(@"ProposalDetailVoteYes"),LocalizedString(@"ProposalDetailVoteNo"),LocalizedString(@"ProposalDetailVoteAbstain"),LocalizedString(@"ProposalDetailVoteNoWithVeto")]];
        _votingActionView.indexBtn = 0;
        _votingActionView.voteCallBlock = ^(NSString * _Nonnull voteString) {
            @strongify(self)
            if (self.voteStringBlock) {
                self.voteStringBlock(voteString);
            }
        };
    }
    return _votingActionView;
}

/** 手续费 */
- (XXWithdrawFeeView *)feeView {
    if (_feeView == nil) {
        _feeView = [[XXWithdrawFeeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.votingActionView.frame), kScreen_Width, 96)];
        //_feeView.textField.placeholder = LocalizedString(@"PleaseEnterFee");
        _feeView.textField.enabled = YES;
        _feeView.unitLabel.text = [kMainToken uppercaseString];
    }
    return _feeView;
}

/** 提币加速视图 */
- (XXWithdrawSpeedView *)speedView {
    if (_speedView == nil) {
        _speedView = [[XXWithdrawSpeedView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.feeView.frame), kScreen_Width, 72)];
        _speedView.nameLabel.text = LocalizedString(@"TransferSpeed");
//        [_speedView.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _speedView;
}

/** 提示语视图 */
- (XXWithdrawTipView *)tipView {
    if (_tipView == nil) {
        _tipView = [[XXWithdrawTipView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.speedView.frame), kScreen_Width, 10)];
    }
    return _tipView;
}

@end
