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
    self.contentSize = CGSizeMake(0, 500);
    // 提币主视图
    [self addSubview:self.mainView];
    
    /** 手续费 */
    [self.mainView addSubview:self.feeView];

    /** 提币加速视图 */
    [self.mainView addSubview:self.speedView];

    /** 提示语视图 */
    [self.mainView addSubview:self.tipView];
}

/** 地址视图 */
- (UIView *)mainView {
    if (_mainView == nil) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 500)];
        _mainView.backgroundColor = kWhiteColor;
    }
    return _mainView;
}

/** 手续费 */
- (XXWithdrawFeeView *)feeView {
    if (_feeView == nil) {
        _feeView = [[XXWithdrawFeeView alloc] initWithFrame:CGRectMake(0, 20, kScreen_Width, 88)];
        _feeView.textField.placeholder = LocalizedString(@"PleaseEnterFee");
    }
    return _feeView;
}

/** 提币加速视图 */
- (XXWithdrawSpeedView *)speedView {
    if (_speedView == nil) {
        _speedView = [[XXWithdrawSpeedView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.feeView.frame) + 15, kScreen_Width, 72)];
        _speedView.nameLabel.text = LocalizedString(@"CashWithdrawal");
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
