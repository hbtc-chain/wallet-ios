//
//  XXBackupKeystoreTipVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/5/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXBackupKeystoreTipVC.h"
#import "XYHNumbersLabel.h"
#import "XXBackupKeystoreVC.h"
#import "XXScreenShotAlert.h"

@interface XXBackupKeystoreTipVC ()

@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) XYHNumbersLabel *contentLabel;
@property (nonatomic, strong) XXButton *createBtn;

@end

@implementation XXBackupKeystoreTipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"BackupKeystore");
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.createBtn];
}

- (void)nextStepAction {
    [XXScreenShotAlert showWithSureBlock:^{
        XXBackupKeystoreVC *keystoreVC = [[XXBackupKeystoreVC alloc] init];
        keystoreVC.text = KUser.currentAccount.keystore;
        [self.navigationController pushViewController:keystoreVC animated:YES];
    }];
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), kNavHeight, kScreen_Width - K375(32), 40) text:LocalizedString(@"CreateWalletBackupTip") font:kFontBold(26) textColor:kGray900 alignment:NSTextAlignmentLeft];
    }
    return _tipLabel;
}

- (XYHNumbersLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipLabel.frame) + 8, kScreen_Width - K375(32), 0) font:kFont(15)];
        _contentLabel.textColor = kGray500;
        [_contentLabel setText:LocalizedString(@"BackupKeystoreTip") alignment:NSTextAlignmentLeft];
    }
    return _contentLabel;
}

- (XXButton *)createBtn {
    if (!_createBtn) {
        MJWeakSelf
        _createBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), kScreen_Height - 54, kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"NextStep") font:kFontBold18 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf nextStepAction];
        }];
        _createBtn.backgroundColor = kPrimaryMain;
        _createBtn.layer.cornerRadius = kBtnBorderRadius;
        _createBtn.layer.masksToBounds = YES;
    }
    return _createBtn;
}

@end
