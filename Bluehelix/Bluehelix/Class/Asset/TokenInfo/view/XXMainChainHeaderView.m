//
//  XXMainChainHeaderView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/10/2.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXMainChainHeaderView.h"
#import "XXChainAddressView.h"
#import "XXAssetSingleManager.h"
#import "XXWithdrawChainVC.h"
#import "XXTokenModel.h"

@interface XXMainChainHeaderView ()

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) XXLabel *chainNameLabel;
@property (strong, nonatomic) XXLabel *titleAddressLabel;
@property (strong, nonatomic) XXLabel *addressLabel;
@property (strong, nonatomic) XXButton *copyButton;
@property (strong, nonatomic) XXButton *codeBtn;

@end

@implementation XXMainChainHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.backgroundColor = kWhiteColor;
    [self addSubview:self.backView];
    [self.backView addSubview:self.chainNameLabel];
    [self.backView addSubview:self.titleAddressLabel];
    [self.backView addSubview:self.addressLabel];
    [self.backView addSubview:self.copyButton];
    [self.backView addSubview:self.codeBtn];
    self.chainNameLabel.text = [kMainToken uppercaseString];
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

- (XXLabel *)titleAddressLabel {
    if (!_titleAddressLabel) {
        _titleAddressLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.chainNameLabel.frame), self.backView.width - K375(32), 24) text:LocalizedString(@"ChainTitle") font:kFont13 textColor:[UIColor whiteColor]];
    }
    return _titleAddressLabel;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        CGFloat width = [NSString widthWithText:[NSString addressShortReplace:KUser.address] font:kFont13];
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.titleAddressLabel.frame), width, 24) font:kFont13 textColor:[UIColor whiteColor]];
        _addressLabel.text = [NSString addressShortReplace:KUser.address];
    }
    return _addressLabel;
}

- (XXButton *)copyButton {
    if (_copyButton == nil) {
        _copyButton = [XXButton buttonWithFrame:CGRectMake(self.backView.width - 80, self.addressLabel.top, 24, 24) block:^(UIButton *button) {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            [pab setString:KUser.address];
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
        _codeBtn = [XXButton buttonWithFrame:CGRectMake( self.backView.width - 45, self.addressLabel.top, 24, 24) block:^(UIButton *button) {
            [XXChainAddressView showWithAddress:KUser.address];
        }];
        [_codeBtn setImage:[UIImage imageNamed:@"chainCode"] forState:UIControlStateNormal];
    }
    return _codeBtn;
}

@end
