//
//  XXChangePasswordVC.m
//  Bhex
//
//  Created by Bhex on 2018/8/13.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXChangePasswordVC.h"
#import "XXTextFieldView.h"
#import "XYHNumbersLabel.h"
#import "AESCrypt.h"

#define ItemHeight 40

@interface XXChangePasswordVC ()<UITextFieldDelegate>

/** 旧密码 */
@property (strong, nonatomic) XXTextFieldView *oldPasswordView;

/** 密码 */
@property (strong, nonatomic) XXTextFieldView *passwordView;

/** 确认密码 */
@property (strong, nonatomic) XXTextFieldView *okPasswordView;

/** 确认按钮 */
@property (strong, nonatomic) XXButton *okButton;


@end

@implementation XXChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = LocalizedString(@"ModifyPassword");
    [self.view addSubview:self.oldPasswordView];
    [self.view addSubview:self.passwordView];
    [self.view addSubview:self.okPasswordView];
    [self.view addSubview:self.okButton];
}

- (void)textFiledValueChange:(UITextField *)textField {
    if (self.oldPasswordView.textField.text.length > 0 && [[self.passwordView.textField.text trimmingCharacters] isValidPasswordString] && [[self.okPasswordView.textField.text trimmingCharacters] isValidPasswordString]) {
        self.okButton.enabled = YES;
        self.okButton.backgroundColor = kPrimaryMain;
    } else {
        self.okButton.enabled = NO;
        self.okButton.backgroundColor = kGray100;
    }
}

- (void)changePassword {
    NSString *oldPassword = self.oldPasswordView.textField.text;
    NSString *newPassword = self.okPasswordView.textField.text;
    NSString *privateKeyString = [AESCrypt decrypt:KUser.currentAccount.privateKey password:oldPassword];
    NSString *newPrivateKey = [AESCrypt encrypt:privateKeyString password:newPassword];
    [[XXSqliteManager sharedSqlite] updateAccountColumn:@"privateKey" value:newPrivateKey];
    if (!IsEmpty(KUser.currentAccount.mnemonicPhrase)) {
        NSString *oldMnemonicPhrase = [AESCrypt decrypt:KUser.currentAccount.mnemonicPhrase password:oldPassword];
        NSString *newMnemonicPhrase = [AESCrypt encrypt:oldMnemonicPhrase password:newPassword];
        [[XXSqliteManager sharedSqlite] updateAccountColumn:@"mnemonicPhrase" value:newMnemonicPhrase];
    }
    [[XXSqliteManager sharedSqlite] updateAccountColumn:@"password" value:[NSString md5:newPassword]];
    Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"ChangePasswordSuccess") duration:kAlertDuration completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert showAlert];
}

- (void)okButtonClick:(UIButton *)sender {
    if (![self.passwordView.textField.text isEqualToString:self.okPasswordView.textField.text]) {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"TwoPasswordInconsistent") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
    NSString *pwd = [NSString md5:self.oldPasswordView.textField.text];
    if ([pwd isEqualToString:KUser.currentAccount.password]) {
        [self changePassword];
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"PasswordWrong") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
    }
}

- (XXTextFieldView *)oldPasswordView {
    if (_oldPasswordView == nil) {
        _oldPasswordView = [[XXTextFieldView alloc] initWithFrame:CGRectMake(K375(32), kNavHeight + 10, kScreen_Width - K375(64), ItemHeight)];
        _oldPasswordView.placeholder = LocalizedString(@"OldPassword");
        _oldPasswordView.showLookBtn = YES;
        _oldPasswordView.textField.delegate = self;
        [_oldPasswordView.textField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _oldPasswordView;
}

- (XXTextFieldView *)passwordView {
    if (_passwordView == nil) {
        _passwordView = [[XXTextFieldView alloc] initWithFrame:CGRectMake(K375(32), CGRectGetMaxY(self.oldPasswordView.frame) + 30, kScreen_Width - K375(64), ItemHeight)];
        _passwordView.placeholder = LocalizedString(@"NewPassword");
        _passwordView.showLookBtn = YES;
        _passwordView.textField.delegate = self;
        [_passwordView.textField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordView;
}

- (XXTextFieldView *)okPasswordView {
    if (_okPasswordView == nil) {
        _okPasswordView = [[XXTextFieldView alloc] initWithFrame:CGRectMake(K375(32), CGRectGetMaxY(self.passwordView.frame) + 30, kScreen_Width - K375(64), ItemHeight)];
        _okPasswordView.placeholder = LocalizedString(@"ConfirmNewPassword");
        _okPasswordView.showLookBtn = YES;
        _okPasswordView.textField.delegate = self;
        [_okPasswordView.textField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _okPasswordView;
}

- (XXButton *)okButton {
    if (_okButton == nil) {
        MJWeakSelf
        _okButton = [XXButton buttonWithFrame:CGRectMake(K375(32), CGRectGetMaxY(self.okPasswordView.frame) + 30, kScreen_Width - K375(64), 40) title:LocalizedString(@"Sure") font:kFontBold14 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf okButtonClick:button];
        }];
        
        _okButton.layer.cornerRadius = 3;
        _okButton.layer.masksToBounds = YES;
        _okButton.backgroundColor = kGray100;
        _okButton.enabled = NO;
    }
    return _okButton;
}

@end
