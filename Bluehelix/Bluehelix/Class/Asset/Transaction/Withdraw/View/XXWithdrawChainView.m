//
//  XXWithdrawChainView.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXWithdrawChainView.h"

@implementation XXWithdrawChainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        
        [self setupUI];
    }
    return self;
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    [self addSubview:self.mainView];
    [self.mainView addSubview:self.tipView];
    [self.mainView addSubview:self.createFeeNameLabel];
    [self.mainView addSubview:self.feeNameLabel];
    [self.mainView addSubview:self.createFeeLabel];
    [self.mainView addSubview:self.feeLabel];
}

/** 地址视图 */
- (UIView *)mainView {
    if (_mainView == nil) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.height)];
        _mainView.backgroundColor = kWhiteColor;
    }
    return _mainView;
}

- (XXTransferTipView *)tipView {
    if (_tipView == nil) {
        _tipView = [[XXTransferTipView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 143)];
    }
    return _tipView;
}

- (XXLabel *)createFeeNameLabel {
    if (_createFeeNameLabel == nil) {
        _createFeeNameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipView.frame) + 32, 100, 24) text:LocalizedString(@"CreateFee") font:kFont14 textColor:kGray500 alignment:NSTextAlignmentLeft];
    }
    return _createFeeNameLabel;
}

- (XXLabel *)feeNameLabel {
    if (_feeNameLabel == nil) {
        _feeNameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.createFeeNameLabel.frame) + 32, 100, 24) text:LocalizedString(@"Fee") font:kFont14 textColor:kGray500 alignment:NSTextAlignmentLeft];
    }
    return _feeNameLabel;
}

- (XXLabel *)createFeeLabel {
    if (_createFeeLabel == nil) {
        _createFeeLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.createFeeNameLabel.frame), CGRectGetMaxY(self.tipView.frame) + 32, kScreen_Width - CGRectGetMaxX(self.createFeeNameLabel.frame) - 22, 24) text:@"" font:kFont15 textColor:kGray700 alignment:NSTextAlignmentRight];
    }
    return _createFeeLabel;
}

- (XXLabel *)feeLabel {
    if (_feeLabel == nil) {
        _feeLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.feeNameLabel.frame), CGRectGetMaxY(self.createFeeLabel.frame) + 32, kScreen_Width - CGRectGetMaxX(self.feeNameLabel.frame) - 22, 24) text:@"" font:kFont15 textColor:kGray700 alignment:NSTextAlignmentRight];
    }
    return _feeLabel;
}

@end
