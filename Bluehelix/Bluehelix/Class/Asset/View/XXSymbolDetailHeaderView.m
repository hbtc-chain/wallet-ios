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
        self.backgroundColor = kWhite100;
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.backView];
    [self.backView.layer insertSublayer:self.shadowLayer atIndex:0];
    [self.backView addSubview:self.imageView];
    [self.backView addSubview:self.tipLabel];
    [self.backView addSubview:self.amountLabel];
    [self.backView addSubview:self.assetLabel];
   
}

- (void)setTokenModel:(XXTokenModel *)tokenModel {
    _tokenModel = tokenModel;
    self.amountLabel.text = tokenModel.amount;
    self.assetLabel.text = [[RatesManager shareRatesManager] getTwoRatesWithToken:tokenModel.symbol priceValue:tokenModel.amount.doubleValue];
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
        _shadowLayer.frame = CGRectMake(0, 0, self.backView.width, self.backView.height);
        _shadowLayer.cornerRadius = 10;
        _shadowLayer.backgroundColor = [kWhite100 CGColor];
        _shadowLayer.shadowColor = [kBlue20 CGColor];
        _shadowLayer.shadowOffset = CGSizeMake(0, 4);
        _shadowLayer.shadowOpacity = 0.8;
        _shadowLayer.shadowRadius = 4;
    }
    return _shadowLayer;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.backView.width - 112 + 16, 16, 96, 96)];
        _imageView.image = [UIImage imageNamed:@"symbolIcon"];
    }
    return _imageView;
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), K375(16), self.width - K375(32), 16) font:kFont13 textColor:kDark50];
        _tipLabel.text = LocalizedString(@"HoldAsset");
    }
    return _tipLabel;
}

- (XXLabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipLabel.frame), self.width - K375(32), 40) font:kFont(26) textColor:kDark100];
    }
    return _amountLabel;
}

- (XXLabel *)assetLabel {
    if (!_assetLabel) {
        _assetLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.amountLabel.frame), self.width - K375(32), 16) font:kFont15 textColor:kDark50];
    }
    return _assetLabel;
}
@end
