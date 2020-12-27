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
@property (nonatomic, strong) XXLabel *mainNetLabel;
@property (nonatomic, strong) XXButton *scanBtn;
@property (nonatomic, strong) XXButton *addAccountBtn;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) XXLabel *logoLabel;
@property (nonatomic, strong) XXButton *hidenAssetsButton;
@property (nonatomic, strong) XXButton *getTestCoinBtn;
@property (nonatomic, strong) XXLabel *assetNameLabel;
@property (nonatomic, strong) XXLabel *totalAssetLabel;
@property (nonatomic, strong) XXLabel *assetSymbolLabel;
@property (nonatomic, strong) XXButton *receiveMoneyBtn;
@property (nonatomic, strong) XXButton *transferMoneyBtn;
@property (nonatomic, strong) XXButton *delegateBtn;
@end

@implementation XXAssetHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.logoImageView];
        [self addSubview:self.logoLabel];
        [self addSubview:self.addAccountBtn];
//        [self addSubview:self.scanBtn];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.backImageView];
        [self.contentView addSubview:self.mainNetLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.assetNameLabel];
        [self.contentView addSubview:self.assetSymbolLabel];
        [self.contentView addSubview:self.totalAssetLabel];
        [self.contentView addSubview:self.getTestCoinBtn];
        [self.contentView addSubview:self.receiveMoneyBtn];
        [self.contentView addSubview:self.transferMoneyBtn];
        [self.contentView addSubview:self.delegateBtn];
        [self.contentView addSubview:self.hidenAssetsButton];
    }
    return self;
}

- (void)requestGetTestCoin:(NSString *)denom {
    NSString *path = [NSString stringWithFormat:@"%@%@%@%@",@"/api/v1/cus/",KUser.address,@"/send_test_token?denom=",denom];
    [HttpManager getWithPath:path params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
           Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"GetTestCoinSuccess") duration:kAlertDuration completion:^{
           }];
           [alert showAlert];
        } else {
            Alert *alert = [[Alert alloc] initWithTitle:msg duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
        }
    }];
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

#pragma mark -展示地址
- (void)addressTapAction {
    [XXChainAddressView showMainAccountAddress];
}

- (double)getRatesFromToken:(NSString *)token {
    NSDictionary *dic = [RatesManager shareRatesManager].dataDic[token];
        if (dic) {
            return [dic[KUser.ratesKey] doubleValue];
        } else {
            return 0;
        }
}

- (UIImageView *)logoImageView {
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 64, 21.5, 19)];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoImageView.image = [UIImage textImageName:@"asset_logo"];
    }
    return _logoImageView;
}

- (XXLabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = [XXLabel labelWithFrame:CGRectMake(43, 64, 200, 18) font:kFontBold(20) textColor:kGray900];
        _logoLabel.text = LocalizedString(@"logoName");
        _logoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _logoLabel;
}

- (XXButton *)addAccountBtn {
    if (_addAccountBtn == nil) {
        MJWeakSelf
        _addAccountBtn = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - 44, 61, 24, 24) block:^(UIButton *button) {
            [weakSelf addAccountAction];
        }];
        [_addAccountBtn setImage:[UIImage textImageName:@"asset_addAccount"] forState:UIControlStateNormal];
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
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(K375(16), 100, kScreen_Width - K375(32), 188)];
        _contentView.layer.cornerRadius = 10;
        _contentView.backgroundColor = kBackgroundLeverSecond;
        _contentView.layer.shadowColor = [kShadowColor CGColor];
        _contentView.layer.shadowOffset = CGSizeMake(0, 2);
        _contentView.layer.shadowOpacity = 1.0;
        _contentView.layer.shadowRadius = 2;
    }
    return _contentView;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 140)];
        _backImageView.image = [UIImage imageNamed:@"assetHeaderBack"];
    }
    return _backImageView;
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(20, 20, self.contentView.width, 24) font:kFontBold(17) textColor:[UIColor whiteColor]];
        _nameLabel.text = [NSString stringWithFormat:@"Hello, %@",KUser.currentAccount.userName];
    }
    return _nameLabel;
}

- (XXLabel *)mainNetLabel {
    if (!_mainNetLabel) {
        _mainNetLabel = [XXLabel labelWithFrame:CGRectMake(self.contentView.width - 96, 0, 96, 24) text:LocalizedString(@"MainNet") font:kFont(11) textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter cornerRadius:8];
        _mainNetLabel.layer.maskedCorners = kCALayerMinXMaxYCorner;
        _mainNetLabel.backgroundColor = kPrimaryMain;
    }
    return _mainNetLabel;
}

- (XXLabel *)assetNameLabel {
    if (!_assetNameLabel) {
        NSString *text = LocalizedString(@"TotalAsset");
        CGFloat width = [NSString widthWithText:text font:kFont13];
        _assetNameLabel = [XXLabel labelWithFrame:CGRectMake(20, CGRectGetMaxY(self.nameLabel.frame) + 20, width, 16) font:kFont(13) textColor:[UIColor whiteColor]];
        _assetNameLabel.text = text;
    }
    return _assetNameLabel;
}

