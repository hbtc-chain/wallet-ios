//
//  XXMnemonicWordTextFieldView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/7/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXMnemonicWordTextFieldView.h"

@implementation XXMnemonicWordTextFieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.type = MnemonicWordTextFieldViewType_Wrong;
        [self addSubview:self.textField];
    }
    return self;
}

- (XXTextField *)textField {
    if (!_textField) {
        _textField =
        _textField = [[XXTextField alloc] initWithFrame:CGRectMake(2, 0, self.width - 4, self.height)];
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.textColor = kGray900;
        _textField.font = kFont13;
        _textField.textAlignment = NSTextAlignmentCenter;
    }
    return _textField;
}

- (void)setType:(MnemonicWordTextFieldViewType)type {
    if (type == MnemonicWordTextFieldViewType_Wrong) {
        self.textField.textColor = kPriceFall;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [kPriceFall CGColor];
    } else {
        self.textField.textColor = kGray900;
        self.layer.borderWidth = 0;
        self.layer.borderColor = [kPriceFall CGColor];
    }
}

@end
