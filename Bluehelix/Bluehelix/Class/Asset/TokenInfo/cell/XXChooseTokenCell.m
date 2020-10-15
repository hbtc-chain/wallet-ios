//
//  XXChooseTokenCell.m
//  Bluehelix
//
//  Created by 袁振 on 2020/10/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChooseTokenCell.h"
#import <UIImageView+WebCache.h>
#import "XXMappingModel.h"

@interface XXChooseTokenCell ()

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

@property (strong, nonatomic) XXMappingModel *mapModel;

@end

@implementation XXChooseTokenCell

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

- (void)configData:(XXMappingModel *)model {
    self.mapModel = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    self.coinNameLabel.text = [NSString stringWithFormat:@"%@->%@",[model.name uppercaseString],[model.map_symbol uppercaseString]];
    self.amountLabel.text = [NSString stringWithFormat:@"%@: %@",LocalizedString(@"Balance"),kAmountShortTrim(model.amount)];
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(16), 16, 32, 32)];
    }
    return _iconView;
}

- (XXLabel *)coinNameLabel {
    if (_coinNameLabel == nil) {
        _coinNameLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 12, 16, kScreen_Width - CGRectGetMaxX(self.iconView.frame) - 64, 24) text:@"" font:kFontBold(17) textColor:kGray900];
    }
    return _coinNameLabel;
}

- (XXLabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [XXLabel labelWithFrame:CGRectMake(self.coinNameLabel.left, CGRectGetMaxY(self.coinNameLabel.frame), 100, 16) text:@"" font:kNumberFont(13) textColor:kGray500];
    }
    return _amountLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, [[self class] getCellHeight] - 1, kScreen_Width, 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

+ (CGFloat)getCellHeight {
    return 64;
}

@end
