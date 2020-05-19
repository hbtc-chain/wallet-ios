//
//  XXLoginVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/19.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXLoginVC.h"
#import "XXTabBarController.h"
#import "XXAccountFooterView.h"
#import "XXImportWalletVC.h"
#import "XXAddressView.h"


@interface XXLoginVC ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) XXLabel *userNameLabel;
@property (nonatomic, strong) XXLabel *addressLabel;
@property (nonatomic, strong) XXLabel *walletNameLabel;
@property (nonatomic, strong) XXAddressView *addressView;
@property (nonatomic, strong) XXTextFieldView *textFieldView;
@property (nonatomic, strong) XXButton *okBtn;
@property (nonatomic, strong) XXButton *importWalletBtn;
@property (nonatomic, strong) XXButton *forgetPasswordBtn;
@property (nonatomic, strong) XXAccountFooterView *footerView;

@end

@implementation XXLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"Verify");
    self.leftButton.hidden = YES;
    [self.view addSubview:self.icon];
    [self.view addSubview:self.userNameLabel];
    [self.view addSubview:self.addressView];
    [self.view addSubview:self.walletNameLabel];
    [self.view addSubview:self.textFieldView];
    [self.view addSubview:self.okBtn];
    [self.view addSubview:self.importWalletBtn];
    [self.view addSubview:self.forgetPasswordBtn];
    [self.view addSubview:self.footerView];
}

- (void)okAction {
    NSString *inputPws = self.textFieldView.textField.text;
    NSString *pws = KUser.currentAccount.password;
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
        self.okBtn.backgroundColor = kPrimaryMain;
    } else {
        self.okBtn.enabled = NO;
        self.okBtn.backgroundColor = kGray100;
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
        _userNameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.icon.frame) + 8, kScreen_Width - K375(32), 18) text:KUser.currentAccount.userName font:kFont13 textColor:kGray500 alignment:NSTextAlignmentCenter];
    }
    return _userNameLabel;
}

- (XXAddressView *)addressView {
    if (!_addressView) {
        MJWeakSelf
        _addressView = [[XXAddressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userNameLabel.frame)+16, kScreen_Width, 18)];
        _addressView.sureBtnBlock = ^{
            weakSelf.userNameLabel.text = KUser.currentAccount.userName;
        };
    }
    return _addressView;
}

- (XXLabel *)walletNameLabel {
    if (!_walletNameLabel) {
        _walletNameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.addressView.frame) + 40, kScreen_Width - K375(32), 40) text:LocalizedString(@"WalletPassword") font:kFont15 textColor:kGray500 alignment:NSTextAlignmentLeft];
    }
    return _walletNameLabel;
}

- (XXTextFieldView *)textFieldView {
    if (!_textFieldView) {
        _textFieldView = [[XXTextFieldView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.walletNameLabel.frame), kScreen_Width - K375(32), 48)];
        _textFieldView.placeholder = LocalizedString(@"PleaseEnterPassword");
        _textFieldView.textField.secureTextEntry = YES;
        [_textFieldView.textField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFieldView;
}

- (XXButton *)okBtn {
    if (!_okBtn) {
        MJWeakSelf
        _okBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.textFieldView.frame) + 24, kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"Sure") font:kFontBold18 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf okAction];
        }];
        _okBtn.backgroundColor = kGray100;
        _okBtn.layer.cornerRadius = kBtnBorderRadius;
        _okBtn.layer.masksToBounds = YES;
        _okBtn.enabled = NO;
    }
    return _okBtn;
}

- (XXButton *)forgetPasswordBtn {
    if (!_forgetPasswordBtn) {
        MJWeakSelf
        _forgetPasswordBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.okBtn.frame) + 24, 100, 24) title:LocalizedString(@"ForgetPassword") font:kFont15 titleColor:kPrimaryMain block:^(UIButton *button) {
            XXImportWalletVC *importVC = [[XXImportWalletVC alloc] init];
            [weakSelf.navigationController pushViewController:importVC animated:YES];
        }];
        _forgetPasswordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _forgetPasswordBtn;
}

- (XXAccountFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[XXAccountFooterView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 100, kScreen_Width, 100)];
    }
    return _footerView;
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
