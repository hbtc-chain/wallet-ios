//
//  XXRepeatPasswordVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXRepeatPasswordVC.h"
#import "XXCreateWalletSuccessVC.h"
#import "Account.h"
#import "SecureData.h"

@interface XXRepeatPasswordVC ()

@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) XXLabel *stepTipLabel;
@property (nonatomic, strong) XXLabel *contentLabel;
@property (nonatomic, strong) XXLabel *nameLabel;
@property (nonatomic, strong) XXTextFieldView *textFieldView;
@property (nonatomic, strong) XXButton *createBtn;

@end

@implementation XXRepeatPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"CreateWallet");
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.stepTipLabel];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.textFieldView];
    [self.view addSubview:self.createBtn];
}

- (void)createAction {
    if (![self.textFieldView.textField.text isEqualToString:KUser.localPassword]) {
        [MBProgressHUD showErrorMessage:LocalizedString(@"TwoPasswordInconsistent")];
        return;
    }
    Account *account = [Account randomMnemonicAccount];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:account.privateKey forKey:@"privateKey"];
    [dic setObject:account.BHAddress forKey:@"BHAddress"];
    [dic setObject:KUser.localUserName forKey:@"userName"];
    [dic setObject:KUser.localPassword forKey:@"password"];
    [dic setObject:account.mnemonicPhrase forKey:@"mnemonicPhrase"];
    [KUser addAccount:dic];
    KUser.rootAccount = dic;
    XXCreateWalletSuccessVC *successVC = [[XXCreateWalletSuccessVC alloc] init];
    [self.navigationController pushViewController:successVC animated:YES];
}

- (void)textFiledValueChange:(UITextField *)textField {
    if (textField.text.length) {
        self.createBtn.enabled = YES;
        self.createBtn.backgroundColor = kBlue100;
    } else {
        self.createBtn.enabled = NO;
        self.createBtn.backgroundColor = kBtnNotEnableColor;
    }
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        CGFloat width = [NSString widthWithText:LocalizedString(@"RepeatPassword") font:kFontBold(26)];
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), kNavHeight, width, 40) text:LocalizedString(@"RepeatPassword") font:kFontBold(26) textColor:kDark100 alignment:NSTextAlignmentLeft];
    }
    return _tipLabel;
}

- (XXLabel *)stepTipLabel {
    if (!_stepTipLabel) {
        _stepTipLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.tipLabel.frame) + 5, kNavHeight + 15, kScreen_Width - K375(32) - self.tipLabel.width, 20) text:LocalizedString(@"Step3") font:kFont12 textColor:kDark50 alignment:NSTextAlignmentLeft];
    }
    return _stepTipLabel;
}

- (XXLabel *)contentLabel {
    if (!_contentLabel) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"SetPasswordTip") font:kFont(15) width:kScreen_Width - K375(32)];
        _contentLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipLabel.frame) + 10, kScreen_Width - K375(32), height) text:LocalizedString(@"SetPasswordTip") font:kFont(15) textColor:kTipColor alignment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.contentLabel.frame) + 6, kScreen_Width - K375(32), 40) text:LocalizedString(@"RepeatPassword") font:kFont15 textColor:kTipColor alignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (XXTextFieldView *)textFieldView {
    if (!_textFieldView) {
        _textFieldView = [[XXTextFieldView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.nameLabel.frame), kScreen_Width - K375(32), 48)];
        _textFieldView.textField.placeholder = LocalizedString(@"SetPasswordPlaceHolder");
        _textFieldView.textField.secureTextEntry = YES;
        [_textFieldView.textField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _textFieldView;
}

- (XXButton *)createBtn {
    if (!_createBtn) {
        MJWeakSelf
        _createBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.textFieldView.frame) + 24, kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"StartCreate") font:kFontBold18 titleColor:kWhite100 block:^(UIButton *button) {
            [weakSelf createAction];
        }];
        _createBtn.backgroundColor = kBtnNotEnableColor;
        _createBtn.layer.cornerRadius = kBtnBorderRadius;
        _createBtn.layer.masksToBounds = YES;
        _createBtn.enabled = NO;
    }
    return _createBtn;
}

@end
