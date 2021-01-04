//
//  XXPasswordNumTextFieldView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/1.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXPasswordNumTextFieldView.h"

@interface XXPasswordNumTextFieldView ()<UITextFieldDelegate>
{
    CGFloat space;
    CGFloat width;
}
@property (nonatomic, strong) XXLabel *firstLabel;
@property (nonatomic, strong) XXLabel *secondLabel;
@property (nonatomic, strong) XXLabel *thirdLabel;
@property (nonatomic, strong) XXLabel *forthLabel;
@property (nonatomic, strong) XXLabel *fifthLabel;
@property (nonatomic, strong) XXLabel *sixLabel;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation XXPasswordNumTextFieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        space = 8;
        width = (self.width - 5*space)/6;
        [self setupUI];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    [self addSubview:self.textField];
    [self addSubview:self.firstLabel];
    [self addSubview:self.secondLabel];
    [self addSubview:self.thirdLabel];
    [self addSubview:self.forthLabel];
    [self addSubview:self.fifthLabel];
    [self addSubview:self.sixLabel];
    [self.textField becomeFirstResponder];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)cleanText {
    self.textField.text = @"";
    self.text = @"";
    [self reloadUI:@""];
}

- (void)tapAction {
    [self.textField becomeFirstResponder];
}

- (void)reloadUI:(NSString *)text {
    NSUInteger length = text.length + 100;
    for (int i = 100; i < 106; i++) {
       XXLabel *label = [self viewWithTag:i];
        label.text = @"";
        label.layer.borderColor = [kGray500 CGColor];
    }
    for (int i = 100; i < length; i++) {
       XXLabel *label = [self viewWithTag:i];
        label.text = @"●";
    }
    XXLabel *label = [self viewWithTag:length];
    label.layer.borderColor = [kPrimaryMain CGColor];
}

- (void)textFieldDidChange:(UITextField *)textField {
    [self reloadUI:textField.text];
    self.text = textField.text;
    if (textField.text.length == 6) {
        if (self.finishBlock) {
            self.finishBlock(textField.text);
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= 6 && !IsEmpty(string)) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 控件
- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (XXLabel *)firstLabel {
    if (_firstLabel == nil) {
        _firstLabel = [XXLabel labelWithFrame:CGRectMake(0, 0, width, self.height) text:@"" font:kFont12 textColor:kDark100 alignment:NSTextAlignmentCenter];
        _firstLabel.layer.borderColor = [kPrimaryMain CGColor];
        _firstLabel.layer.cornerRadius = 4;
        _firstLabel.layer.borderWidth = KLine_Height;
        _firstLabel.tag = 100;
    }
    return _firstLabel;
}

- (XXLabel *)secondLabel {
    if (_secondLabel == nil) {
        _secondLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.firstLabel.frame) + space, 0, width, self.height) text:@"" font:kFont12 textColor:kDark100 alignment:NSTextAlignmentCenter];
        _secondLabel.layer.borderColor = [kGray500 CGColor];
        _secondLabel.layer.cornerRadius = 4;
        _secondLabel.layer.borderWidth = KLine_Height;
        _secondLabel.tag = 101;
    }
    return _secondLabel;
}

- (XXLabel *)thirdLabel {
    if (_thirdLabel == nil) {
        _thirdLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.secondLabel.frame) + space, 0, width, self.height) text:@"" font:kFont12 textColor:kDark100 alignment:NSTextAlignmentCenter];
        _thirdLabel.layer.borderColor = [kGray500 CGColor];
        _thirdLabel.layer.cornerRadius = 4;
        _thirdLabel.layer.borderWidth = KLine_Height;
        _thirdLabel.tag = 102;
    }
    return _thirdLabel;
}

- (XXLabel *)forthLabel {
    if (_forthLabel == nil) {
        _forthLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.thirdLabel.frame) + space, 0, width, self.height) text:@"" font:kFont12 textColor:kDark100 alignment:NSTextAlignmentCenter];
        _forthLabel.layer.borderColor = [kGray500 CGColor];
        _forthLabel.layer.cornerRadius = 4;
        _forthLabel.layer.borderWidth = KLine_Height;
        _forthLabel.tag = 103;
    }
    return _forthLabel;
}

- (XXLabel *)fifthLabel {
    if (_fifthLabel == nil) {
        _fifthLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.forthLabel.frame) + space, 0, width, self.height) text:@"" font:kFont12 textColor:kDark100 alignment:NSTextAlignmentCenter];
        _fifthLabel.layer.borderColor = [kGray500 CGColor];
        _fifthLabel.layer.cornerRadius = 4;
        _fifthLabel.layer.borderWidth = KLine_Height;
        _fifthLabel.tag = 104;
    }
    return _fifthLabel;
}

- (XXLabel *)sixLabel {
    if (_sixLabel == nil) {
        _sixLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.fifthLabel.frame) + space, 0, width, self.height) text:@"" font:kFont12 textColor:kDark100 alignment:NSTextAlignmentCenter];
        _sixLabel.layer.borderColor = [kGray500 CGColor];
        _sixLabel.layer.cornerRadius = 4;
        _sixLabel.layer.borderWidth = KLine_Height;
        _sixLabel.tag = 105;
    }
    return _sixLabel;
}
@end
