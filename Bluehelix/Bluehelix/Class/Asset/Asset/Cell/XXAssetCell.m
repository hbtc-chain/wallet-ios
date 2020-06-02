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
#import "XXTransferVC.h"
#import "XXDepositCoinVC.h"

@interface XXAssetCell () <SWTableViewCellDelegate>

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

@property (strong, nonatomic) XXTokenModel *tokenModel;
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
    self.leftUtilityButtons = [self leftButtons];
    self.rightUtilityButtons = [self rightButtons];
    self.delegate = self;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:kPrimaryMain
                                               title:LocalizedString(@"ReceiveMoney")];
    return leftUtilityButtons;
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:kPrimaryMain
                                               title:LocalizedString(@"Transfer")];
    return rightUtilityButtons;
}

- (void)configData:(XXTokenModel *)model {
    self.tokenModel = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    self.coinNameLabel.text = [model.symbol uppercaseString];
    self.coinNameLabel.width = [NSString widthWithText:[model.symbol uppercaseString] font:kFontBold(17)];
    if (KUser.isHideAsset) {
        self.moneyLabel.text = kHideAssetText;
        self.amountLabel.text = kHideAssetText;
    } else {
        self.moneyLabel.text = [[RatesManager shareRatesManager] getTwoRatesWithToken:model.symbol priceValue:model.amount.doubleValue];
        self.amountLabel.text = kAmountTrim(model.amount);
    }
    [self configTypeLabel:model];
       self.priceLabel.text = [[RatesManager shareRatesManager] getPriceFromToken:model.symbol];
}

- (void)configTypeLabel:(XXTokenModel *)model {
    if ([model.symbol isEqualToString:kMainToken]) {
        self.typeLabel.hidden = YES;
    } else {
        if (model.is_native && ![model.symbol isEqualToString:kMainToken]) {
            self.typeLabel.text = LocalizedString(@"NativeCoin");
            self.typeLabel.textColor = kGreen100;
            self.typeLabel.backgroundColor = [kGreen100 colorWithAlphaComponent:0.2];
            self.typeLabel.frame = CGRectMake(CGRectGetMaxX(self.coinNameLabel.frame) +5, 20, [NSString widthWithText:LocalizedString(@"NativeCoin") font:kFont10] + 8, 16);
        } else {
            self.typeLabel.text = LocalizedString(@"UnnativeCoin");
            self.typeLabel.textColor = kGray500;
            self.typeLabel.backgroundColor = [kGray200 colorWithAlphaComponent:0.2];
            self.typeLabel.frame = CGRectMake(CGRectGetMaxX(self.coinNameLabel.frame) +5, 20, [NSString widthWithText:LocalizedString(@"UnnativeCoin") font:kFont10] + 8, 16);
        }
        self.typeLabel.hidden = NO;
        self.amountLabel.frame = CGRectMake(CGRectGetMaxX(self.typeLabel.frame), 16, kScreen_Width - 16 - CGRectGetMaxX(self.typeLabel.frame), 24);
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    XXDepositCoinVC *depositVC = [[XXDepositCoinVC alloc] init];
    depositVC.tokenModel = self.tokenModel;
    depositVC.InnerChain = YES;
    [self.viewController.navigationController pushViewController:depositVC animated:YES];
    [cell hideUtilityButtonsAnimated:YES];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    XXTransferVC *transferVC = [[XXTransferVC alloc] init];
    transferVC.tokenModel = self.tokenModel;
    transferVC.InnerChain = YES;
    [self.viewController.navigationController pushViewController:transferVC animated:YES];
    [cell hideUtilityButtonsAnimated:YES];
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(16), 16, 40, 40)];
    }
    return _iconView;
}

- (XXLabel *)coinNameLabel {
    if (_coinNameLabel == nil) {
        _coinNameLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame) + 12, 16, 0, 24) text:@"" font:kFontBold(17) textColor:kGray900];
    }
    return _coinNameLabel;
}

- (XXLabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [XXLabel labelWithFrame:CGRectMake(self.coinNameLabel.left, CGRectGetMaxY(self.coinNameLabel.frame), 100, 16) text:@"" font:kNumberFont(13) textColor:kGray500];
    }
    return _priceLabel;
}

- (XXLabel *)moneyLabel {
    if (_moneyLabel == nil) {
        _moneyLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame), self.priceLabel.top, kScreen_Width - 16 - CGRectGetMaxX(self.priceLabel.frame), 16) text:@"" font:kNumberFont(13) textColor:kGray500];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}

- (XXLabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.coinNameLabel.frame) +2, 20, 60, 16) text:@"" font:kFont10 textColor:kGray900];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.layer.cornerRadius = 2;
        _typeLabel.layer.masksToBounds = YES;
    }
    return _typeLabel;
}

- (XXLabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.coinNameLabel.frame), 16, kScreen_Width - 16 - CGRectGetMaxX(self.coinNameLabel.frame), 24) font:kNumberFontBold(17) textColor:kGray900];
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
