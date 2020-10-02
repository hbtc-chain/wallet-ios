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
@property (strong, nonatomic) UIView *topBackView;
@property (strong, nonatomic) XXLabel *chainNameLabel;

@property (strong, nonatomic) XXLabel *titleAddressLabel;
@property (strong, nonatomic) XXLabel *addressLabel;
@property (strong, nonatomic) XXButton *copyButton;
@property (strong, nonatomic) XXButton *codeBtn;

@property (strong, nonatomic) UIView *lineView;

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
    [self.backView addSubview:self.topBackView];
    [self.backView addSubview:self.chainNameLabel];
    [self.backView addSubview:self.titleAddressLabel];
    [self.backView addSubview:self.addressLabel];
    [self.backView addSubview:self.copyButton];
    [self.backView addSubview:self.codeBtn];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.titleChainAddressLabel];
    if (IsEmpty(self.chainAddress)) {
        [self.backView addSubview:self.createChainBtn];
    } else {
        [self.backView addSubview:self.chainAddressLabel];
        [self.backView addSubview:self.chainCopyButton];
        [self.backView addSubview:self.chainCodeBtn];
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
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.shadowColor = [kShadowColor CGColor];
        _backView.layer.shadowOffset = CGSizeMake(0, 0);
        _backView.layer.shadowOpacity = 1.0;
        _backView.layer.shadowRadius = 8;
    }
    return _backView;
}

- (UIView *)topBackView {
    if (!_topBackView) {
        _topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.backView.width, 48)];
        _topBackView.backgroundColor = kPrimaryMain;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_topBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _topBackView.bounds;
        maskLayer.path = maskPath.CGPath;
        _topBackView.layer.mask = maskLayer;
    }
    return _topBackView;
}

- (XXLabel *)chainNameLabel {
    if (!_chainNameLabel) {
        _chainNameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), 8, kScreen_Width, 32) font:kFont20 textColor:[UIColor whiteColor]];
    }
    return _chainNameLabel;
}

- (XXLabel *)titleAddressLabel {
    if (!_titleAddressLabel) {
        _titleAddressLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), 64, self.backView.width - K375(32), 24) text:LocalizedString(@"ChainTitle") font:kFont13 textColor:kGray500];
    }
    return _titleAddressLabel;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        CGFloat width = [NSString widthWithText:[NSString addressShortReplace:KUser.address] font:kFont13];
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.titleAddressLabel.frame), width, 24) font:kFont13 textColor:kGray700];
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
        [_copyButton setImage:[UIImage imageNamed:@"pasteBlack"] forState:UIControlStateNormal];
    }
    return _copyButton;
}

- (XXButton *)codeBtn {
    if (!_codeBtn) {
        _codeBtn = [XXButton buttonWithFrame:CGRectMake(self.backView.width - 45, self.addressLabel.top, 24, 24) block:^(UIButton *button) {
            [XXChainAddressView showWithAddress:KUser.address];
        }];
        [_codeBtn setImage:[UIImage imageNamed:@"chainCodeBlack"] forState:UIControlStateNormal];
    }
    return _codeBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.addressLabel.frame) + 8, self.backView.width - K375(32), 1)];
        _lineView.backgroundColor = kGray200;
    }
    return _lineView;
}

- (XXLabel *)titleChainAddressLabel {
    if (!_titleChainAddressLabel) {
        _titleChainAddressLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.lineView.frame) + 8, self.backView.width - K375(32), 24) text:LocalizedString(@"WithdrawChainTitle") font:kFont13 textColor:kGray500];
    }
    return _titleChainAddressLabel;
}

- (XXButton *)createChainBtn {
    if (_createChainBtn == nil) {
        MJWeakSelf
        _createChainBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.titleChainAddressLabel.frame), 200, 24) block:^(UIButton *button) {
            [weakSelf createChain];
        }];
        [_createChainBtn.titleLabel setFont:kFont13];
        [_createChainBtn setTitle:LocalizedString(@"ClickWithdrawChainAddress") forState:UIControlStateNormal];
        [_createChainBtn setTitleColor:kPrimaryMain forState:UIControlStateNormal];
        [_createChainBtn setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    }
    return _createChainBtn;
}

- (XXLabel *)chainAddressLabel {
    if (!_chainAddressLabel) {
        CGFloat width = [NSString widthWithText:[NSString addressShortReplace:self.chainAddress] font:kFont13];
        _chainAddressLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.titleChainAddressLabel.frame), width, 24) font:kFont13 textColor:kGray700];
        _chainAddressLabel.text = [NSString addressShortReplace:self.chainAddress];
    }
    return _chainAddressLabel;
}

- (XXButton *)chainCopyButton {
    if (_chainCopyButton == nil) {
        MJWeakSelf
        _chainCopyButton = [XXButton buttonWithFrame:CGRectMake(self.backView.width - 80, self.chainAddressLabel.top, 24, 24) block:^(UIButton *button) {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            [pab setString:weakSelf.chainAddress];
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"CopySuccessfully") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
        }];
        [_chainCopyButton setImage:[UIImage imageNamed:@"pasteBlack"] forState:UIControlStateNormal];
    }
    return _chainCopyButton;
}

- (XXButton *)chainCodeBtn {
    if (!_chainCodeBtn) {
        MJWeakSelf
        _chainCodeBtn = [XXButton buttonWithFrame:CGRectMake(self.backView.width - 45, self.chainAddressLabel.top, 24, 24) block:^(UIButton *button) {
            [XXChainAddressView showWithAddress:weakSelf.chainAddress];
        }];
        [_chainCodeBtn setImage:[UIImage imageNamed:@"chainCodeBlack"] forState:UIControlStateNormal];
    }
    return _chainCodeBtn;
}

@end
