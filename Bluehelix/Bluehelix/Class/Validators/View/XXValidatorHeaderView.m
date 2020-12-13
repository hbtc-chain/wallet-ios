//
//  XXValidatorHeaderView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXValidatorHeaderView.h"

@interface XXValidatorHeaderView ()

@property (nonatomic, strong) XXLabel *accountLabel; //账户名
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) XXLabel *titleLabel1; //可用
@property (nonatomic, strong) XXLabel *titleLabel2; //委托中
@property (nonatomic, strong) XXLabel *titleLabel3; //赎回中
@property (nonatomic, strong) XXLabel *titleLabel4; //已收益
@property (nonatomic, strong) XXLabel *titleLabel5; //待领取收益

@property (nonatomic, strong) XXLabel *valueLabel1; //可用
@property (nonatomic, strong) XXLabel *valueLabel2; //委托中
@property (nonatomic, strong) XXLabel *valueLabel3; //赎回中
@property (nonatomic, strong) XXLabel *valueLabel4; //已收益
@property (nonatomic, strong) XXLabel *valueLabel5; //待领取收益
@property (nonatomic, strong) XXButton *getRewardBtn; //领取收益
@end

@implementation XXValidatorHeaderView

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
    [self addSubview:self.accountLabel];
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel1];
    [self.backView addSubview:self.titleLabel2];
    [self.backView addSubview:self.titleLabel3];
    [self.backView addSubview:self.titleLabel4];
    [self.backView addSubview:self.titleLabel5];
    [self.backView addSubview:self.valueLabel1];
    [self.backView addSubview:self.valueLabel2];
    [self.backView addSubview:self.valueLabel3];
    [self.backView addSubview:self.valueLabel4];
    [self.backView addSubview:self.valueLabel5];
    [self.backView addSubview:self.getRewardBtn];
    [self.backView addSubview:self.lineView];
}

- (void)setAssetModel:(XXAssetModel *)assetModel {
    self.valueLabel1.text = kAmountShortTrim(assetModel.amount);
    self.valueLabel2.text = kAmountShortTrim(assetModel.bonded);
    self.valueLabel3.text = kAmountShortTrim(assetModel.unbonding);
    self.valueLabel4.text = kAmountShortTrim(assetModel.claimed_reward);
}

- (void)setDelegations:(NSArray *)delegations {
    _delegations = delegations;
    NSDecimalNumber *sum = [NSDecimalNumber decimalNumberWithString:@"0"];
    for (NSDictionary *dic in self.delegations) {
        NSString *unclaimedReward = dic[@"unclaimed_reward"];
        NSDecimalNumber *unclaimedRewardDecimal = [NSDecimalNumber decimalNumberWithString:unclaimedReward];
        sum = [sum decimalNumberByAdding:unclaimedRewardDecimal];
    }
    self.valueLabel5.text = sum.stringValue;
}

- (XXLabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), 0, self.width/2, 24) text:KUser.currentAccount.userName font:kFont17 textColor:kGray900 alignment:NSTextAlignmentLeft];
    }
    return _accountLabel;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.accountLabel.frame) + 16, self.width - K375(32), 160)];
        _backView.backgroundColor = kBackgroundLeverSecond;
        _backView.layer.cornerRadius = 10.0;
        _backView.layer.shadowColor = [kShadowColor CGColor];
        _backView.layer.shadowRadius = 6.0;
        _backView.layer.shadowOpacity = 1;
        _backView.layer.shadowOffset = CGSizeMake(0, 3);
    }
    return _backView;
}

