//
//  XXExchangeView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXExchangeView.h"
#import "XXExchangeBtn.h"
#import "XXChangeMapTokenView.h"
#import <UIImageView+WebCache.h>
#import "XXTokenModel.h"
#import "XXAssetSingleManager.h"

@interface XXExchangeView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *topBackView;
@property (nonatomic, strong) XXLabel *topTitleLabel;
@property (nonatomic, strong) XXExchangeBtn * topExchangeBtn;
@property (nonatomic, strong) XXLabel *bottomTitleLabel;
@property (nonatomic, strong) XXExchangeBtn * bottomExchangeBtn;
@property (nonatomic, strong) XXButton *switchBtn;
@property (nonatomic, strong) UIView *amountView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) XXLabel *rateNameLabel;
@property (nonatomic, strong) XXButton *exchangeBtn;
@property (nonatomic, strong) UIImageView *ratePointImageView;
@property (nonatomic, strong) XXLabel *rateDetailLabel;
@property (nonatomic, strong) XXLabel *topMoneyLabel; //余额
@property (nonatomic, strong) XXLabel *bottomMoneyLabel; //余额
@property (nonatomic, strong) UIView *topFieldBackView;
@property (nonatomic, strong) UIView *bottomFieldBackView;
@property (nonatomic, strong) XXButton *topAllBtn;
@property (nonatomic, strong) XXButton *bottomAllBtn;

@end

@implementation XXExchangeView

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
    [self.backView addSubview:self.topBackView];
    [self.topBackView addSubview:self.topTitleLabel];
    [self.topBackView addSubview:self.topExchangeBtn];
    [self.topBackView addSubview:self.topFieldBackView];
    [self.topFieldBackView addSubview:self.topField];
    [self.topBackView addSubview:self.switchBtn];
    [self.topBackView addSubview:self.bottomTitleLabel];
    [self.topBackView addSubview:self.bottomExchangeBtn];
    [self.topBackView addSubview:self.bottomFieldBackView];
    [self.bottomFieldBackView addSubview:self.bottomField];
    [self.topBackView addSubview:self.exchangeBtn];
    [self.backView addSubview:self.rateNameLabel];
    [self.backView addSubview:self.rateDetailLabel];
    [self.backView addSubview:self.ratePointImageView];
    [self.topBackView addSubview:self.topMoneyLabel];
    [self.topBackView addSubview:self.bottomMoneyLabel];
    [self.topFieldBackView addSubview:self.topAllBtn];
    [self.bottomFieldBackView addSubview:self.bottomAllBtn];
}

- (void)setMappingModel:(XXMappingModel *)mappingModel {
    _mappingModel = mappingModel;
    self.topField.text = @"";
    self.bottomField.text = @"";
    self.topMoneyLabel.text = [NSString stringWithFormat:@"%@:0",LocalizedString(@"Balance")];
    self.bottomMoneyLabel.text = [NSString stringWithFormat:@"%@:0",LocalizedString(@"Balance")];
    NSArray *sqliteArray = [[XXSqliteManager sharedSqlite] mappingTokens];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (XXMappingModel *map in sqliteArray) {
        if ([map.target_symbol isEqualToString:self.mappingModel.target_symbol]) {
            [arr addObject:map];
        }
    }
    [self.topExchangeBtn.customImageView sd_setImageWithURL:[NSURL URLWithString:mappingModel.target_token.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    [self.bottomExchangeBtn.customImageView sd_setImageWithURL:[NSURL URLWithString:mappingModel.issue_token.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    self.topExchangeBtn.customLabel.text = [mappingModel.target_token.name uppercaseString];
    self.bottomExchangeBtn.customLabel.text = [NSString stringWithFormat:@"%@",[mappingModel.issue_token.name uppercaseString]];
    self.bottomExchangeBtn.arrowImageView.hidden = arr.count > 1 ? NO : YES;
    self.bottomExchangeBtn.enabled = arr.count > 1 ? YES : NO;
    _rateDetailLabel.text = [NSString stringWithFormat:@"1%@ = 1%@ ",[mappingModel.target_token.name uppercaseString],[mappingModel.issue_token.name uppercaseString]];
    
    for (XXTokenModel *assetsToken in [XXAssetSingleManager sharedManager].assetModel.assets) {
        if ([mappingModel.target_symbol isEqualToString:assetsToken.symbol] && assetsToken.amount.floatValue > 0) {
            self.topMoneyLabel.text = [NSString stringWithFormat:@"%@:%@",LocalizedString(@"Balance"),assetsToken.amount];
        }
        if ([mappingModel.map_symbol isEqualToString:assetsToken.symbol] && assetsToken.amount.floatValue > 0) {
            self.bottomMoneyLabel.text = [NSString stringWithFormat:@"%@:%@",LocalizedString(@"Balance"),assetsToken.amount];
        }
    }
}

- (void)textFieldChanged:(XXFloadtTextField *)textField {
    self.topField.text = textField.text;
    self.bottomField.text = textField.text;
}

// 交换
- (void)exchangeAction {
    self.mappingModel = [[XXSqliteManager sharedSqlite] mappingModelBySymbol:self.mappingModel.map_symbol];
}

// 选择兑换token
- (void)topAction {
    MJWeakSelf
    [XXChangeMapTokenView showWithSureBlock:^(XXMappingModel * _Nonnull model) {
        weakSelf.mappingModel = model;
    }];
}

- (void)bottomAction {
    MJWeakSelf
    [XXChangeMapTokenView showWithTargetSymbol:self.mappingModel.target_symbol sureBlock:^(XXMappingModel * _Nonnull model) {
        weakSelf.mappingModel = model;
    }];
}

#pragma mark 全部
- (void)allAction {
    for (XXTokenModel *assetsToken in [XXAssetSingleManager sharedManager].assetModel.assets) {
        if ([self.mappingModel.target_symbol isEqualToString:assetsToken.symbol] && assetsToken.amount.floatValue > 0) {
            self.topField.text = assetsToken.amount;
            self.bottomField.text = assetsToken.amount;
        }
    }
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(K375(16), 5, kScreen_Width - K375(15), 380)];
        _backView.backgroundColor = kGray50;
    }
    return _backView;
}

- (UIView *)topBackView {
    if (!_topBackView) {
        _topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.backView.width, 316)];
        _topBackView.backgroundColor = kWhite100;
    }
    return _topBackView;
}

