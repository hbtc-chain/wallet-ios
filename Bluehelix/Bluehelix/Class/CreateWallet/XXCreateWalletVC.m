//
//  XXCreateWalletVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/10.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXCreateWalletVC.h"
#import "XXCreateWalletSuccessVC.h"

@interface XXCreateWalletVC ()

@property (nonatomic, strong) XXButton *createBtn;

@end

@implementation XXCreateWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"CreateWallet");
    [self.view addSubview:self.createBtn];
}


- (XXButton *)createBtn {
    if (!_createBtn) {
        _createBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), kScreen_Height - 77, kScreen_Width - K375(32), 44) title:LocalizedString(@"StartCreate") font:kFontBold18 titleColor:kWhite100 block:^(UIButton *button) {
            XXCreateWalletSuccessVC *successVC = [[XXCreateWalletSuccessVC alloc] init];
            [self.navigationController pushViewController:successVC animated:YES];
        }];
        _createBtn.backgroundColor = kBlue100;
        _createBtn.layer.cornerRadius = 4;
        _createBtn.layer.masksToBounds = YES;
    }
    return _createBtn;
}

@end