- (XXLabel *)titleLabel1 {
    if (!_titleLabel1) {
        _titleLabel1 = [XXLabel labelWithFrame:CGRectMake(K375(16), 32, (self.backView.width - K375(32))/3, 20) text:LocalizedString(@"CurrentlyAvailable") font:kFont13 textColor:kGray500];
        _titleLabel1.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel1;
}

- (XXLabel *)titleLabel2 {
    if (!_titleLabel2) {
        _titleLabel2 = [XXLabel labelWithFrame:CGRectMake(K375(16) + (self.backView.width - K375(32))/3, 32, (self.backView.width - K375(32))/3, 20) text:LocalizedString(@"Bonded") font:kFont13 textColor:kGray500];
        _titleLabel2.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel2;
}

- (XXLabel *)titleLabel3 {
    if (!_titleLabel3) {
        _titleLabel3 = [XXLabel labelWithFrame:CGRectMake(K375(16) + 2*(self.backView.width - K375(32))/3, 32, (self.backView.width - K375(32))/3, 20) text:LocalizedString(@"Unbonding") font:kFont13 textColor:kGray500];
        _titleLabel3.textAlignment = NSTextAlignmentRight;
    }
    return _titleLabel3;
}

- (XXLabel *)titleLabel4 {
    if (!_titleLabel4) {
        _titleLabel4 = [XXLabel labelWithFrame:CGRectMake(K375(16), 90, (self.backView.width - K375(32))/3, 20) text:LocalizedString(@"ClaimedReward") font:kFont13 textColor:kGray500];
        _titleLabel4.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel4;
}

- (XXLabel *)titleLabel5 {
    if (!_titleLabel5) {
        _titleLabel5 = [XXLabel labelWithFrame:CGRectMake(K375(16) + (self.backView.width - K375(32))/3, 90, (self.backView.width - K375(32))/3, 20) text:LocalizedString(@"GetEarnings") font:kFont13 textColor:kGray500];
        _titleLabel5.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel5;
}

- (XXLabel *)valueLabel1 {
    if (!_valueLabel1) {
        _valueLabel1 = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.titleLabel1.frame) + 2, (self.backView.width - K375(32))/3, 24) font:kFont15 textColor:kGray900];
        _valueLabel1.textAlignment = NSTextAlignmentLeft;
    }
    return _valueLabel1;
}

- (XXLabel *)valueLabel2 {
    if (!_valueLabel2) {
        _valueLabel2 = [XXLabel labelWithFrame:CGRectMake(K375(16) + (self.backView.width - K375(32))/3, CGRectGetMaxY(self.titleLabel2.frame) + 2, (self.backView.width - K375(32))/3, 24) font:kFont15 textColor:kGray900];
        _valueLabel2.textAlignment = NSTextAlignmentCenter;
    }
    return _valueLabel2;
}

- (XXLabel *)valueLabel3 {
    if (!_valueLabel3) {
        _valueLabel3 = [XXLabel labelWithFrame:CGRectMake(K375(16) + 2*(self.backView.width - K375(32))/3, CGRectGetMaxY(self.titleLabel3.frame) + 2, (self.backView.width - K375(32))/3, 24) font:kFont15 textColor:kGray900];
        _valueLabel3.textAlignment = NSTextAlignmentRight;
    }
    return _valueLabel3;
}

- (XXLabel *)valueLabel4 {
    if (!_valueLabel4) {
        _valueLabel4 = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.titleLabel4.frame) + 2, (self.backView.width - K375(32))/3, 24) font:kFont15 textColor:kGray900];
        _valueLabel4.textAlignment = NSTextAlignmentLeft;
    }
    return _valueLabel4;
}

- (XXLabel *)valueLabel5 {
    if (!_valueLabel5) {
        _valueLabel5 = [XXLabel labelWithFrame:CGRectMake(K375(16) + (self.backView.width - K375(32))/4, CGRectGetMaxY(self.titleLabel4.frame) + 2, (self.backView.width - K375(32))/4 -5, 24) font:kFont15 textColor:kGray900];
        _valueLabel5.textAlignment = NSTextAlignmentRight;
    }
    return _valueLabel5;
}

- (XXButton *)getRewardBtn {
    if (!_getRewardBtn) {
        MJWeakSelf
        _getRewardBtn = [XXButton buttonWithFrame:CGRectMake(self.backView.width/2 +5, CGRectGetMaxY(self.titleLabel4.frame) + 2, (self.backView.width - K375(32))/4, 24) title:LocalizedString(@"GetReward") font:kFont15 titleColor:kPrimaryMain block:^(UIButton *button) {
            if (weakSelf.getRewardBlock) {
                weakSelf.getRewardBlock();
            }
        }];
        [_getRewardBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return _getRewardBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.backView.width/2, CGRectGetMaxY(self.titleLabel4.frame) + 2, 1, 24)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}
@end
