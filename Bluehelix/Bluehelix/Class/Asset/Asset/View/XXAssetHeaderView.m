//
//  XXAssetHeaderView.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAssetHeaderView.h"
#import "XXAddNewAssetVC.h"
#import "XXAssetModel.h"
#import "XXTokenModel.h"
#import "XCQrCodeTool.h"
#import "XXAddWalletVC.h"
#import "XXValidatorsHomeViewController.h"
#import "XXTransferVC.h"
#import "XXChainAddressView.h"
#import "XXDepositCoinVC.h"

@interface XXAssetHeaderView ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) XXLabel *nameLabel;
@property (nonatomic, strong) XXLabel *addressLabel;
@property (nonatomic, strong) XXButton *codeBtn;
@property (nonatomic, strong) XXButton *scanBtn;
@property (nonatomic, strong) XXButton *addAccountBtn;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) XXLabel *logoLabel;
@property (nonatomic, strong) XXButton *hidenAssetsButton;
@property (nonatomic, strong) XXLabel *assetNameLabel;
@property (nonatomic, strong) XXLabel *totalAssetLabel;
@property (nonatomic, strong) XXLabel *assetSymbolLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) XXButton *receiveMoneyBtn;
@property (nonatomic, strong) XXButton *transferMoneyBtn;
@property (nonatomic, strong) XXButton *delegateBtn;
@property (nonatomic, strong) XXButton *copyButton;
@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) UIView *lineView2;
@end

@implementation XXAssetHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.backImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.addressLabel];
        [self addSubview:self.codeBtn];
        [self addSubview:self.addAccountBtn];
        [self addSubview:self.scanBtn];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.logoLabel];
        [self.contentView addSubview:self.assetNameLabel];
        [self.contentView addSubview:self.assetSymbolLabel];
        [self.contentView addSubview:self.totalAssetLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.receiveMoneyBtn];
        [self.contentView addSubview:self.transferMoneyBtn];
        [self.contentView addSubview:self.delegateBtn];
        [self.contentView addSubview:self.lineView1];
        [self.contentView addSubview:self.lineView2];
        [self.contentView addSubview:self.hidenAssetsButton];
    }
    return self;
}

- (void)configData:(XXAssetModel *)model {
    if (KUser.isHideAsset) {
        self.totalAssetLabel.text = @"***";
        self.assetSymbolLabel.hidden = YES;
    } else {
        double totalAsset = 0;
        for (XXTokenModel *tokenModel in model.assets) {
            double rate = [self getRatesFromToken:tokenModel.symbol];
            if (rate > 0) {
                totalAsset += [tokenModel.amount doubleValue] * rate;
            }
        }
        self.assetSymbolLabel.text = [RatesManager shareRatesManager].rateUnit;
        self.totalAssetLabel.text = [NSString stringWithFormat:@"%.2f",totalAsset];
        self.assetSymbolLabel.hidden = NO;
    }
}

#pragma mark -扫描
- (void)scanAction {
//    MJWeakSelf
//    [XCQrCodeTool readQrCode:self.viewController callBack:^(id data) {
//        if ([data isKindOfClass:[NSString class]]) {
//        }
//    }];
}

#pragma mark -添加账户
- (void)addAccountAction {
    XXAddWalletVC *addVC = [[XXAddWalletVC alloc] init];
    [self.viewController.navigationController pushViewController:addVC animated:YES];
}

- (double)getRatesFromToken:(NSString *)token {
    NSDictionary *dic = [RatesManager shareRatesManager].dataDic[token];
        if (dic) {
            return [dic[KUser.ratesKey] doubleValue];
        } else {
            return 0;
        }
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 180)];
        _backImageView.image = [UIImage imageNamed:@"assetHeaderBack"];
    }
    return _backImageView;
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), 44, kScreen_Width - K375(90), 24) font:kFontBold(20) textColor:[UIColor whiteColor]];
        _nameLabel.text = [NSString stringWithFormat:@"Hello, %@",KUser.currentAccount.userName];
    }
    return _nameLabel;
}

