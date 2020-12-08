//
//  XXSetPasswordNumTextFieldView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/2.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXSetPasswordNumTextFieldView.h"

@interface XXSetPasswordNumTextFieldView ()<UITextFieldDelegate>
{
    CGFloat space;
}
@property (nonatomic, strong) UIView *firstView;
@property (nonatomic, strong) UIView *secondView;
@property (nonatomic, strong) UIView *thirdView;
@property (nonatomic, strong) UIView *forthView;
@property (nonatomic, strong) UIView *fifthView;
@property (nonatomic, strong) UIView *sixView;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation XXSetPasswordNumTextFieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        space = (self.width - 24*6)/5;
        [self setupUI];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    [self addSubview:self.textField];
    [self addSubview:self.firstView];
    [self addSubview:self.secondView];
    [self addSubview:self.thirdView];
    [self addSubview:self.forthView];
    [self addSubview:self.fifthView];
    [self addSubview:self.sixView];
    [self.textField becomeFirstResponder];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction {
    [self.textField becomeFirstResponder];
}

- (void)reloadUI:(NSString *)text {
    NSUInteger length = text.length + 100;
    for (int i = 100; i < 106; i++) {
        UIView *view = [self viewWithTag:i];
        view.layer.borderColor = [kGray700 CGColor];
        view.backgroundColor = [UIColor clearColor];
    }
    for (int i = 100; i < length; i++) {
        UIView *view = [self viewWithTag:i];
        view.backgroundColor = kGray700;
    }
    UIView *view = [self viewWithTag:length];
    view.layer.borderColor = [kPrimaryMain CGColor];
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

- (UIView *)firstView {
    if (_firstView == nil) {
        _firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.height, self.height)];
        _firstView.layer.borderColor = [kPrimaryMain CGColor];
        _firstView.layer.cornerRadius = self.height/2;
        _firstView.layer.borderWidth = KLine_Height;
        _firstView.tag = 100;
    }
    return _firstView;
}

- (UIView *)secondView {
    if (_secondView == nil) {
        _secondView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.firstView.frame) + space, 0, self.height, self.height)];
        _secondView.layer.borderColor = [kGray700 CGColor];
        _secondView.layer.cornerRadius = self.height/2;
        _secondView.layer.borderWidth = KLine_Height;
        _secondView.tag = 101;
    }
    return _secondView;
}

- (UIView *)thirdView {
    if (_thirdView == nil) {
        _thirdView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.secondView.frame) + space, 0, self.height, self.height)];
        _thirdView.layer.borderColor = [kGray700 CGColor];
        _thirdView.layer.cornerRadius = self.height/2;
        _thirdView.layer.borderWidth = KLine_Height;
        _thirdView.tag = 102;
    }
    return _thirdView;
}

- (UIView *)forthView {
    if (_forthView == nil) {
        _forthView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.thirdView.frame) + space, 0, self.height, self.height)];
        _forthView.layer.borderColor = [kGray700 CGColor];
        _forthView.layer.cornerRadius = self.height/2;
        _forthView.layer.borderWidth = KLine_Height;
        _forthView.tag = 103;
    }
    return _forthView;
}

- (UIView *)fifthView {
    if (_fifthView == nil) {
        _fifthView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.forthView.frame) + space, 0, self.height, self.height)];
        _fifthView.layer.borderColor = [kGray700 CGColor];
        _fifthView.layer.cornerRadius = self.height/2;
        _fifthView.layer.borderWidth = KLine_Height;
        _fifthView.tag = 104;
    }
    return _fifthView;
}

- (UIView *)sixView {
    if (_sixView == nil) {
        _sixView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.fifthView.frame) + space, 0, self.height, self.height)];
        _sixView.layer.borderColor = [kGray700 CGColor];
        _sixView.layer.cornerRadius = self.height/2;
        _sixView.layer.borderWidth = KLine_Height;
        _sixView.tag = 105;
    }
    return _sixView;
}

@end
