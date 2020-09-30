//
//  XXChainHeaderView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/3.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChainHeaderView.h"
#import "XXChainAddressView.h"
#import "XXAssetSingleManager.h"
#import "XXWithdrawChainVC.h"
#import "XXTokenModel.h"

@interface XXChainHeaderView ()

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) XXLabel *chainNameLabel;

@property (strong, nonatomic) XXLabel *titleAddressLabel;
@property (strong, nonatomic) XXLabel *addressLabel;
@property (strong, nonatomic) XXButton *copyButton;
@property (strong, nonatomic) XXButton *codeBtn;

@property (strong, nonatomic) XXLabel *titleChainAddressLabel;
@property (strong, nonatomic) XXLabel *chainAddressLabel;
@property (strong, nonatomic) XXButton *chainCopyButton;
@property (strong, nonatomic) XXButton *chainCodeBtn;
@property (strong, nonatomic) XXButton *createChainBtn;

@property (nonatomic, copy) NSString *chainAddress; //跨链地址

@end

@implementation XXChainHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
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
    if (![self.chain isEqualToString:kMainToken]) {
        [self.backView addSubview:self.titleChainAddressLabel];
        if (IsEmpty(self.chainAddress)) {
            [self.backView addSubview:self.createChainBtn];
        } else {
            [self.backView addSubview:self.chainAddressLabel];
            [self.backView addSubview:self.chainCopyButton];
            [self.backView addSubview:self.chainCodeBtn];
        }
    }
}

// TODO 这里到底是chain 还是token
- (void)createChain {
    XXWithdrawChainVC *chain = [[XXWithdrawChainVC alloc] init];
    chain.tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:self.chain];
    [self.viewController.navigationController pushViewController:chain animated:YES];
}

- (void)setChain:(NSString *)chain {
    _chain = chain;
    self.chainAddress = [[XXAssetSingleManager sharedManager] externalAddressBySymbol:chain];
    [self.backView removeAllSubviews];
    [self removeAllSubviews];
    [self buildUI];
    self.chainNameLabel.text = [chain uppercaseString];
}

- (void)setChainAddress:(NSString *)chainAddress {
    _chainAddress = chainAddress;
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
        CGFloat width = [NSString widthWithText:LocalizedString(@"ChainTitle") font:kFont13];
        _titleAddressLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.chainNameLabel.frame), width, 24) text:LocalizedString(@"ChainTitle") font:kFont13 textColor:[UIColor whiteColor]];
    }
    return _titleAddressLabel;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        CGFloat width = [NSString widthWithText:[NSString addressShortReplace:KUser.address] font:kFont13];
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.titleAddressLabel.frame) + 4, self.titleAddressLabel.top, width, 24) font:kFont13 textColor:[UIColor whiteColor]];
        _addressLabel.text = [NSString addressShortReplace:KUser.address];
    }
    return _addressLabel;
}

- (XXButton *)copyButton {
    if (_copyButton == nil) {
        _copyButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.addressLabel.frame), self.addressLabel.top, 24, 24) block:^(UIButton *button) {
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
        _codeBtn = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.copyButton.frame) + 4, self.addressLabel.top, 24, 24) block:^(UIButton *button) {
            [XXChainAddressView showWithAddress:KUser.address];
        }];
        [_codeBtn setImage:[UIImage imageNamed:@"chainCode"] forState:UIControlStateNormal];
    }
    return _codeBtn;
}

- (XXLabel *)titleChainAddressLabel {
    if (!_titleChainAddressLabel) {
        CGFloat width = [NSString widthWithText:LocalizedString(@"WithdrawChainTitle") font:kFont13];
        _titleChainAddressLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.titleAddressLabel.frame) + 10, width, 24) text:LocalizedString(@"WithdrawChainTitle") font:kFont13 textColor:[UIColor whiteColor]];
    }
    return _titleChainAddressLabel;
}

- (XXButton *)createChainBtn {
    if (_createChainBtn == nil) {
        MJWeakSelf
        _createChainBtn = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.titleChainAddressLabel.frame) + 4, self.titleChainAddressLabel.top, 100, 24) block:^(UIButton *button) {
            [weakSelf createChain];
        }];
        _createChainBtn.layer.borderWidth = 1;
        _createChainBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_createChainBtn.titleLabel setFont:kFont13];
        [_createChainBtn setTitle:LocalizedString(@"WithdrawChainAddress") forState:UIControlStateNormal];
    }
    return _createChainBtn;
}

- (XXLabel *)chainAddressLabel {
    if (!_chainAddressLabel) {
        CGFloat width = [NSString widthWithText:[NSString addressShortReplace:self.chainAddress] font:kFont13];
        _chainAddressLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.titleChainAddressLabel.frame) + 4, self.titleChainAddressLabel.top, width, 24) font:kFont13 textColor:[UIColor whiteColor]];
        _chainAddressLabel.text = [NSString addressShortReplace:self.chainAddress];
    }
    return _chainAddressLabel;
}

- (XXButton *)chainCopyButton {
    if (_chainCopyButton == nil) {
        MJWeakSelf
        _chainCopyButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.chainAddressLabel.frame), self.chainAddressLabel.top, 24, 24) block:^(UIButton *button) {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            [pab setString:weakSelf.chainAddress];
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CopySuccessfully") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
        }];
        [_chainCopyButton setImage:[UIImage imageNamed:@"paste"] forState:UIControlStateNormal];
    }
    return _chainCopyButton;
}

- (XXButton *)chainCodeBtn {
    if (!_chainCodeBtn) {
        MJWeakSelf
        _chainCodeBtn = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.chainCopyButton.frame) + 4, self.chainAddressLabel.top, 24, 24) block:^(UIButton *button) {
            [XXChainAddressView showWithAddress:weakSelf.chainAddress];
        }];
        [_chainCodeBtn setImage:[UIImage imageNamed:@"chainCode"] forState:UIControlStateNormal];
    }
    return _chainCodeBtn;
}

@end