- (XXLabel *)addressLabel {
    if (!_addressLabel) {
        CGFloat width = [NSString widthWithText:kAddressReplace(KUser.address) font:kFont12];
        CGFloat maxWidth = kScreen_Width - K375(16) - 40;
        width = width > maxWidth ? maxWidth : width;
        _addressLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.nameLabel.frame) + 10, width, 16) font:kFont12 textColor:[UIColor whiteColor]];
        _addressLabel.text = kAddressReplace(KUser.address);
    }
    return _addressLabel;
}

- (XXButton *)codeBtn {
    if (!_codeBtn) {
        _codeBtn = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.addressLabel.frame) + 6, self.addressLabel.top, 16, 16) block:^(UIButton *button) {
            [XXChainAddressView showMainAccountAddress];
        }];
        [_codeBtn setImage:[UIImage imageNamed:@"codeCircle"] forState:UIControlStateNormal];
    }
    return _codeBtn;
}

- (XXButton *)addAccountBtn {
    if (_addAccountBtn == nil) {
        MJWeakSelf
        _addAccountBtn = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - 44, 74, 24, 24) block:^(UIButton *button) {
            [weakSelf addAccountAction];
        }];
        [_addAccountBtn setImage:[UIImage imageNamed:@"asset_addAccount"] forState:UIControlStateNormal];
    }
    return _addAccountBtn;
}

- (XXButton *)scanBtn {
    if (_scanBtn == nil) {
        MJWeakSelf
        _scanBtn = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - 88, 74, 24, 24) block:^(UIButton *button) {
            [weakSelf scanAction];
        }];
        [_scanBtn setImage:[UIImage imageNamed:@"asset_scan"] forState:UIControlStateNormal];
    }
    return _scanBtn;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(K375(16), 110, kScreen_Width - K375(32), 180)];
        _contentView.layer.cornerRadius = 10;
        _contentView.backgroundColor = kBackgroundLeverSecond;
        _contentView.layer.shadowColor = [kShadowColor CGColor];
        _contentView.layer.shadowOffset = CGSizeMake(0, 2);
        _contentView.layer.shadowOpacity = 1.0;
        _contentView.layer.shadowRadius = 2;
    }
    return _contentView;
}

- (UIImageView *)logoImageView {
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 18, 18, 16)];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoImageView.image = [UIImage imageNamed:@"asset_logo"];
    }
    return _logoImageView;
}

- (XXLabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = [XXLabel labelWithFrame:CGRectMake(40, 18, 100, 16) font:kFontBold(13) textColor:kGray700];
        _logoLabel.text = LocalizedString(@"logoName");
        _logoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _logoLabel;
}

- (XXButton *)copyButton {
    if (_copyButton == nil) {
        _copyButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.addressLabel.frame), self.addressLabel.top - 12, 40, 40) block:^(UIButton *button) {
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

- (XXButton *)hidenAssetsButton {
    if (_hidenAssetsButton == nil) {
        MJWeakSelf
        _hidenAssetsButton = [XXButton buttonWithFrame:CGRectMake(self.contentView.width - 44, 16, 24, 24) block:^(UIButton *button) {
            KUser.isHideAsset = !KUser.isHideAsset;
            weakSelf.hidenAssetsButton.selected = KUser.isHideAsset;
            if (weakSelf.actionBlock) {
                weakSelf.actionBlock();
            }
        }];
        [_hidenAssetsButton setImage:[UIImage imageNamed:@"unhidden"] forState:UIControlStateNormal];
        [_hidenAssetsButton setImage:[UIImage subTextImageName:@"eyehidden"] forState:UIControlStateSelected];
        _hidenAssetsButton.selected = KUser.isHideAsset;
    }
    return _hidenAssetsButton;
}

- (XXLabel *)assetNameLabel {
    if (!_assetNameLabel) {
        NSString *text = NSLocalizedFormatString(LocalizedString(@"TotalAsset"),[KUser.ratesKey uppercaseString]);
        CGFloat width = [NSString widthWithText:text font:kFont12];
        _assetNameLabel = [XXLabel labelWithFrame:CGRectMake(20, CGRectGetMaxY(self.logoLabel.frame) + 20, width, 16) font:kFont(12) textColor:kGray700];
        _assetNameLabel.text = text;
    }
    return _assetNameLabel;
}

- (XXLabel *)assetSymbolLabel {
    if (!_assetSymbolLabel) {
        _assetSymbolLabel = [XXLabel labelWithFrame:CGRectMake(20, CGRectGetMaxY(self.assetNameLabel.frame) + 14, 12, 19) text:@"" font:kFontBold16 textColor:kGray700];
    }
    return _assetSymbolLabel;
}

- (XXLabel *)totalAssetLabel {
    if (!_totalAssetLabel) {
        _totalAssetLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.assetSymbolLabel.frame), CGRectGetMaxY(self.assetNameLabel.frame) + 4, self.contentView.width - K375(40), 32) font:kNumberFontBold(30) textColor:kGray700Special];
    }
    return _totalAssetLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 128, self.contentView.width, KLine_Height)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

