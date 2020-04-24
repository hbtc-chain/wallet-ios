//
//  XXRepeatPasswordVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXRepeatPasswordVC.h"
#import "XXCreateWalletSuccessVC.h"
#import "Account.h"
#import "SecureData.h"
#import "AESCrypt.h"
#import "XXServiceAgreementVC.h"
#import "XYHNumbersLabel.h"


@interface XXRepeatPasswordVC () <UITextViewDelegate>

@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) XXLabel *stepTipLabel;
@property (nonatomic, strong) XYHNumbersLabel *contentLabel;
@property (nonatomic, strong) XXLabel *nameLabel;
@property (nonatomic, strong) XXTextFieldView *textFieldView;
@property (nonatomic, strong) XXLabel *charCountLabel;
@property (nonatomic, strong) XXButton *createBtn;
@property (strong, nonatomic) XXButton *isAgreeButton;
@property (strong, nonatomic) UITextView *textView;
@end

@implementation XXRepeatPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    KUser.agreeService = NO;
    [self buildUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isAgreeButton.selected = KUser.agreeService;
    [self reloadCreateBtn];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"CreateWallet");
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.stepTipLabel];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.textFieldView];
    [self.view addSubview:self.charCountLabel];
    [self.view addSubview:self.isAgreeButton];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.createBtn];
}

- (void)createAction {
    if (![self.textFieldView.textField.text isEqualToString:KUser.localPassword]) {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"TwoPasswordInconsistent") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
    Account *account;
    NSLog(@"%@   %@",KUser.localPrivateKey,KUser.localPhraseString);
    if (!IsEmpty(KUser.localPhraseString)) { //通过助记词导入创建
        account = [Account accountWithMnemonicPhrase:KUser.localPhraseString];
    } else if (!IsEmpty(KUser.localPrivateKey)) { //通过私钥导入创建
        SecureData * data = [SecureData secureDataWithHexString:KUser.localPrivateKey];
        account = [Account accountWithPrivateKey:data.data];
    } else {
        account = [Account randomMnemonicAccount];
    }
    XXAccountModel *model = [[XXAccountModel alloc] init];
    model.privateKey = [AESCrypt encrypt:account.privateKeyString password:KUser.localPassword];
    model.publicKey = account.pubKey;
    model.address = account.BHAddress;
    model.userName = KUser.localUserName;
    model.password = [NSString md5:KUser.localPassword];
    if (account.mnemonicPhrase && IsEmpty(KUser.localPhraseString)) { //如果是通过助记词导入的 不需要备份和保留助记词
        NSString *mnemonicPhrase = [AESCrypt encrypt:account.mnemonicPhrase password:KUser.localPassword];
        model.mnemonicPhrase = mnemonicPhrase;
    }
    model.backupFlag = IsEmpty(KUser.localPhraseString) ? NO : YES; //如果是通过助记词导入的 不需要备份和保留助记词
    model.symbols = [NSString stringWithFormat:@"btc,eth,usdt,%@",kMainToken];
    [[XXSqliteManager sharedSqlite] insertAccount:model];
    
    KUser.address = model.address;
    
    XXCreateWalletSuccessVC *successVC = [[XXCreateWalletSuccessVC alloc] init];
    successVC.text = KUser.localPassword;
    [self.navigationController pushViewController:successVC animated:YES];
    KUser.localPassword = @"";
    KUser.localUserName = @"";
    KUser.localPhraseString = @"";
}

- (void)textFiledValueChange:(UITextField *)textField {
    [self reloadCreateBtn];
    if (textField.text.length) {
        self.charCountLabel.text = NSLocalizedFormatString(LocalizedString(@"CharCount"),[NSString stringWithFormat:@"%lu",(unsigned long)textField.text.length]);
    } else {
        self.charCountLabel.text = @"";
    }
}

- (void)reloadCreateBtn {
    if (self.textFieldView.textField.text.length && KUser.agreeService) {
        self.createBtn.enabled = YES;
        self.createBtn.backgroundColor = kPrimaryMain;
    } else {
        self.createBtn.enabled = NO;
        self.createBtn.backgroundColor = kGray100;
    }
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        CGFloat width = [NSString widthWithText:LocalizedString(@"RepeatPassword") font:kFontBold(26)];
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), kNavHeight, width, 40) text:LocalizedString(@"RepeatPassword") font:kFontBold(26) textColor:kGray900 alignment:NSTextAlignmentLeft];
    }
    return _tipLabel;
}

