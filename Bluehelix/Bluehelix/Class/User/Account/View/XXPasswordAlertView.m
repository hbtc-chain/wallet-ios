//
//  XXPasswordAlertView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/1.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXPasswordAlertView.h"
#import "XXPasswordNumTextFieldView.h"

@interface XXPasswordAlertView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) XXLabel *titleLabel;
@property (nonatomic, strong) XXPasswordNumTextFieldView *passwordView;
@property (nonatomic, strong) XXButton *cancelButton;
@property (nonatomic, strong) XXButton *savePasswordBtn;

@end

@implementation XXPasswordAlertView

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
    [self.contentView addSubview:self.savePasswordBtn];
    [self.contentView addSubview:self.cancelButton];
}

+ (void)showWithSureBtnBlock:(void (^)(NSString *text))sureBtnBlock {
    XXPasswordAlertView *passwordView = [[XXPasswordAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
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
    NSString *pwd = [NSString md5:text];
    if ([pwd isEqualToString:KUser.currentAccount.password] && self.sureBtnBlock) {
        if (KUser.isQuickTextOpen) {
            KUser.lastPasswordTime = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            KUser.text = text;
        }
        [[self class] removeFromSuperView];
        self.sureBtnBlock(text);
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"PasswordWrong") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
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
        self.contentView.top = (self.height - K375(224))/2;
    } else { //键盘升起
        CGFloat keyboardHeight = toFrame.size.height;
        self.contentView.top = kScreen_Height - self.contentView.height - keyboardHeight;
    }
}

+ (void)dismiss {
    XXPasswordAlertView *view = (XXPasswordAlertView *)[self currentView];
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
    XXPasswordAlertView *view = (XXPasswordAlertView *)[self currentView];
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
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(24, (self.height - K375(224))/2, kScreen_Width - 48, K375(224))];
        _contentView.backgroundColor = kBackgroundLeverThird;
        _contentView.layer.cornerRadius = 6;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (XXLabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [XXLabel labelWithFrame:CGRectMake(0, K375(16), self.contentView.width, K375(24)) text:LocalizedString(@"PleaseInputPassword") font:kFontBold20 textColor:kGray900 alignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (XXPasswordNumTextFieldView *)passwordView {
    if (_passwordView == nil) {
        _passwordView = [[XXPasswordNumTextFieldView alloc] initWithFrame:CGRectMake(K375(20), K375(64), self.contentView.width - K375(40), K375(56))];
        MJWeakSelf
        _passwordView.finishBlock = ^(NSString * _Nonnull text) {
            [weakSelf finishText:text];
        };
    }
    return _passwordView;
}

- (XXButton *)savePasswordBtn {
    if (_savePasswordBtn == nil) {
        MJWeakSelf
        _savePasswordBtn = [XXButton buttonWithFrame:CGRectMake(24, CGRectGetMaxY(self.passwordView.frame) + 23, self.contentView.width - 48, 24) block:^(UIButton *button) {
            weakSelf.savePasswordBtn.selected = !weakSelf.savePasswordBtn.selected;
            KUser.isQuickTextOpen = !KUser.isQuickTextOpen;
        }];
        [_savePasswordBtn.titleLabel setFont:kFont12];
        _savePasswordBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        _savePasswordBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_savePasswordBtn setImage:[UIImage subTextImageName:@"unSelected"] forState:UIControlStateNormal];
        [_savePasswordBtn setImage:[UIImage mainImageName:@"selected"] forState:UIControlStateSelected];
        _savePasswordBtn.selected = KUser.isQuickTextOpen; //记录是否开启
        [_savePasswordBtn setTitle:LocalizedString(@"NoNeedPassword") forState:UIControlStateNormal];
        [_savePasswordBtn setTitleColor:kGray900 forState:UIControlStateNormal];
    }
    return _savePasswordBtn;
}

- (XXButton *)cancelButton {
    if (_cancelButton == nil) {
        MJWeakSelf
        _cancelButton = [XXButton buttonWithFrame:CGRectMake(self.contentView.width - 50, 0, 50, 50) block:^(UIButton *button) {
            [[weakSelf class] dismiss];
        }];
        [_cancelButton setImage:[UIImage textImageName:@"dismiss"] forState:UIControlStateNormal];
    }
    return _cancelButton;
}
@end
