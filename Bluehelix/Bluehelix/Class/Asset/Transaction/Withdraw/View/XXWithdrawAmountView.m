//
//  XXWithdrawAmountView.m
//  Bhex
//
//  Created by Bhex on 2019/12/17.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "XXWithdrawAmountView.h"

@implementation XXWithdrawAmountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhite100;
        
        [self addSubview:self.nameLabel];
        
        [self addSubview:self.subLabel];
        
        [self addSubview:self.banView];
        
        [self.banView addSubview:self.allButton];

        [self.banView addSubview:self.textField];
        
        [self addSubview:self.riskAssetLabel];
        
        [self addSubview:self.alertButton];
        
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
    self.textField.text = self.currentlyAvailable;
    if (self.textFieldBoock) {
        self.textFieldBoock();
    }
}

#pragma mark - 3. 当前可提赋值
- (void)setCurrentlyAvailable:(NSString *)currentlyAvailable {
    _currentlyAvailable = currentlyAvailable;
    
    NSMutableArray *itemsArray = [NSMutableArray array]; // 当前可提
    itemsArray[0] = @{@"string":[NSString stringWithFormat:@"%@ : ", LocalizedString(@"CurrentlyAvailable")], @"color":kDark50, @"font":kFont12};
    itemsArray[1] = @{@"string":[NSString stringWithFormat:@"%@ %@", currentlyAvailable, KString(self.tokenName)], @"color":kDark80, @"font":kFontBold12};
    self.subLabel.attributedText = [NSString mergeStrings:itemsArray];
}

#pragma mark - 4. 提示按钮点击事件
- (void)alertButtonClick:(UIButton *)sender {
    
}

#pragma mark - || 懒加载
/** 名称标签 */
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 10, kScreen_Width - KSpacing*2, 24) font:kFontBold14 textColor:kDark80];
        _nameLabel.text = LocalizedString(@"WithdrawAmount");
    }
    return _nameLabel;
}

/** 字标签 */
- (XXLabel *)subLabel {
    if (_subLabel == nil) {
        _subLabel = [XXLabel labelWithFrame:self.nameLabel.frame font:kFont14 textColor:kDark50];
        _subLabel.textAlignment = NSTextAlignmentRight;
    }
    return _subLabel;
}

/** 背景图 */
- (UIView *)banView {
    if (_banView == nil) {
        _banView = [[UIView alloc] initWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.nameLabel.frame) + 12, kScreen_Width - KSpacing*2, 48)];
        _banView.backgroundColor = kFieldBackColor;
    }
    return _banView;
}

/** 全部按钮 */
- (XXButton *)allButton {
    if (_allButton == nil) {
        MJWeakSelf
        NSString *titleString = LocalizedString(@"WithdrawAll");
        CGFloat btnWidth = [NSString widthWithText:titleString font:kFont14] + 16;
        _allButton = [XXButton buttonWithFrame:CGRectMake(self.banView.width - btnWidth, 0, btnWidth, self.banView.height) title:titleString font:kFont14 titleColor:kBlue100 block:^(UIButton *button) {
            [weakSelf allButtonClick:button];
        }];
    }
    return _allButton;
}

/** 输入框 */
- (XXFloadtTextField *)textField {
    if (_textField == nil) {
        _textField = [[XXFloadtTextField alloc] initWithFrame:CGRectMake(K375(8), 0, self.banView.width - K375(8) - self.allButton.width, self.banView.height)];
        _textField.textColor = kDark100;
        _textField.font = kFont14;
        _textField.isPrecision = YES;
        [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        _textField.placeholderColor = kTipColor;
        _textField.placeholder = LocalizedString(@"PleaseEnterAmount");
    }
    return _textField;
}

/** 风险资产标签 */
- (XXLabel *)riskAssetLabel {
    if (_riskAssetLabel == nil) {
        _riskAssetLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.banView.frame), kScreen_Width - KSpacing*2 - 32, 32) font:kFont14 textColor:kBlue100];
        _riskAssetLabel.textAlignment = NSTextAlignmentRight;
    }
    return _riskAssetLabel;
}

/** 提示按钮 */
- (XXButton *)alertButton {
    if (_alertButton == nil) {
        MJWeakSelf
        _alertButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.riskAssetLabel.frame), self.riskAssetLabel.top, 32, self.riskAssetLabel.height) block:^(UIButton *button) {
            [weakSelf alertButtonClick:button];
        }];
        [_alertButton setImage:[UIImage textImageName:@"tips"] forState:UIControlStateNormal];
    }
    return _alertButton;
}
@end
