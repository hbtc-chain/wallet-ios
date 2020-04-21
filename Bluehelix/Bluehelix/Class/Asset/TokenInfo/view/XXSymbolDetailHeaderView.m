//
//  XXSymbolDetailHeaderView.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/07.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXSymbolDetailHeaderView.h"
#import "XXTokenModel.h"

@interface XXSymbolDetailHeaderView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) CALayer *shadowLayer;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) XXLabel *tipLabel; //当前持有
@property (nonatomic, strong) XXLabel *amountLabel; //数量
@property (nonatomic, strong) XXLabel *assetLabel; //资产
@end

@implementation XXSymbolDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.backView];
    [self.backView.layer insertSublayer:self.shadowLayer atIndex:0];
//    [self.backView addSubview:self.imageView];
    [self.backView addSubview:self.tipLabel];
    [self.backView addSubview:self.amountLabel];
    [self.backView addSubview:self.assetLabel];
}

- (void)setAssetModel:(XXAssetModel *)assetModel {
    _assetModel = assetModel;
    self.amountLabel.text = assetModel.amount;
    self.assetLabel.text = [[RatesManager shareRatesManager] getRatesWithToken:assetModel.symbol priceValue:assetModel.amount.doubleValue];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(K375(16), 0, self.width - K375(32), self.height)];
    }
    return _backView;
}

- (CALayer *)shadowLayer {
    if (!_shadowLayer) {
        _shadowLayer = [CALayer layer];
        _shadowLayer.frame = CGRectMake(0, 0, self.backView.width, self.backView.height - 8);
        _shadowLayer.cornerRadius = 10;
        _shadowLayer.backgroundColor = [kWhiteColor CGColor];
        _shadowLayer.shadowColor = [kGray200 CGColor];
        _shadowLayer.shadowOffset = CGSizeMake(0, 4);
        _shadowLayer.shadowOpacity = 0.8;
        _shadowLayer.shadowRadius = 4;
    }
    return _shadowLayer;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.backView.width - 112 + 16, 24, 112, 112)];
        _imageView.image = [UIImage imageNamed:@"symbolIcon"];
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), K375(16), self.backView.width - K375(32), 16) font:kFont13 textColor:kGray500];
        _tipLabel.text = LocalizedString(@"HoldAsset");
    }
    return _tipLabel;
}

- (XXLabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipLabel.frame), self.backView.width - K375(32), 40) font:kFont(26) textColor:kGray900];
    }
    return _amountLabel;
}

- (XXLabel *)assetLabel {
    if (!_assetLabel) {
        _assetLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.amountLabel.frame), self.backView.width - K375(32), 16) font:kFont15 textColor:kGray500];
    }
    return _assetLabel;
}
@end
