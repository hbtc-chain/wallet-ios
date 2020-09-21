//
//  XXChainHeaderView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/3.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChainHeaderView.h"
#import "XXChainAddressView.h"

@interface XXChainHeaderView ()

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) XXLabel *addressLabel;
@property (strong, nonatomic) XXButton *copyButton;
@property (strong, nonatomic) XXLabel *chainNameLabel;
@property (strong, nonatomic) XXButton *codeBtn;

@end

@implementation XXChainHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.backView];
        [self.backView addSubview:self.chainNameLabel];
        [self.backView addSubview:self.addressLabel];
        [self.backView addSubview:self.copyButton];
        [self.backView addSubview:self.codeBtn];
    }
    return self;
}

- (void)setChain:(NSString *)chain {
    _chain = chain;
    self.chainNameLabel.text = [chain uppercaseString];
}

- (void)setAddress:(NSString *)address {
    _address = address;
    self.addressLabel.text = address;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(16, 0, kScreen_Width - 32, self.height)];
        _backView.layer.cornerRadius = 10;
        _backView.backgroundColor = kPrimaryMain;
    }
    return _backView;
}

- (XXLabel *)chainNameLabel {
    if (!_chainNameLabel) {
        _chainNameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), K375(16), kScreen_Width, 32) font:kFont20 textColor:[UIColor whiteColor]];
    }
    return _chainNameLabel;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        CGFloat width = [NSString widthWithText:KUser.address font:kFont13];
        CGFloat maxWidth = kScreen_Width - K375(16) - 40;
        width = width > maxWidth ? maxWidth : width;
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.chainNameLabel.frame), width, 20) font:kFont13 textColor:[UIColor whiteColor]];
    }
    return _addressLabel;
}

- (XXButton *)copyButton {
    if (_copyButton == nil) {
        MJWeakSelf
        _copyButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.addressLabel.frame), self.addressLabel.top - 10, 40, 40) block:^(UIButton *button) {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            [pab setString:weakSelf.addressLabel.text];
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CopySuccessfully") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
        }];
        [_copyButton setImage:[UIImage imageNamed:@"paste"] forState:UIControlStateNormal];
    }
    return _copyButton;
}

- (XXButton *)codeBtn {
    if (!_codeBtn) {
        MJWeakSelf
        _codeBtn = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.copyButton.frame)-15, self.addressLabel.top - 14, 48, 48) block:^(UIButton *button) {
            NSLog(@"%@",self.address);
            [XXChainAddressView showWithAddress:weakSelf.address];
        }];
        [_codeBtn setImage:[UIImage imageNamed:@"chainCode"] forState:UIControlStateNormal];
    }
    return _codeBtn;
}

@end
