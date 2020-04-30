//
//  XXWithdrawView.m
//  Bhex
//
//  Created by Bhex on 2019/12/17.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "XXWithdrawView.h"
#import "XCQrCodeTool.h"
@interface XXWithdrawView () <UITextFieldDelegate>

@end

@implementation XXWithdrawView

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
    
    [self.mainView addSubview:self.tipLabel];
    
    /** 地址  */
    [self.mainView addSubview:self.addressView];
    
    /** 提币数量 */
    [self.mainView addSubview:self.amountView];

    /** 到账数量 */
//    [self.mainView addSubview:self.receivedView];

    /** 手续费 */
    [self.mainView addSubview:self.feeView];
    
    /** 手续费 */
    [self.mainView addSubview:self.chainFeeView];

    /** 提币加速视图 */
    [self.mainView addSubview:self.speedView];

    /** 提示语视图 */
    [self.mainView addSubview:self.tipView];
}

- (void)scanCodeGetAddress {
    MJWeakSelf
    [XCQrCodeTool readQrCode:self.viewController callBack:^(id data) {
        if ([data isKindOfClass:[NSString class]]) {
            weakSelf.addressView.textField.text = data;
        }
    }];
}

/** 地址视图 */
- (UIView *)mainView {
    if (_mainView == nil) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 500)];
        _mainView.backgroundColor = kWhiteColor;
    }
    return _mainView;
}

- (XYHNumbersLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(KSpacing, 10, kScreen_Width - KSpacing*2, 0) font:kFont14];
        _tipLabel.textColor = kGray700;
        _tipLabel.text = LocalizedString(@"WithdrawTip");
    }
    return _tipLabel;
}

- (XXWithdrawAddressView *)addressView {
    if (_addressView == nil) {
        _addressView = [[XXWithdrawAddressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tipLabel.frame), kScreen_Width, 88)];
    }
    return _addressView;
}

/** 提币数量 */
- (XXWithdrawAmountView *)amountView {
    if (_amountView == nil) {
        _amountView = [[XXWithdrawAmountView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addressView.frame) + 15, kScreen_Width, 88)];
        _amountView.userInteractionEnabled = YES;
        _amountView.nameLabel.text = LocalizedString(@"WithdrawAmount");
        _amountView.textField.placeholder = LocalizedString(@"PleaseEnterAmount");
    }
    return _amountView;
}

/** 交易手续费 */
- (XXWithdrawFeeView *)feeView {
    if (_feeView == nil) {
        _feeView = [[XXWithdrawFeeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.amountView.frame) + 15, kScreen_Width, 88)];
        _feeView.textField.placeholder = LocalizedString(@"PleaseEnterFee");
        _feeView.nameLabel.text = LocalizedString(@"TransferFee");
    }
    return _feeView;
}

/** 跨链手续费 */
- (XXWithdrawFeeView *)chainFeeView {
    if (_chainFeeView == nil) {
        _chainFeeView = [[XXWithdrawFeeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.feeView.frame) + 15, kScreen_Width, 88)];
        _chainFeeView.textField.placeholder = LocalizedString(@"PleaseEnterFee");
        _chainFeeView.nameLabel.text = LocalizedString(@"ChainFee");
    }
    return _chainFeeView;
}

/** 提币加速视图 */
- (XXWithdrawSpeedView *)speedView {
    if (_speedView == nil) {
        _speedView = [[XXWithdrawSpeedView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.chainFeeView.frame) + 15, kScreen_Width, 72)];
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
