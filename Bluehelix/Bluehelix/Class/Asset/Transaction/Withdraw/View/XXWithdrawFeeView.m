//
//  XXWithdrawFeeView.m
//  Bhex
//
//  Created by Bhex on 2019/12/18.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "XXWithdrawFeeView.h"

@implementation XXWithdrawFeeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhite100;
        
        [self addSubview:self.nameLabel];
    
        [self addSubview:self.banView];
        
        [self.banView addSubview:self.unitLabel];
        
        [self.banView addSubview:self.textField];
        
    }
    return self;
}

#pragma mark - 1. 输入框值变化
- (void)textFieldChanged:(XXFloadtTextField *)textField {
    
}

#pragma mark - || 懒加载
/** 名称标签 */
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 10, kScreen_Width - KSpacing*2, 24) font:kFontBold14 textColor:kGray];
        _nameLabel.text = LocalizedString(@"Fee");
    }
    return _nameLabel;
}

/** 背景图 */
- (UIView *)banView {
    if (_banView == nil) {
        _banView = [[UIView alloc] initWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.nameLabel.frame) + 12, kScreen_Width - KSpacing*2, 40)];
        _banView.backgroundColor = kFieldBackColor;
    }
    return _banView;
}

/** 单位标签 */
- (XXLabel *)unitLabel {
    if (_unitLabel == nil) {
        _unitLabel = [XXLabel labelWithFrame:CGRectMake(self.banView.width - K375(200), 0, K375(192), self.banView.height) font:kFont14 textColor:kDark50];
        _unitLabel.textAlignment = NSTextAlignmentRight;
    }
    return _unitLabel;
}

/** 输入框 */
- (XXFloadtTextField *)textField {
    if (_textField == nil) {
        _textField = [[XXFloadtTextField alloc] initWithFrame:CGRectMake(K375(8), 0, self.banView.width - K375(16), self.banView.height)];
        _textField.textColor = kDark100;
        _textField.font = kFont14;
        _textField.isPrecision = NO;
        [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        _textField.placeholderColor = kDark50;
    }
    return _textField;
}


@end