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

@interface XXExchangeView ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) XXExchangeBtn * leftExchangeBtn;
@property (nonatomic, strong) XXExchangeBtn * rightExchangeBtn;
@property (nonatomic, strong) XXButton *switchBtn;
@property (nonatomic, strong) UIView *amountView;
@property (nonatomic, strong) XXLabel *rateNameLabel;
@property (nonatomic, strong) XXButton *exchangeBtn;
@property (nonatomic, strong) UIImageView *ratePointImageView;
@property (nonatomic, strong) XXLabel *rateDetailLabel;
@property (nonatomic, assign) BOOL mainTokenFlag;

@end

@implementation XXExchangeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.mainTokenFlag = YES;
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.backImageView];
    [self.backImageView addSubview:self.leftExchangeBtn];
    [self.backImageView addSubview:self.switchBtn];
    [self.backImageView addSubview:self.rightExchangeBtn];
    [self.backImageView addSubview:self.amountView];
    [self.backImageView addSubview:self.rateNameLabel];
    [self.backImageView addSubview:self.rateDetailLabel];
    [self.backImageView addSubview:self.exchangeBtn];
    [self.backImageView addSubview:self.ratePointImageView];
    [self.amountView addSubview:self.leftField];
}

- (void)setMappingModel:(XXMappingModel *)mappingModel {
    _mappingModel = mappingModel;
    [self.leftExchangeBtn.customImageView sd_setImageWithURL:[NSURL URLWithString:mappingModel.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    [self.rightExchangeBtn.customImageView sd_setImageWithURL:[NSURL URLWithString:mappingModel.logo] placeholderImage:[UIImage imageNamed:@"placeholderToken"]];
    self.leftExchangeBtn.customLabel.text = [mappingModel.target_symbol uppercaseString];
    self.rightExchangeBtn.customLabel.text = [NSString stringWithFormat:@"%@",[mappingModel.map_symbol uppercaseString]];
        _rateDetailLabel.text = [NSString stringWithFormat:@"1 %@=1 %@",[mappingModel.target_symbol uppercaseString],[mappingModel.map_symbol uppercaseString]];    
}

- (void)textFieldChanged:(XXFloadtTextField *)textField {
    
}

// 交换
- (void)exchangeAction {
    self.mainTokenFlag = !self.mainTokenFlag;
    self.mappingModel = [[XXSqliteManager sharedSqlite] mappingModelBySymbol:self.mappingModel.map_symbol];
//    [UIView animateWithDuration:0.3 animations:^{
//        if (self.mainTokenFlag) {
//            self.leftExchangeBtn.left = K375(16) + K375(15);
//            self.rightExchangeBtn.left = CGRectGetMaxX(self.switchBtn.frame);
//        } else {
//            self.leftExchangeBtn.left = CGRectGetMaxX(self.switchBtn.frame);
//            self.rightExchangeBtn.left = K375(16) + K375(15);
//        }
//    } completion:^(BOOL finished) {
//        self.mappingModel = [[XXSqliteManager sharedSqlite] mappingModelBySymbol:self.mappingModel.issue_symbol];
//    }];
}

- (void)leftAction {
    MJWeakSelf
    [XXChangeMapTokenView showWithSureBlock:^(XXMappingModel * _Nonnull model) {
        weakSelf.mappingModel = model;
    }];
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(7), 5, kScreen_Width - K375(15), K375(304))];
        _backImageView.image = [UIImage imageNamed:@"exchangeBack"];
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}

- (XXExchangeBtn *)leftExchangeBtn {
    if (!_leftExchangeBtn) {
        _leftExchangeBtn = [[XXExchangeBtn alloc] initWithFrame:CGRectMake(K375(16) + K375(15), K375(36), (self.backImageView.width - K375(88) - K375(30))/2, K375(24))];
        [_leftExchangeBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftExchangeBtn;
}

// 交换
- (XXButton *)switchBtn {
    if (!_switchBtn) {
        MJWeakSelf
        _switchBtn = [XXButton buttonWithFrame:CGRectMake((self.backImageView.width - K375(88))/2, K375(8), K375(88), K375(80)) block:^(UIButton *button) {
            [weakSelf exchangeAction];
        }];
        [_switchBtn setImage:[UIImage imageNamed:@"switchBtn"] forState:UIControlStateNormal];
    }
    return _switchBtn;
}

- (XXExchangeBtn *)rightExchangeBtn {
    if (!_rightExchangeBtn) {
        _rightExchangeBtn = [[XXExchangeBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.switchBtn.frame), K375(36), (self.backImageView.width - K375(88) - K375(30))/2, K375(24))];
    }
    return _rightExchangeBtn;
}

- (UIView *)amountView {
    if (!_amountView) {
        _amountView = [[UIView alloc] initWithFrame:CGRectMake(K375(8) + K375(15), K375(88), self.backImageView.width - K375(16) - K375(30), K375(48))];
        _amountView.backgroundColor = kGray50;
    }
    return _amountView;
}

- (XXFloadtTextField *)leftField {
    if (!_leftField) {
        _leftField = [[XXFloadtTextField alloc] initWithFrame:CGRectMake(10, 0, self.amountView.width - 10, self.amountView.height)];
        _leftField.textColor = kGray900;
        _leftField.placeholderColor = kGray300;
        _leftField.placeholder = LocalizedString(@"ExchangePlaceholder");
        _leftField.isPrecision = NO;
        [_leftField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _leftField;
}

//- (XXFloadtTextField *)rightField {
//    if (!_rightField) {
//        _rightField = [[XXFloadtTextField alloc] initWithFrame:CGRectMake(self.amountView.width/2, 0, self.amountView.width/2, self.amountView.height)];
//        _rightField.textAlignment = NSTextAlignmentRight;
//        _rightField.textColor = kGray900;
//        _rightField.placeholderColor = kGray300;
//        _rightField.placeholder = LocalizedString(@"ExchangePlaceholder");
//        [_rightField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
//
//    }
//    return _rightField;
//}

- (XXLabel *)rateNameLabel {
    if (!_rateNameLabel) {
        _rateNameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16) + K375(15), K375(186), 0, 20) font:kFont15 textColor:kGray700];
        _rateNameLabel.text = LocalizedString(@"Rate");
        [_rateNameLabel sizeToFit];
    }
    return _rateNameLabel;
}

- (XXLabel *)rateDetailLabel {
    if (!_rateDetailLabel) {
        _rateDetailLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.rateNameLabel.frame)+8, K375(184), self.backImageView.width - K375(32) - K375(30), 24) font:kFont15 textColor:kGray900];
    }
    return _rateDetailLabel;
}

- (UIImageView *)ratePointImageView {
    if (!_ratePointImageView) {
        _ratePointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.backImageView.width - K375(30) - K375(16), K375(188), K375(16), K375(16))];
        _ratePointImageView.image = [UIImage imageNamed:@"ratePoint"];
    }
    return _ratePointImageView;
}

// 兑换
- (XXButton *)exchangeBtn {
    if (!_exchangeBtn) {
        MJWeakSelf
        _exchangeBtn = [XXButton buttonWithFrame:CGRectMake(K375(8) + K375(15), self.backImageView.height - K375(72), self.backImageView.width - K375(16) - K375(30), K375(48)) title:LocalizedString(@"Exchange") font:kFont17 titleColor:kWhiteColor block:^(UIButton *button) {
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
@end
