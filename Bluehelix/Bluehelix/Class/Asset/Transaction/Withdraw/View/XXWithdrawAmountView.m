//
//  XXWithdrawAmountView.m
//  Bhex
//
//  Created by Bhex on 2019/12/17.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "XXWithdrawAmountView.h"
#import "XXTokenModel.h"

@implementation XXWithdrawAmountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        
        [self addSubview:self.nameLabel];
        
        [self addSubview:self.subLabel];
        
        [self addSubview:self.banView];
        
        [self.banView addSubview:self.allButton];
        
        [self.banView addSubview:self.textField];
        
    }
    return self;
}

#pragma mark - 1. 输入框值变化
- (void)textFieldChanged:(XXFloadtTextField *)textField {
    if (self.textFieldBoock) {
        self.textFieldBoock();
    }
}

#pragma mark - 2. 全部按钮点击事件
- (void)allButtonClick:(UIButton *)sender {
    if ([self.tokenModel.chain isEqualToString:self.tokenModel.symbol]) {
        NSDecimalNumber *availableDecimal = [NSDecimalNumber decimalNumberWithString:self.currentlyAvailable];
        NSDecimalNumber *withdrawFeeDecimal = [NSDecimalNumber decimalNumberWithString:self.tokenModel.withdrawal_fee];
        NSDecimalNumber *resultDecimal = [availableDecimal decimalNumberBySubtracting:withdrawFeeDecimal];
        if (resultDecimal.doubleValue > 0) {
            self.textField.text = kAmountLongTrim(resultDecimal.stringValue);
        } else {
            self.textField.text = self.currentlyAvailable;
        }
    } else {
        self.textField.text = self.currentlyAvailable;
    }
    if (self.textFieldBoock) {
        self.textFieldBoock();
    }
}

#pragma mark - 3. 当前可提赋值
- (void)setCurrentlyAvailable:(NSString *)currentlyAvailable {
    _currentlyAvailable = currentlyAvailable;
    NSMutableArray *itemsArray = [NSMutableArray array]; // 可用
    itemsArray[0] = @{@"string":[NSString stringWithFormat:@"%@ : ", LocalizedString(@"CurrentlyAvailable")], @"color":kGray500, @"font":kFont12};
    itemsArray[1] = @{@"string":[NSString stringWithFormat:@"%@ %@", currentlyAvailable, KString(self.tokenName)], @"color":kGray500, @"font":kFontBold12};
    self.subLabel.attributedText = [NSString mergeStrings:itemsArray];
}

#pragma mark - 4. 提示按钮点击事件
- (void)alertButtonClick:(UIButton *)sender {
    
}

#pragma mark - || 懒加载
/** 名称标签 */
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 16, kScreen_Width - KSpacing*2, 24) font:kFont15 textColor:kGray];
    }
    return _nameLabel;
}

/** 字标签 */
- (XXLabel *)subLabel {
    if (_subLabel == nil) {
        _subLabel = [XXLabel labelWithFrame:self.nameLabel.frame font:kFont13 textColor:kGray500];
        _subLabel.textAlignment = NSTextAlignmentRight;
    }
    return _subLabel;
}

/** 背景图 */
- (UIView *)banView {
    if (_banView == nil) {
        _banView = [[UIView alloc] initWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.nameLabel.frame) + 4, kScreen_Width - KSpacing*2, 48)];
        _banView.backgroundColor = kGray50;
        _banView.layer.cornerRadius = 4;
        _banView.layer.masksToBounds = YES;
    }
    return _banView;
}

/** 全部按钮 */
- (XXButton *)allButton {
    if (_allButton == nil) {
        MJWeakSelf
        NSString *titleString = LocalizedString(@"WithdrawAll");
        CGFloat btnWidth = [NSString widthWithText:titleString font:kFont14] + 16;
        _allButton = [XXButton buttonWithFrame:CGRectMake(self.banView.width - btnWidth, 0, btnWidth, self.banView.height) title:titleString font:kFont15 titleColor:kPrimaryMain block:^(UIButton *button) {
            if (weakSelf.allButtonActionBlock) {
                weakSelf.allButtonActionBlock();
            }
        }];
    }
    return _allButton;
}

/** 输入框 */
- (XXFloadtTextField *)textField {
    if (_textField == nil) {
        _textField = [[XXFloadtTextField alloc] initWithFrame:CGRectMake(K375(8), 0, self.banView.width - K375(8) - self.allButton.width, self.banView.height)];
        _textField.textColor = kGray900;
        _textField.font = kFont15;
        _textField.isPrecision = NO;
        [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        _textField.placeholderColor = kGray500;
        _textField.placeholder = LocalizedString(@"PleaseEnterAmount");
    }
    return _textField;
}
@end
