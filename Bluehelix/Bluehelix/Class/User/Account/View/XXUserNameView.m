//
//  XXPasswordView.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/19.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXUserNameView.h"

@interface XXUserNameView()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (strong, nonatomic) XXLabel *titleLabel;
@property (strong, nonatomic) XXTextFieldView *passwordView;
@property (strong, nonatomic) XXButton *cancelButton;
@property (strong, nonatomic) XXButton *okButton;
@property (strong, nonatomic) XXButton *forgetButton;

@end

@implementation XXUserNameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.backView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.passwordView];
    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.okButton];
}

+ (void)showWithSureBlock:(void (^)(void))sureBlock {
    XXUserNameView *userNameView = [[XXUserNameView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [userNameView buildUI];
    [KWindow addSubview:userNameView];
    
    userNameView.contentView.alpha = 1;
    userNameView.sureBlock = sureBlock;
    userNameView.backView.alpha = 0;
    userNameView.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.2 animations:^{
        userNameView.backView.alpha = 0.3;
        userNameView.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            userNameView.contentView.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)okButtonClick:(UIButton *)sender {
    
//     NSString *pwd = [NSString md5:self.passwordView.textField.text];
//    if ([pwd isEqualToString:KUser.currentAccount.password] && self.sureBtnBlock) {
//        [[self class] removeFromSuperView];
//        self.sureBtnBlock(self.passwordView.textField.text);
//    } else {
//        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"PasswordWrong") duration:kAlertDuration completion:^{
//                   }];
//        [alert showAlert];
//    }
     [[XXSqliteManager sharedSqlite] updateAccountColumn:@"userName" value:self.passwordView.textField.text];
    if (self.sureBlock) {
        self.sureBlock();
    }
    [[self class] dismiss];
}

- (void)keyboardFrameChange:(NSNotification *)notifi{
    
    NSDictionary *userInfo = notifi.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)(void) = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
        
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame {
    if (toFrame.origin.y  == [[UIScreen mainScreen] bounds].size.height){//键盘收起
        self.contentView.top = (self.height - K375(184))/2;
    } else { //键盘升起
        CGFloat keyboardHeight = toFrame.size.height;
        self.contentView.top = kScreen_Height - self.contentView.height - keyboardHeight;
    }
}

- (void)textFieldValueChange:(UITextField *)textField {

}

+ (void)dismiss {
    XXUserNameView *view = (XXUserNameView *)[self currentView];
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
    XXUserNameView *view = (XXUserNameView *)[self currentView];
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
        _contentView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width - K375(280))/2, (self.height - K375(184))/2, K375(280), K375(184))];
        _contentView.backgroundColor = kBackgroundLeverThird;
        _contentView.layer.cornerRadius = 6;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (XXLabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [XXLabel labelWithFrame:CGRectMake(0, K375(16), self.contentView.width, K375(24)) text:LocalizedString(@"ModifyUserName") font:kFontBold20 textColor:kGray900 alignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (XXTextFieldView *)passwordView {
    if (_passwordView == nil) {
        _passwordView = [[XXTextFieldView alloc] initWithFrame:CGRectMake(K375(20), K375(64), self.contentView.width - K375(40), K375(48))];
        _passwordView.textField.delegate = self;
        _passwordView.textField.text = KUser.currentAccount.userName;
        [_passwordView.textField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordView;
}

- (XXButton *)okButton {
    if (_okButton == nil) {
        MJWeakSelf
        _okButton = [XXButton buttonWithFrame:CGRectMake(self.contentView.width/2 + K375(4), CGRectGetMaxY(self.passwordView.frame) + K375(24), (self.contentView.width - K375(24))/2, K375(40)) title:LocalizedString(@"Sure") font:kFontBold14 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf okButtonClick:button];
        }];
        _okButton.layer.cornerRadius = kBtnBorderRadius;
        _okButton.layer.masksToBounds = YES;
        _okButton.backgroundColor = kPrimaryMain;
    }
    return _okButton;
}

- (XXButton *)cancelButton {
    if (_cancelButton == nil) {
        MJWeakSelf
        _cancelButton = [XXButton buttonWithFrame:CGRectMake(K375(8), CGRectGetMaxY(self.passwordView.frame) + K375(24), (self.contentView.width - K375(24))/2, K375(40)) title:LocalizedString(@"Cancel") font:kFontBold14 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [[weakSelf class] dismiss];
        }];
        _cancelButton.layer.cornerRadius = kBtnBorderRadius;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.backgroundColor = kGray200;
    }
    return _cancelButton;
}

@end
