//
//  XXImportKeystoreSetName.m
//  Bluehelix
//
//  Created by BHEX on 2020/5/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXImportKeystoreSetName.h"
#import "XXServiceAgreementVC.h"
#import "XXTabBarController.h"

@interface XXImportKeystoreSetName ()<UITextViewDelegate>

@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) XXLabel *stepTipLabel;
@property (nonatomic, strong) XXLabel *contentLabel;
@property (nonatomic, strong) XXLabel *nameLabel;
@property (nonatomic, strong) XXTextFieldView *textFieldView;
@property (nonatomic, strong) XXButton *isAgreeButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) XXButton *createBtn;
@end

@implementation XXImportKeystoreSetName

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"ImportKeystore");
    KUser.agreeService = NO;
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.stepTipLabel];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.textFieldView];
    [self.view addSubview:self.isAgreeButton];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.createBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isAgreeButton.selected = KUser.agreeService;
    [self reloadCreateBtn];
}

- (void)nextStepAction {
    if (self.textFieldView.textField.text.length > 20) {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"AccountNameRuleAlert") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
    [self createAccount];
}

- (void)createAccount {
    self.account.userName = self.textFieldView.textField.text;
    self.account.mnemonicPhrase = @"";
    self.account.backupFlag = YES; //keystore导入不需要备份助记词
    self.account.symbols = [NSString stringWithFormat:@"btc,eth,usdt,%@",kMainToken];
    [[XXSqliteManager sharedSqlite] insertAccount:self.account];
    KUser.address = self.account.address;
    Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"ImportSuccess") duration:kAlertDuration completion:^{
        KWindow.rootViewController = [[XXTabBarController alloc] init];
    }];
    [alert showAlert];
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

- (void)textFiledValueChange:(UITextField *)textField {
    if (textField.text.length) {
        self.createBtn.enabled = YES;
        self.createBtn.backgroundColor = kPrimaryMain;
    } else {
        self.createBtn.enabled = NO;
        self.createBtn.backgroundColor = kGray100;
    }
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        CGFloat width = [NSString widthWithText:LocalizedString(@"SetName") font:kFontBold(26)];
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), kNavHeight, width, 40) text:LocalizedString(@"SetName") font:kFontBold(26) textColor:kGray900 alignment:NSTextAlignmentLeft];
    }
    return _tipLabel;
}

- (XXLabel *)contentLabel {
    if (!_contentLabel) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"KeystoreSetNameTip") font:kFont(15) width:kScreen_Width - K375(32)];
        _contentLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipLabel.frame) + 10, kScreen_Width - K375(32), height) text:LocalizedString(@"KeystoreSetNameTip") font:kFont(15) textColor:kGray500 alignment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.contentLabel.frame) + 24, kScreen_Width - K375(32), 40) text:LocalizedString(@"WalletName") font:kFont15 textColor:kGray700 alignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (XXTextFieldView *)textFieldView {
    if (!_textFieldView) {
        _textFieldView = [[XXTextFieldView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.nameLabel.frame), kScreen_Width - K375(32), 48)];
        _textFieldView.placeholder = LocalizedString(@"SetNamePlaceHolder");
        [_textFieldView.textField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _textFieldView;
}

- (XXButton *)isAgreeButton {
    if (_isAgreeButton == nil) {
        MJWeakSelf
        _isAgreeButton = [XXButton buttonWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.textFieldView.frame) + 24, 30, 24) block:^(UIButton *button) {
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
        serviceVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:serviceVC animated:YES completion:nil];
    }
    return NO;
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.isAgreeButton.frame) - 5, self.isAgreeButton.top, K375(280), 30)];
        _textView.backgroundColor = kWhiteColor;
        _textView.font = kFont12;
        _textView.textColor = kGray700;
        _textView.delegate  = self;
        _textView.editable  = NO;
        _textView.scrollEnabled = NO;
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.contentOffset = CGPointMake(0, 7);
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
        _createBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.isAgreeButton.frame) + 24, kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"Import") font:kFontBold18 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
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
