//
//  XXImportWalletVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXImportWalletVC.h"
#import "XXImportMnemonicPhraseVC.h"
#import "XXImportPrivateKeyVC.h"

@interface XXImportWalletVC ()

@property (nonatomic, strong) XXButton *mnemonicPhraseBtn;
@property (nonatomic, strong) XXButton *keyStoreBtn;
@property (nonatomic, strong) XXButton *securityBtn;

@end

@implementation XXImportWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"ImportWallet");
    [self.view addSubview:self.mnemonicPhraseBtn];
    [self.view addSubview:self.keyStoreBtn];
    [self.view addSubview:self.securityBtn];
}

- (XXButton *)mnemonicPhraseBtn {
    if (!_mnemonicPhraseBtn) {
        MJWeakSelf
        _mnemonicPhraseBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), K375(152), kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"ImportMnemonicPhrase") font:kFont(17) titleColor:kBlue100 block:^(UIButton *button) {
            XXImportMnemonicPhraseVC *importVC = [[XXImportMnemonicPhraseVC alloc] init];
            [weakSelf.navigationController pushViewController:importVC animated:YES];
        }];
        _mnemonicPhraseBtn.backgroundColor = kWhite100;
        _mnemonicPhraseBtn.layer.cornerRadius = kBtnBorderRadius;
        _mnemonicPhraseBtn.layer.masksToBounds = YES;
        _mnemonicPhraseBtn.layer.borderColor = [kBlue100 CGColor];
        _mnemonicPhraseBtn.layer.borderWidth = 1;
    }
    return _mnemonicPhraseBtn;
}

- (XXButton *)keyStoreBtn {
    if (!_keyStoreBtn) {
        MJWeakSelf
        _keyStoreBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.mnemonicPhraseBtn.frame) + K375(24), kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"ImportKeyStore") font:kFont(17) titleColor:kBlue100 block:^(UIButton *button) {
//            XXImportWalletVC *importVC = [[XXImportWalletVC alloc] init];
//            [weakSelf.navigationController pushViewController:importVC animated:YES];
        }];
        _keyStoreBtn.backgroundColor = kWhite100;
        _keyStoreBtn.layer.cornerRadius = kBtnBorderRadius;
        _keyStoreBtn.layer.masksToBounds = YES;
        _keyStoreBtn.layer.borderColor = [kBlue100 CGColor];
        _keyStoreBtn.layer.borderWidth = 1;
    }
    return _keyStoreBtn;
}

- (XXButton *)securityBtn {
    if (!_securityBtn) {
        MJWeakSelf
        _securityBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.keyStoreBtn.frame) + K375(24), kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"ImportSecurity") font:kFont(17) titleColor:kBlue100 block:^(UIButton *button) {
            XXImportPrivateKeyVC *importVC = [[XXImportPrivateKeyVC alloc] init];
            [weakSelf.navigationController pushViewController:importVC animated:YES];
        }];
        _securityBtn.backgroundColor = kWhite100;
        _securityBtn.layer.cornerRadius = kBtnBorderRadius;
        _securityBtn.layer.masksToBounds = YES;
        _securityBtn.layer.borderColor = [kBlue100 CGColor];
        _securityBtn.layer.borderWidth = 1;
    }
    return _securityBtn;
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
