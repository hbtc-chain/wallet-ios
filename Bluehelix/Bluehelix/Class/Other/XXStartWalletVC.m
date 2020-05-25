//
//  XXStartWalletVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/09.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXStartWalletVC.h"
#import "XXImportWalletVC.h"
#import "XXCreateWalletVC.h"

@interface XXStartWalletVC ()

@property (nonatomic, strong) XXButton *createWalletBtn;
@property (nonatomic, strong) XXButton *importWalletBtn;

@end

@implementation XXStartWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    KUser.localPhraseString = @"";
    [self buildUI];
}

- (void)buildUI {
    self.navView.hidden = YES;
    self.view.backgroundColor = kWhiteColor;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width/2 - K375(240)/2, K375(192), K375(240), K375(140))];
    logoImageView.image = kIsNight ? [UIImage imageNamed:@"startLogo_Night"] : [UIImage imageNamed:@"startLogo"];
    [self.view addSubview:logoImageView];
    [self.view addSubview:self.createWalletBtn];
    [self.view addSubview:self.importWalletBtn];
}

- (XXButton *)createWalletBtn {
    if (!_createWalletBtn) {
        MJWeakSelf
        _createWalletBtn = [XXButton buttonWithFrame:CGRectMake(K375(15), kScreen_Height - 144, kScreen_Width - K375(30), kBtnHeight) title:LocalizedString(@"CreateWallet") font:kFontBold18 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            XXCreateWalletVC *createVC = [[XXCreateWalletVC alloc] init];
            [weakSelf.navigationController pushViewController:createVC animated:YES];
        }];
        _createWalletBtn.backgroundColor = kPrimaryMain;
        _createWalletBtn.layer.cornerRadius = kBtnBorderRadius;
        _createWalletBtn.layer.masksToBounds = YES;
    }
    return _createWalletBtn;
}

- (XXButton *)importWalletBtn {
    if (!_importWalletBtn) {
        MJWeakSelf
        _importWalletBtn = [XXButton buttonWithFrame:CGRectMake(K375(15), kScreen_Height - 84, kScreen_Width - K375(30), kBtnHeight) title:LocalizedString(@"ImportWallet") font:kFontBold18 titleColor:kPrimaryMain block:^(UIButton *button) {
            XXImportWalletVC *importVC = [[XXImportWalletVC alloc] init];
            [weakSelf.navigationController pushViewController:importVC animated:YES];
        }];
        _importWalletBtn.backgroundColor = kWhiteColor;
        _importWalletBtn.layer.cornerRadius = kBtnBorderRadius;
        _importWalletBtn.layer.borderColor = [kPrimaryMain CGColor];
        _importWalletBtn.layer.borderWidth = 2;
        _importWalletBtn.layer.masksToBounds = YES;
    }
    return _importWalletBtn;
}

@end