- (XXLabel *)stepTipLabel {
    if (!_stepTipLabel) {
        _stepTipLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.tipLabel.frame) + 5, kNavHeight + 15, kScreen_Width - K375(32) - self.tipLabel.width, 20) text:LocalizedString(@"Step3") font:kFont12 textColor:kGray500 alignment:NSTextAlignmentLeft];
    }
    return _stepTipLabel;
}

- (XYHNumbersLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipLabel.frame) + 10, kScreen_Width - K375(32), 0) font:kFont(15)];
        _contentLabel.textColor = kGray500;
        [_contentLabel setText:LocalizedString(@"SetPasswordTip") alignment:NSTextAlignmentLeft];
    }
    return _contentLabel;
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.contentLabel.frame) + 6, kScreen_Width - K375(32), 40) text:LocalizedString(@"RepeatPassword") font:kFont15 textColor:kGray500 alignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (XXTextFieldView *)textFieldView {
    if (!_textFieldView) {
        _textFieldView = [[XXTextFieldView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.nameLabel.frame), kScreen_Width - K375(32), 48)];
        _textFieldView.placeholder = LocalizedString(@"SetPasswordPlaceHolder");
        _textFieldView.showLookBtn = YES;
        [_textFieldView.textField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFieldView;
}

- (XXLabel *)charCountLabel {
    if (!_charCountLabel) {
        _charCountLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.textFieldView.frame)+3, kScreen_Width - K375(32), 20) text:@"" font:kFont(15) textColor:kGray500 alignment:NSTextAlignmentRight];
    }
    return _charCountLabel;
}

- (XXButton *)isAgreeButton {
    if (_isAgreeButton == nil) {
        MJWeakSelf
        _isAgreeButton = [XXButton buttonWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.charCountLabel.frame), 30, 30) block:^(UIButton *button) {
            weakSelf.isAgreeButton.selected = !weakSelf.isAgreeButton.selected;
            KUser.agreeService = weakSelf.isAgreeButton.selected;
            if (KUser.agreeService && weakSelf.textFieldView.textField.text.length) {
                weakSelf.createBtn.enabled = YES;
                weakSelf.createBtn.backgroundColor = kPrimaryMain;
            } else {
                weakSelf.createBtn.enabled = NO;
                weakSelf.createBtn.backgroundColor = kGray100;
            }
        }];
        _isAgreeButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        _isAgreeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_isAgreeButton setImage:[UIImage subTextImageName:@"unSelected"] forState:UIControlStateNormal];
        [_isAgreeButton setImage:[UIImage mainImageName:@"selected"] forState:UIControlStateSelected];
        _isAgreeButton.selected = KUser.agreeService;
    }
    return _isAgreeButton;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"fwxy"]) {
        XXServiceAgreementVC *serviceVC = [[XXServiceAgreementVC alloc] init];
//        XXNavigationController *nav = [[XXNavigationController alloc] initWithRootViewController:serviceVC];
        serviceVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:serviceVC animated:YES completion:nil];
    }
    return NO;
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.isAgreeButton.frame) - 5, self.isAgreeButton.top, K375(280), self.isAgreeButton.height)];
        _textView.backgroundColor = kWhiteColor;
        _textView.font = kFont12;
        _textView.textColor = kGray700;
        _textView.delegate  = self;
        _textView.editable  = NO;
        _textView.scrollEnabled = NO;
        _textView.textAlignment = NSTextAlignmentLeft;
        NSString *fwxy = LocalizedString(@"ServiceAgreement");
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", LocalizedString(@"IAgreeTo"), fwxy]];
        [attributedString addAttribute:NSLinkAttributeName
                                 value:@"fwxy://"
                                 range:[[attributedString string] rangeOfString:fwxy]];
        [attributedString addAttribute:NSFontAttributeName value:kFont14 range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:kGray900 range:NSMakeRange(0, attributedString.length)];
        _textView.attributedText = attributedString;
        _textView.linkTextAttributes = @{NSForegroundColorAttributeName:kPrimaryMain};
    }
    return _textView;
}

- (XXButton *)createBtn {
    if (!_createBtn) {
        MJWeakSelf
        _createBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.textView.frame) + 24, kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"StartCreate") font:kFontBold18 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf createAction];
        }];
        _createBtn.backgroundColor = kGray100;
        _createBtn.layer.cornerRadius = kBtnBorderRadius;
        _createBtn.layer.masksToBounds = YES;
        _createBtn.enabled = NO;
    }
    return _createBtn;
}

@end
