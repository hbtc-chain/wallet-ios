//
//  XXCoinPublishApplyView.m
//  Bluehelix
//
//  Created by BHEX on 2020/5/19.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXCoinPublishApplyView.h"
#import "XCQrCodeTool.h"

@implementation XXCoinPublishApplyView

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
    self.contentSize = CGSizeMake(0, 620);
    
    [self addSubview:self.mainView];
        
    [self.mainView addSubview:self.addressView];
    
    [self.mainView addSubview:self.nameView];
    
    [self.mainView addSubview:self.amountView];
    
    [self.mainView addSubview:self.precisionView];

    [self.mainView addSubview:self.feeView];
    
    [self.mainView addSubview:self.speedView];

}

-(void)sliderValueChanged:(UISlider *)slider {
    self.feeView.textField.text = [NSString stringWithFormat:@"%.3f",slider.value];
}

- (void)scanCodeGetAddress {
    MJWeakSelf
    [XCQrCodeTool readQrCode:self.viewController callBack:^(id data) {
        if ([data isKindOfClass:[NSString class]]) {
            weakSelf.addressView.textField.text = data;
        }
    }];
}

- (UIView *)mainView {
    if (_mainView == nil) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 620)];
        _mainView.backgroundColor = kWhiteColor;
    }
    return _mainView;
}

- (XXWithdrawAddressView *)addressView {
    if (_addressView == nil) {
        _addressView = [[XXWithdrawAddressView alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, 88)];
        _addressView.nameLabel.text = LocalizedString(@"AssetAddress");
    }
    return _addressView;
}

- (XXCoinPublishNameView *)nameView {
    if (_nameView == nil) {
        _nameView = [[XXCoinPublishNameView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addressView.frame) + 15, kScreen_Width, 88)];
        _nameView.nameLabel.text = LocalizedString(@"PublishTokenName");
        _nameView.textField.placeholder = LocalizedString(@"EnterPublishTokenName");
    }
    return _nameView;
}

- (XXCoinPublishNameView *)amountView {
    if (_amountView == nil) {
        _amountView = [[XXCoinPublishNameView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameView.frame) + 15, kScreen_Width, 88)];
        _amountView.nameLabel.text = LocalizedString(@"TotalPublishAmount");
        _amountView.textField.placeholder = LocalizedString(@"EnterTotalPublishAmount");
        _amountView.textField.keyboardType = UIKeyboardTypeNumberPad;

    }
    return _amountView;
}

- (XXCoinPublishNameView *)precisionView {
    if (_precisionView == nil) {
        _precisionView = [[XXCoinPublishNameView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.amountView.frame) + 15, kScreen_Width, 88)];
        _precisionView.nameLabel.text = LocalizedString(@"Precision");
        _precisionView.textField.placeholder = LocalizedString(@"LeastPrecision");
        _precisionView.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _precisionView;
}

- (XXWithdrawFeeView *)feeView {
    if (_feeView == nil) {
        _feeView = [[XXWithdrawFeeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.precisionView.frame) + 15, kScreen_Width, 88)];
        _feeView.textField.placeholder = LocalizedString(@"PleaseEnterFee");
        _feeView.nameLabel.text = LocalizedString(@"Fee");
    }
    return _feeView;
}

- (XXWithdrawSpeedView *)speedView {
    if (_speedView == nil) {
        _speedView = [[XXWithdrawSpeedView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.feeView.frame) + 15, kScreen_Width, 72)];
        _speedView.nameLabel.text = LocalizedString(@"TransferSpeed");
         [_speedView.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _speedView;
}

@end
