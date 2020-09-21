//
//  XXChainCell.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/3.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChainCell.h"

@interface XXChainCell ()

/// 图标
@property (strong, nonatomic) UIImageView *iconView;

/// 币名
@property (strong, nonatomic) XXLabel *coinNameLabel;

/// 单价
@property (strong, nonatomic) XXLabel *priceLabel;

@property (strong, nonatomic) UIView *lineView;

@end

@implementation XXChainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kViewBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.coinNameLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)configData:(NSString *)symbol {
    if ([@[@"eth",@"btc"] containsObject:symbol]) {
        [self.iconView setImage:[UIImage imageNamed:symbol]];
    } else {
        [self.iconView setImage:[UIImage imageNamed:@"placeholderToken"]];
    }
    self.coinNameLabel.text = [symbol uppercaseString];
    self.priceLabel.text = [[RatesManager shareRatesManager] getPriceFromToken:symbol];
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(16), 16, 40, 40)];
    }
    return _iconView;
}

- (XXLabel *)coinNameLabel {
    if (_coinNameLabel == nil) {
        _coinNameLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 12, 16, 100, 24) text:@"" font:kFontBold(17) textColor:kGray900];
    }
    return _coinNameLabel;
}

- (XXLabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [XXLabel labelWithFrame:CGRectMake(self.coinNameLabel.left, CGRectGetMaxY(self.coinNameLabel.frame), 100, 16) text:@"" font:kNumberFont(13) textColor:kGray500];
    }
    return _priceLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.coinNameLabel.left, [[self class] getCellHeight] - 1, kScreen_Width - K375(15), 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

+ (CGFloat)getCellHeight {
    return 72;
}
@end
