//
//  XXTextFieldView.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTextFieldView.h"

@implementation XXTextFieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kGray50;
        [self addSubview:self.textField];
        [self addSubview:self.lookButton];
        self.layer.cornerRadius = kBtnBorderRadius;
    }
    return self;
}

- (void)setShowLookBtn:(BOOL)showLookBtn {
    if (showLookBtn) {
        self.textField.secureTextEntry = YES;
        self.lookButton.hidden = NO;
        self.textField.frame = CGRectMake(8, 0, self.width - 16 - self.height, self.height);
    } else {
        self.lookButton.hidden = YES;
        self.textField.frame = CGRectMake(8, 0, self.width - 16, self.height);
    }
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(8, 0, self.width - 16, self.height)];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.textColor = kGray900;
        _textField.font = kFont14;
    }
    return _textField;
}

- (void)setPlaceholder:(NSString *)placeholder {
    NSString *text = placeholder ? placeholder : @"";
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName:kGray500, NSFontAttributeName:kFont14}];
    self.textField.attributedPlaceholder = attrString;
}

- (XXButton *)lookButton {
    if (_lookButton == nil) {
        MJWeakSelf
        _lookButton = [XXButton buttonWithFrame:CGRectMake(self.width - self.height, 0, self.height, self.height) block:^(UIButton *button) {
            weakSelf.lookButton.selected = !weakSelf.lookButton.selected;
            if (weakSelf.lookButton.selected) {
                weakSelf.textField.secureTextEntry = NO;
            } else {
                weakSelf.textField.secureTextEntry = YES;
            }
        }];
        [_lookButton setImage:[UIImage subTextImageName:@"icon_look_n_0"] forState:UIControlStateNormal];
        [_lookButton setImage:[UIImage imageNamed:@"icon_look_y"] forState:UIControlStateSelected];
        _lookButton.hidden = YES;
    }
    return _lookButton;
}

@end
