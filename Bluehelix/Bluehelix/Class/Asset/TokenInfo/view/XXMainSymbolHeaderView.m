//
//  XXMainSymbolHeaderView.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXMainSymbolHeaderView.h"
#import "XXTokenModel.h"
#import "XXAssetModel.h"
#import <UIImageView+WebCache.h>

@interface XXMainSymbolHeaderView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) CALayer *shadowLayer;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *imageBackView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) XXLabel *tipLabel; //当前持有
@property (nonatomic, strong) XXLabel *amountLabel; //数量
@property (nonatomic, strong) XXLabel *assetLabel; //资产

@property (nonatomic, strong) XXLabel *titleLabel1; //可用
@property (nonatomic, strong) XXLabel *titleLabel2; //委托中
@property (nonatomic, strong) XXLabel *titleLabel3; //赎回中
@property (nonatomic, strong) XXLabel *titleLabel4; //已收益

@property (nonatomic, strong) XXLabel *valueLabel1; //可用
@property (nonatomic, strong) XXLabel *valueLabel2; //委托中
@property (nonatomic, strong) XXLabel *valueLabel3; //赎回中
@property (nonatomic, strong) XXLabel *valueLabel4; //已收益

@end

@implementation XXMainSymbolHeaderView

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
    [self.backView addSubview:self.imageBackView];
//    [self.imageBackView addSubview:self.imageView];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.tipLabel];
    [self.backView addSubview:self.amountLabel];
    [self.backView addSubview:self.assetLabel];
    [self.backView addSubview:self.titleLabel1];
    [self.backView addSubview:self.titleLabel2];
    [self.backView addSubview:self.titleLabel3];
    [self.backView addSubview:self.titleLabel4];
    [self.backView addSubview:self.valueLabel1];
    [self.backView addSubview:self.valueLabel2];
    [self.backView addSubview:self.valueLabel3];
    [self.backView addSubview:self.valueLabel4];
}

- (void)setAssetModel:(XXAssetModel *)assetModel {
    self.amountLabel.text = kAmountShortTrim(assetModel.amount);
    self.assetLabel.text = [[RatesManager shareRatesManager] getRatesWithToken:assetModel.symbol priceValue:assetModel.amount.doubleValue];
    self.valueLabel1.text = kAmountShortTrim(assetModel.amount);
    self.valueLabel2.text = kAmountShortTrim(assetModel.bonded);
    self.valueLabel3.text = kAmountShortTrim(assetModel.unbonding);
    self.valueLabel4.text = kAmountShortTrim(assetModel.claimed_reward);
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(K375(16), 5, self.width - K375(32), self.height - 5)];
    }
    return _backView;
}

- (CALayer *)shadowLayer {
    if (!_shadowLayer) {
        _shadowLayer = [CALayer layer];
        _shadowLayer.frame = CGRectMake(0, 0, self.backView.width, self.backView.height-4);
        _shadowLayer.cornerRadius = 10;
        _shadowLayer.backgroundColor = [kBackgroundLeverSecond CGColor];
        _shadowLayer.shadowColor = [kShadowColor CGColor];
        _shadowLayer.shadowOffset = CGSizeMake(0, 2);
        _shadowLayer.shadowOpacity = 1.0;
        _shadowLayer.shadowRadius = 2;
    }
    return _shadowLayer;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 112, self.backView.width - 16, KLine_Height)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

- (UIView *)imageBackView {
    if (!_imageBackView) {
        _imageBackView = [[UIView alloc] initWithFrame:CGRectMake(self.backView.width - 96, 16, 96, 96)];
        _imageBackView.layer.masksToBounds = YES;
    }
    return _imageBackView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
        _imageView.image = [UIImage imageNamed:@"placeholderToken"];
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
        _amountLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipLabel.frame), self.backView.width - K375(32), 40) font:kNumberFontBold(26) textColor:kGray900];
        _amountLabel.text = @"";
    }
    return _amountLabel;
}

- (XXLabel *)assetLabel {
    if (!_assetLabel) {
        _assetLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.amountLabel.frame), self.backView.width - K375(32), 16) font:kNumberFont(15) textColor:kGray500];
        _assetLabel.text = @"";
    }
    return _assetLabel;
}

- (XXLabel *)titleLabel1 {
    if (!_titleLabel1) {
        _titleLabel1 = [XXLabel labelWithFrame:CGRectMake(K375(16), 128, 150, 20) text:LocalizedString(@"CurrentlyAvailable") font:kFont13 textColor:kGray500];
    }
    return _titleLabel1;
}

- (XXLabel *)titleLabel2 {
    if (!_titleLabel2) {
        _titleLabel2 = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.titleLabel1.frame) + 5, 150, 20) text:LocalizedString(@"Bonded") font:kFont13 textColor:kGray500];
    }
    return _titleLabel2;
}

- (XXLabel *)titleLabel3 {
    if (!_titleLabel3) {
        _titleLabel3 = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.titleLabel2.frame) + 5, 150, 20) text:LocalizedString(@"Unbonding") font:kFont13 textColor:kGray500];
    }
    return _titleLabel3;
}

- (XXLabel *)titleLabel4 {
    if (!_titleLabel4) {
        _titleLabel4 = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.titleLabel3.frame) + 5, 150, 20) text:LocalizedString(@"ClaimedReward") font:kFont13 textColor:kGray500];
    }
    return _titleLabel4;
}

- (XXLabel *)valueLabel1 {
    if (!_valueLabel1) {
        _valueLabel1 = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel1.frame), 128, self.backView.width - CGRectGetMaxX(self.titleLabel1.frame) - K375(16), 20) font:kNumberFont(13) textColor:kGray900];
        _valueLabel1.textAlignment = NSTextAlignmentRight;
    }
    return _valueLabel1;
}

- (XXLabel *)valueLabel2 {
    if (!_valueLabel2) {
        _valueLabel2 = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel2.frame), CGRectGetMaxY(self.valueLabel1.frame) + 5, self.backView.width - CGRectGetMaxX(self.titleLabel2.frame) - K375(16), 20) font:kNumberFont(13) textColor:kGray900];
        _valueLabel2.textAlignment = NSTextAlignmentRight;
    }
    return _valueLabel2;
}

- (XXLabel *)valueLabel3 {
    if (!_valueLabel3) {
        _valueLabel3 = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel3.frame), CGRectGetMaxY(self.valueLabel2.frame) + 5, self.backView.width - CGRectGetMaxX(self.titleLabel3.frame) - K375(16), 20) font:kNumberFont(13) textColor:kGray900];
        _valueLabel3.textAlignment = NSTextAlignmentRight;
    }
    return _valueLabel3;
}

- (XXLabel *)valueLabel4 {
    if (!_valueLabel4) {
        _valueLabel4 = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel4.frame), CGRectGetMaxY(self.valueLabel3.frame) + 5, self.backView.width - CGRectGetMaxX(self.titleLabel4.frame) - K375(16), 20) font:kNumberFont(13) textColor:kGray900];
        _valueLabel4.textAlignment = NSTextAlignmentRight;
    }
    return _valueLabel4;
}

@end