- (XXButton *)receiveMoneyBtn {
    if (_receiveMoneyBtn == nil) {
        MJWeakSelf
        _receiveMoneyBtn = [XXButton buttonWithFrame:CGRectMake(0, 129, self.contentView.width/3, self.contentView.height - 129) title:LocalizedString(@"ReceiveMoney") font:kFont13 titleColor:kGray500 block:^(UIButton *button) {
            XXDepositCoinVC *depositVC = [[XXDepositCoinVC alloc] init];
            depositVC.symbol = kMainToken;
            [weakSelf.viewController.navigationController pushViewController:depositVC animated:YES];
        }];
        _receiveMoneyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        if (kIsNight) {
            [_receiveMoneyBtn setImage:[UIImage imageNamed:@"receiveMoney_Night"] forState:UIControlStateNormal];
        } else {
            [_receiveMoneyBtn setImage:[UIImage imageNamed:@"receiveMoney"] forState:UIControlStateNormal];
        }
    }
    return _receiveMoneyBtn;
}

- (XXButton *)transferMoneyBtn {
    if (_transferMoneyBtn == nil) {
        MJWeakSelf
        _transferMoneyBtn = [XXButton buttonWithFrame:CGRectMake(self.contentView.width/3, 129, self.contentView.width/3, self.contentView.height - 129) title:LocalizedString(@"Transfer") font:kFont13 titleColor:kGray500 block:^(UIButton *button) {
            XXTransferVC *transferVC = [[XXTransferVC alloc] init];
            transferVC.symbol = kMainToken;
            [weakSelf.viewController.navigationController pushViewController:transferVC animated:YES];
        }];
        _transferMoneyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        if (kIsNight) {
            [_transferMoneyBtn setImage:[UIImage imageNamed:@"payMoney_Night"] forState:UIControlStateNormal
            ];
        } else {
            [_transferMoneyBtn setImage:[UIImage imageNamed:@"payMoney"] forState:UIControlStateNormal
            ];
        }
    }
    return _transferMoneyBtn;
}

- (XXButton *)delegateBtn {
    if (_delegateBtn == nil) {
        MJWeakSelf
        _delegateBtn = [XXButton buttonWithFrame:CGRectMake(self.contentView.width*2/3, 129, self.contentView.width/3, self.contentView.height - 129) title:LocalizedString(@"Delegate") font:kFont13 titleColor:kGray500 block:^(UIButton *button) {
            XXValidatorsHomeViewController *validatorVC = [[XXValidatorsHomeViewController alloc] init];
            [weakSelf.viewController.navigationController pushViewController:validatorVC animated:YES];
        }];
        _delegateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        if (kIsNight) {
            [_delegateBtn setImage:[UIImage imageNamed:@"withdrawMoney_Night"] forState:UIControlStateNormal];
        } else {
            [_delegateBtn setImage:[UIImage imageNamed:@"withdrawMoney"] forState:UIControlStateNormal];
        }
        
    }
    return _delegateBtn;
}

- (UIView *)lineView1 {
    if (_lineView1 == nil) {
        _lineView1 = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.width/3, CGRectGetMaxY(self.lineView.frame) + 18, 1, 16)];
        _lineView1.backgroundColor = KLine_Color;
    }
    return _lineView1;
}

- (UIView *)lineView2 {
    if (_lineView2 == nil) {
        _lineView2 = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.width*2/3, CGRectGetMaxY(self.lineView.frame) + 18, 1, 16)];
        _lineView2.backgroundColor = KLine_Color;
    }
    return _lineView2;
}
@end
