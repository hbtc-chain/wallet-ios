//
//  XXStartWalletVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/09.
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
    [self buildUI];
}

- (void)buildUI {
    self.navView.hidden = YES;
    self.view.backgroundColor = kWhite100;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width/2 - K375(224)/2, K375(216), K375(224), K375(71))];
    logoImageView.image = [UIImage imageNamed:@"startLogo"];
    [self.view addSubview:logoImageView];
    [self.view addSubview:self.createWalletBtn];
    [self.view addSubview:self.importWalletBtn];
}

- (XXButton *)createWalletBtn {
    if (!_createWalletBtn) {
        MJWeakSelf
        _createWalletBtn = [XXButton buttonWithFrame:CGRectMake(K375(15), kScreen_Height - 144, kScreen_Width - K375(30), kBtnHeight) title:LocalizedString(@"CreateWallet") font:kFontBold18 titleColor:kWhite100 block:^(UIButton *button) {
            XXCreateWalletVC *createVC = [[XXCreateWalletVC alloc] init];
            [weakSelf.navigationController pushViewController:createVC animated:YES];
        }];
        _createWalletBtn.backgroundColor = kBlue100;
        _createWalletBtn.layer.cornerRadius = kBtnBorderRadius;
        _createWalletBtn.layer.masksToBounds = YES;
    }
    return _createWalletBtn;
}

- (XXButton *)importWalletBtn {
    if (!_importWalletBtn) {
        MJWeakSelf
        _importWalletBtn = [XXButton buttonWithFrame:CGRectMake(K375(15), kScreen_Height - 84, kScreen_Width - K375(30), kBtnHeight) title:LocalizedString(@"ImportWallet") font:kFontBold18 titleColor:kWhite100 block:^(UIButton *button) {
            XXImportWalletVC *importVC = [[XXImportWalletVC alloc] init];
            [weakSelf.navigationController pushViewController:importVC animated:YES];
        }];
        _importWalletBtn.backgroundColor = kDark80;
        _importWalletBtn.layer.cornerRadius = kBtnBorderRadius;
        _importWalletBtn.layer.masksToBounds = YES;
    }
    return _importWalletBtn;
}

@end
