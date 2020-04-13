//
//  XXAssetCell.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/02.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAssetCell.h"
#import "XXTokenModel.h"
#import <UIImageView+WebCache.h>

@interface XXAssetCell ()

/// 图标
@property (strong, nonatomic) UIImageView *iconView;

/// 币名
@property (strong, nonatomic) XXLabel *coinNameLabel;

/// 单价
@property (strong, nonatomic) XXLabel *priceLabel;

/// 总价
@property (strong, nonatomic) XXLabel *moneyLabel;

/// 类型
@property (strong, nonatomic) XXLabel *typeLabel;

/// 数量
@property (strong, nonatomic) XXLabel *amountLabel;

@property (strong, nonatomic) UIView *lineView;

@end

@implementation XXAssetCell

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
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.amountLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)configData:(XXTokenModel *)model {
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    self.coinNameLabel.text = model.symbol;
    self.coinNameLabel.width = [NSString widthWithText:model.symbol font:kFontBold(17)];
    self.amountLabel.text = model.amount;
    [self configTypeLabel:model];
    self.moneyLabel.text = [[RatesManager shareRatesManager] getTwoRatesWithToken:model.symbol priceValue:model.amount.doubleValue];
    self.priceLabel.text = [[RatesManager shareRatesManager] getPriceFromToken:model.symbol];
}

- (void)configTypeLabel:(XXTokenModel *)model {
    if ([model.symbol isEqualToString:kMainToken]) {
        self.typeLabel.hidden = YES;
    } else {
        if (model.is_native && ![model.symbol isEqualToString:kMainToken]) {
            self.typeLabel.text = LocalizedString(@"NativeCoin");
            self.typeLabel.textColor = KRGBA(70, 206, 95, 100);
            self.typeLabel.backgroundColor = KRGBA(212, 245, 220, 100);
            self.typeLabel.frame = CGRectMake(CGRectGetMaxX(self.coinNameLabel.frame) +5, 20, [NSString widthWithText:LocalizedString(@"NativeCoin") font:kFont10], 16);
        } else {
            self.typeLabel.text = LocalizedString(@"UnnativeCoin");
            self.typeLabel.textColor = [UIColor colorWithHexString:@"#51D372"];
            self.typeLabel.textColor = KRGBA(91, 109, 132, 100);
            self.typeLabel.backgroundColor = KRGBA(235, 239, 246, 100);
            self.typeLabel.frame = CGRectMake(CGRectGetMaxX(self.coinNameLabel.frame) +5, 20, [NSString widthWithText:LocalizedString(@"UnnativeCoin") font:kFont10], 16);
        }
        self.typeLabel.hidden = NO;
        self.amountLabel.frame = CGRectMake(CGRectGetMaxX(self.typeLabel.frame), 16, kScreen_Width - 16 - CGRectGetMaxX(self.typeLabel.frame), 24);
    }
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(16), 16, 40, 40)];
    }
    return _iconView;
}

- (XXLabel *)coinNameLabel {
    if (_coinNameLabel == nil) {
        _coinNameLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 12, 16, 0, 24) text:@"" font:kFontBold(17) textColor:kDark100];
    }
    return _coinNameLabel;
}

- (XXLabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [XXLabel labelWithFrame:CGRectMake(self.coinNameLabel.left, CGRectGetMaxY(self.coinNameLabel.frame), 100, 24) text:@"" font:kNumberFont(13) textColor:kTipColor];
    }
    return _priceLabel;
}

- (XXLabel *)moneyLabel {
    if (_moneyLabel == nil) {
        _moneyLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame), self.priceLabel.top, kScreen_Width - 16 - CGRectGetMaxX(self.priceLabel.frame), 24) text:@"" font:kNumberFont(13) textColor:kTipColor];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}

- (XXLabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.coinNameLabel.frame) +2, 20, 60, 16) text:@"" font:kFont10 textColor:kDark100];
    }
    return _typeLabel;
}

- (XXLabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.coinNameLabel.frame), 16, kScreen_Width - 16 - CGRectGetMaxX(self.coinNameLabel.frame), 24) font:kNumberFont(17) textColor:kDark100];
        _amountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _amountLabel;
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