- (XXButton *)hidenAssetsButton {
    if (_hidenAssetsButton == nil) {
        MJWeakSelf
        _hidenAssetsButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.assetNameLabel.frame) + 3, CGRectGetMaxY(self.nameLabel.frame) + 18, 22, 22) block:^(UIButton *button) {
            KUser.isHideAsset = !KUser.isHideAsset;
            weakSelf.hidenAssetsButton.selected = KUser.isHideAsset;
            if (weakSelf.actionBlock) {
                weakSelf.actionBlock();
            }
        }];
        [_hidenAssetsButton setImage:[UIImage imageNamed:@"unHiddenAssets"] forState:UIControlStateNormal];
        [_hidenAssetsButton setImage:[UIImage subTextImageName:@"hiddenAssets"] forState:UIControlStateSelected];
        _hidenAssetsButton.selected = KUser.isHideAsset;
    }
    return _hidenAssetsButton;
}

- (XXLabel *)assetSymbolLabel {
    if (!_assetSymbolLabel) {
        _assetSymbolLabel = [XXLabel labelWithFrame:CGRectMake(20, CGRectGetMaxY(self.assetNameLabel.frame) + 17, 12, 19) text:@"" font:kFontBold16 textColor:[UIColor whiteColor]];
    }
    return _assetSymbolLabel;
}

- (XXLabel *)totalAssetLabel {
    if (!_totalAssetLabel) {
        _totalAssetLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.assetSymbolLabel.frame), CGRectGetMaxY(self.assetNameLabel.frame) + 8, self.contentView.width - K375(40), 32) font:kNumberFontBold(32) textColor:[UIColor whiteColor]];
    }
    return _totalAssetLabel;
}

- (XXButton *)getTestCoinBtn {
    if (!_getTestCoinBtn) {
        MJWeakSelf
        CGFloat width = [NSString widthWithText:LocalizedString(@"GetTestCoin") font:kFont13] + 26;
        _getTestCoinBtn = [XXButton buttonWithFrame:CGRectMake(self.contentView.width - width - 20, 60, width, 32) block:^(UIButton *button) {
            [weakSelf requestGetTestCoin:@"hbc"];
            [weakSelf requestGetTestCoin:@"kiwi"];
        }];
        _getTestCoinBtn.layer.cornerRadius = 16;
        [_getTestCoinBtn setTitle:LocalizedString(@"GetTestCoin") forState:UIControlStateNormal];
        _getTestCoinBtn.backgroundColor = [UIColor whiteColor];
        [_getTestCoinBtn setTitleColor:kPrimaryMain forState:UIControlStateNormal];
        _getTestCoinBtn.titleLabel.font = kFont13;
        [_getTestCoinBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    return _getTestCoinBtn;
}

- (XXButton *)receiveMoneyBtn {
    if (_receiveMoneyBtn == nil) {
        MJWeakSelf
        _receiveMoneyBtn = [XXButton buttonWithFrame:CGRectMake(0, 140, self.contentView.width/3, self.contentView.height - 140) title:LocalizedString(@"ReceiveMoney") font:kFont13 titleColor:kGray900 block:^(UIButton *button) {
            XXDepositCoinVC *depositVC = [[XXDepositCoinVC alloc] init];
            [weakSelf.viewController.navigationController pushViewController:depositVC animated:YES];
        }];
        _receiveMoneyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        if (kIsNight) {
            [_receiveMoneyBtn setImage:[UIImage imageNamed:@"assert_receiveMoney"] forState:UIControlStateNormal];
        } else {
            [_receiveMoneyBtn setImage:[UIImage imageNamed:@"assert_receiveMoney"] forState:UIControlStateNormal];
        }
    }
    return _receiveMoneyBtn;
}

- (XXButton *)transferMoneyBtn {
    if (_transferMoneyBtn == nil) {
        MJWeakSelf
        _transferMoneyBtn = [XXButton buttonWithFrame:CGRectMake(self.contentView.width/3, 140, self.contentView.width/3, self.contentView.height - 140) title:LocalizedString(@"Transfer") font:kFont13 titleColor:kGray900 block:^(UIButton *button) {
            XXTransferVC *transferVC = [[XXTransferVC alloc] init];
            transferVC.symbol = kMainToken;
            [weakSelf.viewController.navigationController pushViewController:transferVC animated:YES];
        }];
        _transferMoneyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        if (kIsNight) {
            [_transferMoneyBtn setImage:[UIImage imageNamed:@"assert_payMoney"] forState:UIControlStateNormal];
        } else {
            [_transferMoneyBtn setImage:[UIImage imageNamed:@"assert_payMoney"] forState:UIControlStateNormal];
        }
    }
    return _transferMoneyBtn;
}

- (XXButton *)delegateBtn {
    if (_delegateBtn == nil) {
        MJWeakSelf
        _delegateBtn = [XXButton buttonWithFrame:CGRectMake(self.contentView.width*2/3, 140, self.contentView.width/3, self.contentView.height - 140) title:LocalizedString(@"Delegate") font:kFont13 titleColor:kGray900 block:^(UIButton *button) {
            XXValidatorsHomeViewController *validatorVC = [[XXValidatorsHomeViewController alloc] init];
            [weakSelf.viewController.navigationController pushViewController:validatorVC animated:YES];
        }];
        _delegateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        [_delegateBtn setImage:[UIImage imageNamed:@"assert_delegate"] forState:UIControlStateNormal];
    }
    return _delegateBtn;
}
@end