- (XXLabel *)topTitleLabel {
    if (!_topTitleLabel) {
        _topTitleLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), 24, self.backView.width/2, 20) text:LocalizedString(@"Pay") font:kFont15 textColor:kGray700 alignment:NSTextAlignmentLeft];
    }
    return _topTitleLabel;
}

- (XXLabel *)topMoneyLabel {
    if (!_topMoneyLabel) {
        _topMoneyLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.topTitleLabel.frame), self.topTitleLabel.top, self.topBackView.width - K375(16) - CGRectGetMaxX(self.topTitleLabel.frame), 20) text:[NSString stringWithFormat:@"%@:0",LocalizedString(@"Balance")] font:kFont12 textColor:kGray500 alignment:NSTextAlignmentRight];
    }
    return _topMoneyLabel;
}

- (XXExchangeBtn *)topExchangeBtn {
    if (!_topExchangeBtn) {
        _topExchangeBtn = [[XXExchangeBtn alloc] initWithFrame:CGRectMake(K375(16), K375(48), K375(128), 48)];
        [_topExchangeBtn addTarget:self action:@selector(topAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topExchangeBtn;
}

- (UIView *)topFieldBackView {
    if (!_topFieldBackView) {
        _topFieldBackView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.topExchangeBtn.frame) + 8, self.topExchangeBtn.top, self.topBackView.width - K375(16) - CGRectGetMaxX(self.topExchangeBtn.frame) - 8, 48)];
        _topFieldBackView.backgroundColor = kGray50;
    }
    return _topFieldBackView;
}

- (XXFloadtTextField *)topField {
    if (!_topField) {
        _topField = [[XXFloadtTextField alloc] initWithFrame:CGRectMake(10, 0, self.topBackView.width - self.topFieldBackView.width - 60, self.topFieldBackView.height)];
        _topField.textColor = kGray900;
        _topField.placeholderColor = kGray300;
        _topField.placeholder = LocalizedString(@"ExchangePlaceholder");
        _topField.isPrecision = NO;
        [_topField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _topField;
}

- (XXButton *)topAllBtn {
    if (!_topAllBtn) {
        MJWeakSelf
        _topAllBtn = [XXButton buttonWithFrame:CGRectMake(self.topFieldBackView.width - 50, 0, 50, self.topFieldBackView.height) title:LocalizedString(@"All") font:kFont13 titleColor:kPrimaryMain block:^(UIButton *button) {
            [weakSelf allAction];
        }];
    }
    return _topAllBtn;
}

// 交换
- (XXButton *)switchBtn {
    if (!_switchBtn) {
        MJWeakSelf
        _switchBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.topExchangeBtn.frame) + 10, K375(32), 32) block:^(UIButton *button) {
            [weakSelf exchangeAction];
        }];
        [_switchBtn setImage:[UIImage textImageName:@"switchBtn"] forState:UIControlStateNormal];
    }
    return _switchBtn;
}

