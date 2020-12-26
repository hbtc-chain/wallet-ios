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
    NSString *type = [model.chain isEqualToString:kMainToken] ? LocalizedString(@"NativeTokenList") : LocalizedString(@"CrossChainTokenList");
    XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:model.chain];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:token.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    
    self.coinNameLabel.text = [model.chain uppercaseString];
    CGFloat width = [NSString widthWithText:[model.chain uppercaseString] font:kFontBold(17)];
    self.coinNameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame) + 12, 16, width, 24);
    
    self.typeLabel.text = type;
    CGFloat typeWidth = [NSString widthWithText:type font:kFont10];
    self.typeLabel.frame = CGRectMake(CGRectGetMaxX(self.coinNameLabel.frame) + 4, 20, typeWidth + 8, 16);
    if ([model.chain isEqualToString:kMainToken]) {
        self.typeLabel.backgroundColor = [kPrimaryMain colorWithAlphaComponent:0.2];
        self.typeLabel.textColor = kPrimaryMain;
    } else {
        self.typeLabel.backgroundColor = [kGray200 colorWithAlphaComponent:0.2];
        self.typeLabel.textColor = kGray500;
    }
    
    self.detailNameLabel.text = model.full_name;
    self.moneyLabel.text = [[RatesManager shareRatesManager] getPriceFromToken:model.chain];
    [self configChainAssert:model.chain];
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
    self.moneyLabel.text = [NSString stringWithFormat:@"≈%@%.2f",[RatesManager shareRatesManager].rateUnit,totalAsset];
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
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(16), 20, 32, 32)];
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
        _typeLabel.layer.cornerRadius = 8;
        _typeLabel.layer.masksToBounds = YES;
    }
    return _typeLabel;
}

- (XXLabel *)moneyLabel {
    if (_moneyLabel == nil) {
        _moneyLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.detailNameLabel.frame), [[self class] getCellHeight]/2 - 8, kScreen_Width - CGRectGetMaxX(self.detailNameLabel.frame) - K375(16), 16) text:@"" font:kNumberFont(13) textColor:kGray500];
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
