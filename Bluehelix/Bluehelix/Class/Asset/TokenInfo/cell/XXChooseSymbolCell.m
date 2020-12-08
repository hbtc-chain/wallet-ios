//
//  XXChooseSymbolCell.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/5.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChooseSymbolCell.h"
#import <UIImageView+WebCache.h>

@interface XXChooseSymbolCell ()

/// 图标
@property (strong, nonatomic) UIImageView *iconView;

/// 币名
@property (strong, nonatomic) XXLabel *coinNameLabel;

/// ID
@property (strong, nonatomic) XXLabel *symbolLabel;

@property (strong, nonatomic) UIView *lineView;

@end

@implementation XXChooseSymbolCell

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
    [self.contentView addSubview:self.symbolLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)configModel:(XXTokenModel *)model {
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    self.coinNameLabel.text = [NSString stringWithFormat:@"%@",[model.name uppercaseString]];
    self.symbolLabel.text = model.symbol;
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

- (XXLabel *)symbolLabel {
    if (_symbolLabel == nil) {
        _symbolLabel = [XXLabel labelWithFrame:CGRectMake(self.coinNameLabel.left, CGRectGetMaxY(self.coinNameLabel.frame), 100, 16) text:@"" font:kNumberFont(13) textColor:kGray500];
    }
    return _symbolLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 12, [[self class] getCellHeight] - 1, kScreen_Width, 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

+ (CGFloat)getCellHeight {
    return 64;
}

@end