- (XXLabel *)bottomTitleLabel {
    if (!_bottomTitleLabel) {
        _bottomTitleLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.switchBtn.frame) + 10, self.backView.width/2, 20) text:LocalizedString(@"ExchangeTo") font:kFont15 textColor:kGray700 alignment:NSTextAlignmentLeft];
    }
    return _bottomTitleLabel;
}

- (XXLabel *)bottomMoneyLabel {
    if (!_bottomMoneyLabel) {
        _bottomMoneyLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.bottomTitleLabel.frame) + 8, self.bottomTitleLabel.top, self.topBackView.width - K375(16) - CGRectGetMaxX(self.bottomTitleLabel.frame) -8, 20) text:[NSString stringWithFormat:@"%@:0",LocalizedString(@"Balance")] font:kFont12 textColor:kGray500 alignment:NSTextAlignmentRight];
    }
    return _bottomMoneyLabel;
}

- (XXExchangeBtn *)bottomExchangeBtn {
    if (!_bottomExchangeBtn) {
        _bottomExchangeBtn = [[XXExchangeBtn alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.bottomTitleLabel.frame) + 4, (self.backView.width - K375(88) - K375(30))/2, 48)];
        [_bottomExchangeBtn addTarget:self action:@selector(bottomAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomExchangeBtn;
}

- (UIView *)bottomFieldBackView {
    if (!_bottomFieldBackView) {
        _bottomFieldBackView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bottomExchangeBtn.frame) + 8, self.bottomExchangeBtn.top, self.topBackView.width - K375(16) - CGRectGetMaxX(self.bottomExchangeBtn.frame) - 8, 48)];
        _bottomFieldBackView.backgroundColor = kGray50;
    }
    return _bottomFieldBackView;
}

- (XXFloadtTextField *)bottomField {
    if (!_bottomField) {
        _bottomField = [[XXFloadtTextField alloc] initWithFrame:CGRectMake(10, 0, self.bottomFieldBackView.width - 60, self.bottomFieldBackView.height)];
        _bottomField.textColor = kGray900;
        _bottomField.placeholderColor = kGray300;
        _bottomField.placeholder = LocalizedString(@"ExchangePlaceholder");
        _bottomField.isPrecision = NO;
        [_bottomField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _bottomField;
}

- (XXButton *)bottomAllBtn {
    if (!_bottomAllBtn) {
        MJWeakSelf
        _bottomAllBtn = [XXButton buttonWithFrame:CGRectMake(self.bottomFieldBackView.width - 50, 0, 50, self.bottomFieldBackView.height) title:LocalizedString(@"All") font:kFont13 titleColor:kPrimaryMain block:^(UIButton *button) {
            [weakSelf allAction];
        }];
    }
    return _bottomAllBtn;
}

// 兑换
- (XXButton *)exchangeBtn {
    if (!_exchangeBtn) {
        MJWeakSelf
        _exchangeBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.bottomExchangeBtn.frame) + 24, self.backView.width - K375(32), 48) title:LocalizedString(@"Exchange") font:kFont17 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            if (weakSelf.sureBlock) {
                weakSelf.sureBlock();
            }
        }];
        [_exchangeBtn setBackgroundColor:kPrimaryMain];
        _exchangeBtn.layer.cornerRadius = 6;
        _exchangeBtn.layer.masksToBounds = YES;
    }
    return _exchangeBtn;
}

- (XXLabel *)rateNameLabel {
    if (!_rateNameLabel) {
        CGFloat width = [NSString widthWithText:LocalizedString(@"Rate") font:kFont15];
        _rateNameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.topBackView.frame), width, 64) font:kFont15 textColor:kGray700];
        _rateNameLabel.text = LocalizedString(@"Rate");
    }
    return _rateNameLabel;
}

- (XXLabel *)rateDetailLabel {
    if (!_rateDetailLabel) {
        _rateDetailLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.rateNameLabel.frame)+8, CGRectGetMaxY(self.topBackView.frame), self.backView.width - K375(32), 64) font:kFont14 textColor:kGray900];
    }
    return _rateDetailLabel;
}

- (UIImageView *)ratePointImageView {
    if (!_ratePointImageView) {
        _ratePointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.backView.width - 32, CGRectGetMaxY(self.topBackView.frame) + 24, 16, 16)];
        _ratePointImageView.image = [UIImage imageNamed:@"ratePoint"];
    }
    return _ratePointImageView;
}


@end
