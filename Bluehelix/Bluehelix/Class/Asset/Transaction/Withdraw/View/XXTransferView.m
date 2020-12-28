//
//  XXTransferView.m
//  Bluehelix
//
//  Created by BHEX on 2020/04/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTransferView.h"
#import "XCQrCodeTool.h"
@implementation XXTransferView

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
    
    [self.mainView addSubview:self.outAddress];
    
    /** 地址  */
    [self.mainView addSubview:self.addressView];
    
    [self.mainView addSubview:self.chooseTokenView];
    
    /** 提币数量 */
    [self.mainView addSubview:self.amountView];

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

-(void)sliderValueChanged:(UISlider *)slider {
    self.feeView.textField.text = [NSString stringWithFormat:@"%.3f",slider.value];
}

/** 地址视图 */
- (UIView *)mainView {
    if (_mainView == nil) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 500)];
        _mainView.backgroundColor = kWhiteColor;
    }
    return _mainView;
}

- (XXWithdrawAddressView *)outAddress {
    if (_outAddress == nil) {
        _outAddress = [[XXWithdrawAddressView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 88)];
        _outAddress.nameLabel.text = LocalizedString(@"TransferOutAddress");
        _outAddress.codeButton.hidden = YES;
        _outAddress.textField.enabled = NO;
        _outAddress.textField.width = _outAddress.banView.width - K375(16);
        _outAddress.textField.text = KUser.address;
    }
    return _outAddress;
}

- (XXWithdrawAddressView *)addressView {
    if (_addressView == nil) {
        MJWeakSelf
        _addressView = [[XXWithdrawAddressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.outAddress.frame) + 15, kScreen_Width, 88)];
        _addressView.nameLabel.text = LocalizedString(@"TransferInAddress");
        _addressView.codeBlock = ^{
            [weakSelf scanCodeGetAddress];
        };
    }
    return _addressView;
}

- (XXTransferMemoView *)memoView {
    if (_memoView == nil) {
        _memoView = [[XXTransferMemoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addressView.frame) + 15, kScreen_Width, 88)];
    }
    return _memoView;
}

- (XXTransferChooseTokenView *)chooseTokenView {
    if (_chooseTokenView == nil) {
        _chooseTokenView = [[XXTransferChooseTokenView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addressView.frame) + 15, kScreen_Width, 88)];
        _chooseTokenView.nameLabel.text = LocalizedString(@"ChooseTransferToken");
    }
    return _chooseTokenView;
}

/** 转账数量 */
- (XXTransferAmountView *)amountView {
    if (_amountView == nil) {
        _amountView = [[XXTransferAmountView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.chooseTokenView.frame) + 15, kScreen_Width, 88)];
        _amountView.userInteractionEnabled = YES;
        _amountView.nameLabel.text = LocalizedString(@"TransferAmount");
        _amountView.textField.placeholder = LocalizedString(@"PleaseEnterTransferAmount");
    }
    return _amountView;
}

/** 手续费 */
- (XXWithdrawFeeView *)feeView {
    if (_feeView == nil) {
        _feeView = [[XXWithdrawFeeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.amountView.frame) + 15, kScreen_Width, 88)];
        _feeView.textField.placeholder = LocalizedString(@"PleaseEnterFee");
        _feeView.unitLabel.text = [kMainToken uppercaseString];
        _feeView.textField.enabled = NO;
    }
    return _feeView;
}

/** 提币加速视图 */
- (XXWithdrawSpeedView *)speedView {
    if (_speedView == nil) {
        _speedView = [[XXWithdrawSpeedView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.feeView.frame) + 15, kScreen_Width, 72)];
        _speedView.nameLabel.text = LocalizedString(@"TransferSpeed");
        [_speedView.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _speedView;
}

/** 提示语视图 */
- (XXWithdrawTipView *)tipView {
    if (_tipView == nil) {
        _tipView = [[XXWithdrawTipView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.feeView.frame) + 15, kScreen_Width, 10)];
        _tipView.alertLabel.text = LocalizedString(@"TransferTip");
    }
    return _tipView;
}


@end
