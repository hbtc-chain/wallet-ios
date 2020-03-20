//
//  XXPasswordView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/19.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXPasswordView.h"

@interface XXPasswordView()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (strong, nonatomic) XXLabel *titleLabel;
@property (strong, nonatomic) XXTextFieldView *passwordView;
@property (strong, nonatomic) XXButton *cancelButton;
@property (strong, nonatomic) XXButton *okButton;
@property (strong, nonatomic) XXButton *forgetButton;

@end

@implementation XXPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.backView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.passwordView];
    [self.contentView addSubview:self.okButton];
    [self.contentView addSubview:self.cancelButton];
}

+ (void)showWithSureBtnBlock:(void (^)(NSString *text))sureBtnBlock {
    XXPasswordView *passwordView = [[XXPasswordView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [passwordView buildUI];
    [KWindow addSubview:passwordView];
    
    passwordView.sureBtnBlock = sureBtnBlock;
    passwordView.contentView.alpha = 1;
    passwordView.backView.alpha = 0;
    passwordView.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.2 animations:^{
        passwordView.backView.alpha = 0.3;
        passwordView.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            passwordView.contentView.transform = CGAffineTransformIdentity;
        }];
    }];
}

+ (void)dismiss {
    XXPasswordView *view = (XXPasswordView *)[self currentView];
    if (view) {
        [UIView animateWithDuration:0.25f animations:^{
            view.contentView.alpha = 0;
            view.backView.alpha = 0;
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
}

+ (void)removeFromSuperView {
    XXPasswordView *view = (XXPasswordView *)[self currentView];
    if (view) {
        [view removeFromSuperview];
    }
}

+ (UIView *)currentView {
    for (UIView *view in [KWindow subviews]) {
        if ([view isKindOfClass:[self class]]) {
            return view;
        }
    }
    return nil;
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.3f;
    }
    return _backView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(K375(15.5), (self.height - 209)/2, K375(344), 209)];
        _contentView.backgroundColor = kWhite100;
        _contentView.layer.cornerRadius = 3;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (XXButton *)cancelButton {
    if (_cancelButton == nil) {
        MJWeakSelf
        _cancelButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - 70, 18, 20,20) title:LocalizedString(@"") font:kFontBold14 titleColor:kDark100 block:^(UIButton *button) {
            [[weakSelf class] dismiss];
        }];
        [_cancelButton setImage:[UIImage textImageName:@"dismiss"] forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (void)okButtonClick:(UIButton *)sender {
     NSString *pwd = [NSString md5:self.passwordView.textField.text];
    if ([pwd isEqualToString:KUser.rootAccount[@"password"]] && self.sureBtnBlock) {
        [[self class] removeFromSuperView];
        self.sureBtnBlock(self.passwordView.textField.text);
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"密码不正确") duration:kAlertDuration completion:^{
                   }];
        [alert showAlert];
    }
}

- (void)textFieldValueChange:(UITextField *)textField {
    if ([self.passwordView.textField.text trimmingCharacters].length > 0) {
        self.okButton.enabled = YES;
    } else {
        self.okButton.enabled = NO;
    }
}

- (XXButton *)okButton {
    if (_okButton == nil) {
        MJWeakSelf
        _okButton = [XXButton buttonWithFrame:CGRectMake(24, CGRectGetMaxY(self.passwordView.frame) + 20, K375(344) - 48, 40) title:LocalizedString(@"Sure") font:kFontBold14 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf okButtonClick:button];
        }];
        _okButton.layer.cornerRadius = 3;
        _okButton.layer.masksToBounds = YES;
        [_okButton setBackgroundImage:[UIImage createImageWithColor:kBlue100] forState:UIControlStateNormal];
        _okButton.enabled = NO;
    }
    return _okButton;
}

- (XXLabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [XXLabel labelWithFrame:CGRectMake(50, 16, kScreen_Width - 100, 24) text:LocalizedString(@"Password") font:kFontBold18 textColor:kDark100 alignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (XXTextFieldView *)passwordView {
    if (_passwordView == nil) {
        _passwordView = [[XXTextFieldView alloc] initWithFrame:CGRectMake(24, 70, K375(344) - 48, 40)];
        _passwordView.textField.placeholder = LocalizedString(@"PleaseEnterPassword");
        _passwordView.textField.delegate = self;
        _passwordView.textField.secureTextEntry = YES;
        [_passwordView.textField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordView;
}
@end
