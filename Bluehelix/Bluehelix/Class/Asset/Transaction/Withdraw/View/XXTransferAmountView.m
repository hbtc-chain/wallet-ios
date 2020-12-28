//
//  XXTransferAmountView.m
//  Bluehelix
//
//  Created by BHEX on 2020/04/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTransferAmountView.h"
@interface XXTransferAmountView () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *lineView;

@end

@implementation XXTransferAmountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.nameLabel];
        [self addSubview:self.subLabel];
        [self addSubview:self.banView];
        [self.banView addSubview:self.allButton];
        [self.banView addSubview:self.tokenLabel];
        [self.banView addSubview:self.textField];
        [self.banView addSubview:self.lineView];
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
    double availableAmount = self.currentlyAvailable.doubleValue - kMinFee.doubleValue;
    if (availableAmount > 0) {
        NSString *amount = [NSString stringWithFormat:@"%f",availableAmount];
        self.textField.text = kAmountLongTrim(amount);
    } else {
        self.textField.text = self.currentlyAvailable;
    }
    if (self.textFieldBoock) {
        self.textFieldBoock();
    }
}

#pragma mark - 3. 当前可用赋值
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
        _nameLabel.text = LocalizedString(@"Transfer");
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
        NSString *titleString = LocalizedString(@"All");
        CGFloat btnWidth = [NSString widthWithText:titleString font:kFont14];
        _allButton = [XXButton buttonWithFrame:CGRectMake(self.banView.width - btnWidth - 12, 0, btnWidth, self.banView.height) title:titleString font:kFont14 titleColor:kPrimaryMain block:^(UIButton *button) {
            if (weakSelf.allButtonActionBlock) {
                weakSelf.allButtonActionBlock();
            }
        }];
    }
    return _allButton;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.banView.width - self.allButton.width - 22, (self.banView.height - 16)/2, 1, 16)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

- (XXLabel *)tokenLabel {
    if (_tokenLabel == nil) {
        _tokenLabel = [XXLabel labelWithFrame:CGRectMake(self.banView.width - self.allButton.width - 32 - 80, 0, 80, self.banView.height) text:@"" font:kFont14 textColor:kGray500 alignment:NSTextAlignmentRight];
    }
    return _tokenLabel;
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
