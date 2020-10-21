//
//  XXImportKeystoreVC.m
//  Bluehelix
//
//  Created by BHEX on 2020/5/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXImportKeystoreVC.h"
#import "XXCreateWalletVC.h"
#import "SecureData.h"
#import "Account.h"
#import "XXImportKeystoreSetName.h"
#import "AESCrypt.h"
@interface XXImportKeystoreVC () <UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) XXLabel *nameLabel;
@property (nonatomic, strong) XXTextFieldView *textFieldView;
@property (nonatomic, strong) XXButton *createBtn;
@property (nonatomic, strong) UIView *textBackView;
@end

@implementation XXImportKeystoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"ImportKeystore");
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.textBackView];
    [self.textBackView addSubview:self.textView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.textFieldView];
    [self.view addSubview:self.createBtn];
}

- (void)nextStepAction {
    [MBProgressHUD showActivityMessageInView:nil];
    [Account decryptSecretStorageJSON:self.textView.text password:self.textFieldView.textField.text callback:^(Account *account, NSError *NSError) {
        [MBProgressHUD hideHUD];
        if (account) {
            //判断是否重复导入
//            if (KUser.accounts) {
//                for (XXAccountModel *model in KUser.accounts) {
//                    if ([model.address isEqualToString:account.BHAddress]) {
//                        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"KeystoreRepetition") duration:kAlertDuration completion:^{
//                        }];
//                        [alert showAlert];
//                        return;
//                    }
//                }
//            }
            [self pushNameVC:account];
        } else {
            NSString *errorMsg = NSError.userInfo[@"reason"];
            if (!IsEmpty(errorMsg)) {
                Alert *alert = [[Alert alloc] initWithTitle:errorMsg duration:kAlertDuration completion:^{
                }];
                [alert showAlert];
            } else {
                Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"KeystoreOutOfOrder") duration:kAlertDuration completion:^{
                }];
                [alert showAlert];
            }
        }
    }];
}

- (void)pushNameVC:(Account *)account {
    XXAccountModel *model = [[XXAccountModel alloc] init];
    model.privateKey = [AESCrypt encrypt:account.privateKeyString password:self.textFieldView.textField.text];
    model.publicKey = account.pubKey;
    model.address = account.BHAddress;
    model.password = [NSString md5:self.textFieldView.textField.text];
    model.keystore = self.textView.text;
    
    XXImportKeystoreSetName *nameVC = [[XXImportKeystoreSetName alloc] init];
    nameVC.account = model;
    [self.navigationController pushViewController:nameVC animated:YES];
}


- (void)textViewDidChange:(UITextView *)textView {
    if (self.textFieldView.textField.text.length && self.textView.text.length) {
        self.createBtn.enabled = YES;
        self.createBtn.backgroundColor = kPrimaryMain;
    } else {
        self.createBtn.enabled = NO;
        self.createBtn.backgroundColor = kGray100;
    }
}

- (void)textFiledValueChange:(UITextField *)textField {
    if (self.textFieldView.textField.text.length && self.textView.text.length) {
        self.createBtn.enabled = YES;
        self.createBtn.backgroundColor = kPrimaryMain;
    } else {
        self.createBtn.enabled = NO;
        self.createBtn.backgroundColor = kGray100;
    }
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"ImportKeystoreTip") font:kFont(15) width:kScreen_Width - K375(32)];
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), kNavHeight, kScreen_Width - K375(32), height) text:LocalizedString(@"ImportKeystoreTip") font:kFont(15) textColor:kGray500 alignment:NSTextAlignmentLeft];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UIView *)textBackView {
    if (!_textBackView) {
        _textBackView = [[UIView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipLabel.frame) + 16, kScreen_Width - K375(32), K375(144))];
        _textBackView.backgroundColor = kGray50;
        _textBackView.layer.cornerRadius = kBtnBorderRadius;
        _textBackView.layer.masksToBounds = YES;
    }
    return _textBackView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.textBackView.bounds];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = kFont(13);
        _textView.delegate = self;
        _textView.textColor = kGray900;
    }
    return _textView;
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.textBackView.frame) + 24, kScreen_Width - K375(32), 40) text:LocalizedString(@"WalletPassword") font:kFont15 textColor:kGray700 alignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (XXTextFieldView *)textFieldView {
    if (!_textFieldView) {
        _textFieldView = [[XXTextFieldView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.nameLabel.frame), kScreen_Width - K375(32), 48)];
        _textFieldView.placeholder = LocalizedString(@"SetPasswordPlaceHolder");
        _textFieldView.showLookBtn = YES;
        _textFieldView.textField.delegate = self;
        [_textFieldView.textField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFieldView;
}

- (XXButton *)createBtn {
    if (!_createBtn) {
        MJWeakSelf
        _createBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.textFieldView.frame) + 24, kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"NextStep") font:kFontBold18 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf nextStepAction];
        }];
        _createBtn.backgroundColor = kGray100;
        _createBtn.layer.cornerRadius = kBtnBorderRadius;
        _createBtn.layer.masksToBounds = YES;
        _createBtn.enabled = NO;
    }
    return _createBtn;
}

@end
