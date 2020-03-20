//
//  XXLoginVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/19.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXLoginVC.h"
#import "XXTabBarController.h"

@interface XXLoginVC ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) XXLabel *userNameLabel;
@property (nonatomic, strong) XXLabel *addressLabel;
@property (nonatomic, strong) XXLabel *walletNameLabel;
@property (nonatomic, strong) XXTextFieldView *textFieldView;
@property (nonatomic, strong) XXButton *okBtn;
@property (nonatomic, strong) XXButton *importWalletBtn;
@property (nonatomic, strong) XXButton *forgetPasswordBtn;

@end

@implementation XXLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"验证");
    [self.view addSubview:self.icon];
    [self.view addSubview:self.userNameLabel];
    [self.view addSubview:self.walletNameLabel];
    [self.view addSubview:self.textFieldView];
    [self.view addSubview:self.okBtn];
    [self.view addSubview:self.importWalletBtn];
    [self.view addSubview:self.forgetPasswordBtn];
}

- (void)okAction {
    NSString *inputPws = self.textFieldView.textField.text;
    NSString *pws = KUser.rootAccount[@"password"];
    if ([[NSString md5:inputPws] isEqualToString: pws]) {
        KWindow.rootViewController = [[XXTabBarController alloc] init];
    } else {
    Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"PasswordWrong") duration:kAlertDuration completion:^{
           }];
    [alert showAlert];
    }
}

- (void)textFieldValueChange:(UITextField *)textField {
    if (self.textFieldView.textField.text.length) {
        self.okBtn.enabled = YES;
        self.okBtn.backgroundColor = kBlue100;
    } else {
        self.okBtn.enabled = NO;
        self.okBtn.backgroundColor = kBtnNotEnableColor;
    }
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width/2 - K375(56)/2, 112, K375(56), K375(56))];
        _icon.image = [UIImage imageNamed:@"headImage"];
    }
    return _icon;
}

- (XXLabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.icon.frame) + 6, kScreen_Width - K375(32), 40) text:KUser.rootAccount[@"userName"] font:kFont15 textColor:kTipColor alignment:NSTextAlignmentCenter];
    }
    return _userNameLabel;
}

- (XXLabel *)walletNameLabel {
    if (!_walletNameLabel) {
        _walletNameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.userNameLabel.frame) + 6, kScreen_Width - K375(32), 40) text:LocalizedString(@"WalletPassword") font:kFont15 textColor:kTipColor alignment:NSTextAlignmentLeft];
    }
    return _walletNameLabel;
}

- (XXTextFieldView *)textFieldView {
    if (!_textFieldView) {
        _textFieldView = [[XXTextFieldView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.walletNameLabel.frame), kScreen_Width - K375(32), 48)];
        _textFieldView.textField.placeholder = LocalizedString(@"PleaseEnterPassword");
        _textFieldView.textField.secureTextEntry = YES;
        [_textFieldView.textField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFieldView;
}

- (XXButton *)okBtn {
    if (!_okBtn) {
        MJWeakSelf
        _okBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.textFieldView.frame) + 24, kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"Sure") font:kFontBold18 titleColor:kWhite100 block:^(UIButton *button) {
            [weakSelf okAction];
        }];
        _okBtn.backgroundColor = kBtnNotEnableColor;
        _okBtn.layer.cornerRadius = kBtnBorderRadius;
        _okBtn.layer.masksToBounds = YES;
        _okBtn.enabled = NO;
    }
    return _okBtn;
}

- (XXButton *)importWalletBtn {
    if (!_importWalletBtn) {
        _importWalletBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.okBtn.frame) + 24, 100, 24) title:LocalizedString(@"ImportWallet") font:kFont15 titleColor:kDark50 block:^(UIButton *button) {
            
        }];
        _importWalletBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _importWalletBtn;
}

- (XXButton *)forgetPasswordBtn {
    if (!_forgetPasswordBtn) {
        _forgetPasswordBtn = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - K375(16) - 100, CGRectGetMaxY(self.okBtn.frame) + 24, 100, 24) title:LocalizedString(@"ForgetPassword") font:kFont15 titleColor:kBlue100 block:^(UIButton *button) {
            
        }];
        _forgetPasswordBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _forgetPasswordBtn;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
