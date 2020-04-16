//
//  XXWithdrawAddressView.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/08.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXWithdrawAddressView.h"

@implementation XXWithdrawAddressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhite100;
        
        [self addSubview:self.nameLabel];
    
        [self addSubview:self.banView];
        
        [self.banView addSubview:self.unitLabel];
        
        [self.banView addSubview:self.codeButton];
        
        [self.banView addSubview:self.textField];
        
    }
    return self;
}

- (void)textFieldChanged:(XXTextField *)textField {
    
}

/** 名称标签 */
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 10, kScreen_Width - KSpacing*2, 24) font:kFontBold14 textColor:kGray];
        _nameLabel.text = LocalizedString(@"WithdrawAddress");
    }
    return _nameLabel;
}

/** 背景图 */
- (UIView *)banView {
    if (_banView == nil) {
        _banView = [[UIView alloc] initWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.nameLabel.frame) + 12, kScreen_Width - KSpacing*2, 48)];
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

/** 扫描按钮 */
- (XXButton *)codeButton {
    if (_codeButton == nil) {
        MJWeakSelf
        _codeButton = [XXButton buttonWithFrame:CGRectMake(self.banView.width - K375(40), 0, K375(39.5), self.banView.height) block:^(UIButton *button) {
            if (weakSelf.codeBlock) {
                weakSelf.codeBlock();
            }
        }];
        [_codeButton setImage:[UIImage textImageName:@"scan_0"] forState:UIControlStateNormal];
    }
    return _codeButton;
}

/** 输入框 */
- (XXTextField *)textField {
    if (_textField == nil) {
        _textField = [[XXTextField alloc] initWithFrame:CGRectMake(K375(8), 0, self.banView.width - K375(56), self.banView.height)];
        _textField.textColor = kDark100;
        _textField.font = kFont14;
        [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        _textField.placeholderColor = kTipColor;
        _textField.placeholder = LocalizedString(@"EnterAddress");
    }
    return _textField;
}

@end
