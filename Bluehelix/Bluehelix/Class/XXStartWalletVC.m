//
//  XXStartWalletVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/09.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXStartWalletVC.h"
#import "XXBackupMnemonicPhraseVC.h"
#import "XXCreateWalletVC.h"

@interface XXStartWalletVC ()

@end

@implementation XXStartWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI {
    self.navView.hidden = YES;
    self.view.backgroundColor = kWhite100;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width/2 - K375(224)/2, K375(216), K375(224), K375(71))];
    logoImageView.image = [UIImage imageNamed:@"startLogo"];
    [self.view addSubview:logoImageView];
    
    MJWeakSelf
    XXButton *createWalletBtn = [XXButton buttonWithFrame:CGRectMake(K375(15), kScreen_Height - 144, kScreen_Width - K375(30), 44) title:LocalizedString(@"CreateWallet") font:kFontBold18 titleColor:kWhite100 block:^(UIButton *button) {
        XXCreateWalletVC *createVC = [[XXCreateWalletVC alloc] init];
        [weakSelf.navigationController pushViewController:createVC animated:YES];
    }];
    createWalletBtn.backgroundColor = kBlue100;
    createWalletBtn.layer.cornerRadius = 4;
    createWalletBtn.layer.masksToBounds = YES;
    [self.view addSubview:createWalletBtn];
    
    XXButton *importWalletBtn = [XXButton buttonWithFrame:CGRectMake(K375(15), kScreen_Height - 84, kScreen_Width - K375(30), 44) title:LocalizedString(@"ImportWallet") font:kFontBold18 titleColor:kBlue100 block:^(UIButton *button) {
        XXBackupMnemonicPhraseVC *backupVC = [[XXBackupMnemonicPhraseVC alloc] init];
        [weakSelf.navigationController pushViewController:backupVC animated:YES];
    }];
    importWalletBtn.backgroundColor = kWhite100;
    importWalletBtn.layer.cornerRadius = 4;
    importWalletBtn.layer.masksToBounds = YES;
    [self.view addSubview:importWalletBtn];
}

@end
