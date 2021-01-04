//
//  XXPasswordView.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/19.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXPasswordView.h"
#import "XXPasswordNumTextFieldView.h"
#import "Account.h"

@interface XXPasswordView()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) XXLabel *titleLabel;
@property (nonatomic, strong) XXPasswordNumTextFieldView *passwordView;
@property (nonatomic, strong) XXButton *cancelButton;
@property (nonatomic, strong) XXLabel *contentLabel;
@property (nonatomic, copy) NSString *content;

@end

@implementation XXPasswordView

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
    if (!IsEmpty(self.content)) {
        [self.contentView addSubview:self.contentLabel];
    }
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.passwordView];
    [self.contentView addSubview:self.cancelButton];
}

+ (void)showWithSureBtnBlock:(void (^)(void))sureBtnBlock {
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

+ (void)showWithContent:(NSString *)content sureBtnBlock:(void (^)(void))sureBtnBlock {
    XXPasswordView *passwordView = [[XXPasswordView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    passwordView.content = content;
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

- (void)finishText:(NSString *)text {
    MJWeakSelf
    if (IsEmpty(KUser.passwordText)) {
        [Account decryptSecretStorageJSON:KUser.currentAccount.keystore password:text callback:^(Account *account, NSError *NSError) {
            if (account) {
                KUser.passwordText = text;
                KUser.privateKey = account.privateKeyString;
                KUser.mnemonicPhrase = account.mnemonicPhrase;
                [[weakSelf class] removeFromSuperView];
                if (weakSelf.sureBtnBlock) {
                    weakSelf.sureBtnBlock();
                }
            } else {
                [weakSelf.passwordView cleanText];
                Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"PasswordWrong") duration:kAlertDuration completion:^{
                }];
                [alert showAlert];
            }
        }];
    } else {
        if ([KUser.passwordText isEqualToString:text]) {
            [[self class] removeFromSuperView];
            if (self.sureBtnBlock) {
                self.sureBtnBlock();
            }
        } else {
            [weakSelf.passwordView cleanText];
            Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"PasswordWrong") duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
        }
    }
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
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(24, (self.height - K375(184))/2, kScreen_Width - 48, K375(184))];
        _contentView.backgroundColor = kBackgroundLeverThird;
        _contentView.layer.cornerRadius = 6;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (XXLabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [XXLabel labelWithFrame:CGRectMake(0, K375(24), self.contentView.width, K375(24)) text:LocalizedString(@"PleaseInputPassword") font:kFontBold20 textColor:kGray900 alignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (XXLabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), K375(64), self.contentView.width - K375(32), 21) text:self.content font:kFont14 textColor:kGray700 alignment:NSTextAlignmentCenter];
    }
    return _contentLabel;
}

- (XXPasswordNumTextFieldView *)passwordView {
    if (_passwordView == nil) {
        CGFloat top = IsEmpty(self.content) ? K375(88) : K375(108);
        _passwordView = [[XXPasswordNumTextFieldView alloc] initWithFrame:CGRectMake(K375(24), top, self.contentView.width - K375(48), K375(56))];
        MJWeakSelf
        _passwordView.finishBlock = ^(NSString * _Nonnull text) {
            [weakSelf finishText:text];
        };
    }
    return _passwordView;
}

- (XXButton *)cancelButton {
    if (_cancelButton == nil) {
        MJWeakSelf
        _cancelButton = [XXButton buttonWithFrame:CGRectMake(10, 18, 50, 50) block:^(UIButton *button) {
            [[weakSelf class] dismiss];
        }];
        [_cancelButton setImage:[UIImage textImageName:@"dismiss"] forState:UIControlStateNormal];
    }
    return _cancelButton;
}

@end
