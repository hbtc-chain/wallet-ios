//
//  XXTextFieldView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTextFieldView.h"

@implementation XXTextFieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kDark5;
        [self addSubview:self.textField];
        self.layer.cornerRadius = kBtnBorderRadius;
    }
    return self;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(8, 0, self.width - 16, self.height)];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _textField.delegate = self;
               _textField.autocorrectionType = UITextAutocorrectionTypeNo;
               _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
               _textField.textColor = kDark100;
               _textField.font = kFont14;
    }
    return _textField;
}

@end
