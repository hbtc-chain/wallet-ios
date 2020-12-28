//
//  XXAddWalletVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/3.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAddWalletVC.h"
#import "XXImportMnemonicWordsVC.h"
#import "XXImportPrivateKeyVC.h"
#import "XXImportWayView.h"
#import "XXImportKeystoreVC.h"
#import "XXCreateWalletVC.h"

@interface XXAddWalletVC ()

@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) XXImportWayView *mnemonicPhraseBtn;
@property (nonatomic, strong) XXImportWayView *keystoreBtn;
@property (nonatomic, strong) XXImportWayView *securityBtn;
@property (nonatomic, strong) XXLabel *tipLabel1;
@property (nonatomic, strong) XXImportWayView *createBtn;
@end

@implementation XXAddWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"AddWallet");
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.mnemonicPhraseBtn];
    [self.view addSubview:self.keystoreBtn];
    [self.view addSubview:self.securityBtn];
    [self.view addSubview:self.tipLabel1];
    [self.view addSubview:self.createBtn];
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), kNavHeight + 20, kScreen_Width - K375(48), 24) text:LocalizedString(@"Import") font:kFontBold(20) textColor:kGray900];
        _tipLabel.numberOfLines = 0;
        [_tipLabel sizeToFit];
    }
    return _tipLabel;
}

- (XXImportWayView *)mnemonicPhraseBtn {
    if (!_mnemonicPhraseBtn) {
        MJWeakSelf
        _mnemonicPhraseBtn = [[XXImportWayView alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.tipLabel.frame) + 16, kScreen_Width - K375(48), 88) title:LocalizedString(@"ImportMnemonicPhrase") imageName:@"importPhrase"];
        _mnemonicPhraseBtn.clickBlock = ^{
            XXImportMnemonicWordsVC *importVC = [[XXImportMnemonicWordsVC alloc] init];
            [weakSelf.navigationController pushViewController:importVC animated:YES];
        };
        _mnemonicPhraseBtn.backgroundColor = kWhiteColor;
        _mnemonicPhraseBtn.layer.cornerRadius = kBtnBorderRadius;
        _mnemonicPhraseBtn.layer.masksToBounds = YES;
        _mnemonicPhraseBtn.layer.borderColor = [kPrimaryMain CGColor];
        _mnemonicPhraseBtn.layer.borderWidth = 2;
    }
    return _mnemonicPhraseBtn;
}

- (XXImportWayView *)keystoreBtn {
    if (!_keystoreBtn) {
        MJWeakSelf
        _keystoreBtn = [[XXImportWayView alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.mnemonicPhraseBtn.frame) + K375(24), kScreen_Width - K375(48), 88) title:LocalizedString(@"ImportKeystore") imageName:@"importKeystore"];
        _keystoreBtn.clickBlock = ^{
            XXImportKeystoreVC *importVC = [[XXImportKeystoreVC alloc] init];
            [weakSelf.navigationController pushViewController:importVC animated:YES];
        };
        _keystoreBtn.backgroundColor = kWhiteColor;
        _keystoreBtn.layer.cornerRadius = kBtnBorderRadius;
        _keystoreBtn.layer.masksToBounds = YES;
        _keystoreBtn.layer.borderColor = [kPrimaryMain CGColor];
        _keystoreBtn.layer.borderWidth = 2;
    }
    return _keystoreBtn;
}

- (XXImportWayView *)securityBtn {
    if (!_securityBtn) {
        MJWeakSelf
        _securityBtn = [[XXImportWayView alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.keystoreBtn.frame) + K375(24), kScreen_Width - K375(48), 88) title:LocalizedString(@"ImportSecurity") imageName:@"importKey"];
        _securityBtn.clickBlock = ^{
            XXImportPrivateKeyVC *importVC = [[XXImportPrivateKeyVC alloc] init];
            [weakSelf.navigationController pushViewController:importVC animated:YES];
        };
        _securityBtn.backgroundColor = kWhiteColor;
        _securityBtn.layer.cornerRadius = kBtnBorderRadius;
        _securityBtn.layer.masksToBounds = YES;
        _securityBtn.layer.borderColor = [kPrimaryMain CGColor];
        _securityBtn.layer.borderWidth = 2;
    }
    return _securityBtn;
}

- (XXLabel *)tipLabel1 {
    if (!_tipLabel1) {
        _tipLabel1 = [XXLabel labelWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.securityBtn.frame) + K375(40), kScreen_Width - K375(48), 24) text:LocalizedString(@"ValidatorNewCreate") font:kFontBold(20) textColor:kGray900];
    }
    return _tipLabel1;
}

- (XXImportWayView *)createBtn {
    if (!_createBtn) {
        MJWeakSelf
        _createBtn = [[XXImportWayView alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.tipLabel1.frame) + 16, kScreen_Width - K375(48), 88) title:LocalizedString(@"CreateWalletAccount") imageName:@"createWallet"];
        _createBtn.clickBlock = ^{
            XXCreateWalletVC *createVC = [[XXCreateWalletVC alloc] init];
            [weakSelf.navigationController pushViewController:createVC animated:YES];
        };
        _createBtn.backgroundColor = kWhiteColor;
        _createBtn.layer.cornerRadius = kBtnBorderRadius;
        _createBtn.layer.masksToBounds = YES;
        _createBtn.layer.borderColor = [kPrimaryMain CGColor];
        _createBtn.layer.borderWidth = 2;
    }
    return _createBtn;
}
@end
