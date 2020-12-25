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
    self.contentSize = CGSizeMake(0, 700);
    // 提币主视图
    [self addSubview:self.mainView];
    
    /** 地址  */
    [self.mainView addSubview:self.addressView];
    
    /** 选择币种  */
    [self.mainView addSubview:self.chooseTokenView];
    
    /** 提币数量 */
    [self.mainView addSubview:self.amountView];

    /** 手续费 */
    [self.mainView addSubview:self.chainFeeView];
    
    /** 手续费 */
    [self.mainView addSubview:self.feeView];

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
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 700)];
        _mainView.backgroundColor = kWhiteColor;
    }
    return _mainView;
}

- (XXWithdrawAddressView *)addressView {
    if (_addressView == nil) {
        MJWeakSelf
        _addressView = [[XXWithdrawAddressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tipLabel.frame), kScreen_Width, 88)];
        _addressView.codeBlock = ^{
            [weakSelf scanCodeGetAddress];
        };
    }
    return _addressView;
}

- (XXTransferChooseTokenView *)chooseTokenView {
    if (_chooseTokenView == nil) {
        _chooseTokenView = [[XXTransferChooseTokenView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addressView.frame) + 15, kScreen_Width, 88)];
        _chooseTokenView.nameLabel.text = LocalizedString(@"ChooseWithdrawToken");
    }
    return _chooseTokenView;
}

/** 提币数量 */
- (XXWithdrawAmountView *)amountView {
    if (_amountView == nil) {
        _amountView = [[XXWithdrawAmountView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.chooseTokenView.frame) + 15, kScreen_Width, 88)];
        _amountView.userInteractionEnabled = YES;
        _amountView.nameLabel.text = LocalizedString(@"WithdrawAmount");
        _amountView.textField.placeholder = LocalizedString(@"PleaseEnterAmount");
    }
    return _amountView;
}

/** 跨链手续费 */
- (XXWithdrawFeeView *)chainFeeView {
    if (_chainFeeView == nil) {
        _chainFeeView = [[XXWithdrawFeeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.amountView.frame) + 15, kScreen_Width, 88)];
        _chainFeeView.textField.placeholder = LocalizedString(@"PleaseEnterFee");
        _chainFeeView.nameLabel.text = LocalizedString(@"ChainFee");
    }
    return _chainFeeView;
}

/** 交易手续费 */
- (XXWithdrawFeeView *)feeView {
    if (_feeView == nil) {
        _feeView = [[XXWithdrawFeeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.chainFeeView.frame) + 15, kScreen_Width, 88)];
        _feeView.textField.placeholder = LocalizedString(@"PleaseEnterFee");
        _feeView.nameLabel.text = LocalizedString(@"Fee");
        _feeView.textField.enabled = NO;
    }
    return _feeView;
}

/** 提示语视图 */
- (XXWithdrawTipView *)tipView {
    if (_tipView == nil) {
        _tipView = [[XXWithdrawTipView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.feeView.frame) + 15, kScreen_Width, 0)];
        _tipView.alertLabel.text = LocalizedString(@"WithdrawTip");
    }
    return _tipView;
}

@end
