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

@interface XXAssetHeaderView ()

@property (strong, nonatomic) XXLabel *nameLabel;
@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) XXLabel *logoLabel;
@property (strong, nonatomic) UIImageView *shadowImageView;
@property (strong, nonatomic) XXButton *hidenAssetsButton;
@property (strong, nonatomic) CALayer *shadowLayer;
@property (strong, nonatomic) XXLabel *assetNameLabel;
@property (strong, nonatomic) XXLabel *totalAssetLabel;
@property (strong, nonatomic) XXLabel *assetSymbolLabel;
@property (strong, nonatomic) XXButton *menuBtn;
@property (strong, nonatomic) UIImageView *logoImageView;

@end

@implementation XXAssetHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.backImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.shadowImageView];
        [self.shadowImageView.layer insertSublayer:self.shadowLayer atIndex:0];
        [self.shadowImageView addSubview:self.assetNameLabel];
        [self.shadowImageView addSubview:self.assetSymbolLabel];
        [self.shadowImageView addSubview:self.totalAssetLabel];
//        [self addSubview:self.logoLabel];
        [self addSubview:self.logoImageView];
        [self addSubview:self.menuBtn];
        [self.shadowImageView addSubview:self.hidenAssetsButton];
    }
    return self;
}

- (void)configData:(XXAssetModel *)model {
    if (KUser.isHideAsset) {
        self.totalAssetLabel.text = @"***";
    } else {
        double totalAsset = 0;
        for (XXTokenModel *tokenModel in model.assets) {
            double rate = [self getRatesFromToken:tokenModel.symbol];
            if (rate > 0) {
                totalAsset += [tokenModel.amount doubleValue] * rate;
            }
        }
        self.assetSymbolLabel.text = [RatesManager shareRatesManager].rateUnit;
        self.totalAssetLabel.text = [NSString stringWithFormat:@"%.3f",totalAsset];
    }
}

- (double)getRatesFromToken:(NSString *)token {
    NSDictionary *dic = [RatesManager shareRatesManager].dataDic[token];
        if (dic) {
            return [dic[KUser.ratesKey] doubleValue];
        } else {
            return 0;
        }
}

- (XXLabel *)logoLabel {
    if (!_logoLabel) {
        CGFloat top = BH_IS_IPHONE_X ? 40 : 30;
        _logoLabel = [XXLabel labelWithFrame:CGRectMake(0, top, kScreen_Width, 25) font:kFontBold(13) textColor:[UIColor whiteColor]];
        _logoLabel.text = LocalizedString(@"logoName");
        _logoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _logoLabel;
}

- (UIImageView *)logoImageView {
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 148)/2, kStatusBarHeight, 148, 20)];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoImageView.image = [UIImage imageNamed:@"logoHeader"];
    }
    return _logoImageView;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(224))];
        _backImageView.image = [UIImage imageNamed:@"assetHeaderBack"];
    }
    return _backImageView;
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), K375(64), kScreen_Width - K375(90), 40) font:kFontBold(30) textColor:[UIColor whiteColor]];
        _nameLabel.text = LocalizedString(@"Asset");
    }
    return _nameLabel;
}

- (XXButton *)hidenAssetsButton {
    if (_hidenAssetsButton == nil) {
        MJWeakSelf
        _hidenAssetsButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.assetNameLabel.frame), self.assetNameLabel.top + 2, self.assetNameLabel.height, self.assetNameLabel.height) block:^(UIButton *button) {
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

- (XXButton *)menuBtn {
    if (!_menuBtn) {
        MJWeakSelf
        _menuBtn = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - 60, K375(64), 40, 40) block:^(UIButton *button) {
            XXAddNewAssetVC *addVC = [[XXAddNewAssetVC alloc] init];
            [weakSelf.viewController.navigationController pushViewController:addVC animated:YES];
        }];
        [_menuBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    }
    return _menuBtn;
}

- (UIImageView *)shadowImageView {
    if (!_shadowImageView) {
        _shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(16), K375(115), kScreen_Width - K375(32), K375(140))];
//        _shadowImageView.backgroundColor = KRGBA(251, 251, 251, 100);
        _shadowImageView.image = [UIImage imageNamed:@"assetBack"];
        _shadowImageView.userInteractionEnabled = YES;
    }
    return _shadowImageView;
}

- (CALayer *)shadowLayer {
    if (!_shadowLayer) {
        _shadowLayer = [CALayer layer];
        _shadowLayer.frame = CGRectMake(0, 0, self.shadowImageView.width, self.shadowImageView.height -4);
        _shadowLayer.cornerRadius = 10;
        _shadowLayer.backgroundColor = [kWhiteColor CGColor];
        _shadowLayer.shadowColor = [kGray200 CGColor];
        _shadowLayer.shadowOffset = CGSizeMake(0, 2);
        _shadowLayer.shadowOpacity = 0.8;
        _shadowLayer.shadowRadius = 2;
    }
    return _shadowLayer;
}

- (XXLabel *)assetNameLabel {
    if (!_assetNameLabel) {
        _assetNameLabel = [XXLabel labelWithFrame:CGRectMake(K375(20), K375(20), 100, 24) font:kFont(17) textColor:kGray700];
    }
    _assetNameLabel.text = NSLocalizedFormatString(LocalizedString(@"TotalAsset"),[KUser.ratesKey uppercaseString]);
    return _assetNameLabel;
}

- (XXLabel *)assetSymbolLabel {
    if (!_assetSymbolLabel) {
        _assetSymbolLabel = [XXLabel labelWithFrame:CGRectMake(K375(20), CGRectGetMaxY(self.assetNameLabel.frame) + 14, 12, 32) text:@"" font:kFontBold16 textColor:kGray700];
    }
    return _assetSymbolLabel;
}

- (XXLabel *)totalAssetLabel {
    if (!_totalAssetLabel) {
        _totalAssetLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.assetSymbolLabel.frame), CGRectGetMaxY(self.assetNameLabel.frame) + 10, self.shadowImageView.width - K375(40), 32) font:kNumberFontBold(30) textColor:kGray700];
    }
    return _totalAssetLabel;
}
@end
