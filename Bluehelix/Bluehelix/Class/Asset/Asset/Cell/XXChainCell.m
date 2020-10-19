//
//  XXChainCell.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/3.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChainCell.h"
#import "XXTokenModel.h"
#import "XXChainModel.h"
#import <UIImageView+WebCache.h>
#import "XXAssetSingleManager.h"

@interface XXChainCell ()

/// 图标
@property (strong, nonatomic) UIImageView *iconView;

/// 币名
@property (strong, nonatomic) XXLabel *coinNameLabel;

/// 总额
@property (strong, nonatomic) XXLabel *moneyLabel;

/// 类型
@property (strong, nonatomic) XXLabel *typeLabel;

/// 全称
@property (strong, nonatomic) XXLabel *detailNameLabel;

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
    [self.contentView addSubview:self.self.typeLabel];
    [self.contentView addSubview:self.detailNameLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)configData:(XXChainModel *)model {
    XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:model.symbol];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:token.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    
    self.coinNameLabel.text = [model.symbol uppercaseString];
    CGFloat width = [NSString widthWithText:[model.symbol uppercaseString] font:kFontBold(17)];
    self.coinNameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame) + 12, 16, width, 24);
    
    self.typeLabel.text = model.typeName;
    CGFloat typeWidth = [NSString widthWithText:model.typeName font:kFont10];
    self.typeLabel.frame = CGRectMake(CGRectGetMaxX(self.coinNameLabel.frame) + 4, 16, typeWidth + 8, 16);
    
    self.detailNameLabel.text = model.detailName;
    self.moneyLabel.text = [[RatesManager shareRatesManager] getPriceFromToken:model.symbol];
    [self configChainAssert:model.symbol];
}

- (void)configChainAssert:(NSString *)chain {
    double totalAsset = 0;
    for (XXTokenModel *tokenModel in [XXAssetSingleManager sharedManager].assetModel.assets) {
        XXTokenModel *chainModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:tokenModel.symbol];
        if ([chainModel.chain isEqualToString:chain]) {
            double rate = [self getRatesFromToken:tokenModel.symbol];
            if (rate > 0) {
                totalAsset += [tokenModel.amount doubleValue] * rate;
            }
        }
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"≈%@%.3f",[RatesManager shareRatesManager].rateUnit,totalAsset];
}

- (double)getRatesFromToken:(NSString *)token {
    NSDictionary *dic = [RatesManager shareRatesManager].dataDic[token];
        if (dic) {
            return [dic[KUser.ratesKey] doubleValue];
        } else {
            return 0;
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
        _coinNameLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 12, 16, 100, 24) text:@"" font:kFontBold(17) textColor:kGray900];
    }
    return _coinNameLabel;
}

- (XXLabel *)detailNameLabel {
    if (_detailNameLabel == nil) {
        _detailNameLabel = [XXLabel labelWithFrame:CGRectMake(self.coinNameLabel.left, CGRectGetMaxY(self.coinNameLabel.frame), 150, 16) font:kFont13 textColor:kGray300];
    }
    return _detailNameLabel;
}

- (XXLabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.coinNameLabel.frame) + 6, 16, 0, 24) font:kFont10 textColor:kGray500];
        _typeLabel.backgroundColor = [kGray200 colorWithAlphaComponent:0.2];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.layer.cornerRadius = 2;
        _typeLabel.layer.masksToBounds = YES;
    }
    return _typeLabel;
}

- (XXLabel *)moneyLabel {
    if (_moneyLabel == nil) {
        _moneyLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.detailNameLabel.frame), CGRectGetMaxY(self.coinNameLabel.frame), kScreen_Width - CGRectGetMaxX(self.detailNameLabel.frame) - K375(16), 16) text:@"" font:kNumberFont(13) textColor:kGray500];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
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
