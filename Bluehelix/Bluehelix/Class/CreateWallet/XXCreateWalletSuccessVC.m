//
//  XXCreateWalletSuccessVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/10.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXCreateWalletSuccessVC.h"
#import "XXTabBarController.h"
#import "XXBackupMnemonicPhraseVC.h"
#import "XXScreenShotAlert.h"

@interface XXCreateWalletSuccessVC ()

@property (nonatomic, strong) UIImageView *successImageView;
@property (nonatomic, strong) XXLabel *successLabel;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) XXLabel *tipNamelabel1;
@property (nonatomic, strong) XXLabel *tipNamelabel2;
@property (nonatomic, strong) XXLabel *tipContentlabel1;
@property (nonatomic, strong) XXLabel *tipContentlabel2;
@property (nonatomic, strong) XXButton *immediatelyBtn;
@property (nonatomic, strong) XXButton *laterBtn;

@end

@implementation XXCreateWalletSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI {
    self.navView.hidden = YES;
    [self.view addSubview:self.successImageView];
    [self.view addSubview:self.successLabel];
    [self.view addSubview:self.tipView];
    [self.view addSubview:self.immediatelyBtn];
    [self.view addSubview:self.laterBtn];
    [self.tipView addSubview:self.tipNamelabel1];
    [self.tipView addSubview:self.tipContentlabel1];
    [self.tipView addSubview:self.tipNamelabel2];
    [self.tipView addSubview:self.tipContentlabel2];
}

- (UIImageView *)successImageView {
    if (!_successImageView) {
        _successImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width/2 - K375(72)/2, 88, K375(72), K375(72))];
        _successImageView.image = [UIImage imageNamed:@"CreateWalletSuccess"];
    }
    return _successImageView;
}

- (XXLabel *)successLabel {
    if (!_successLabel) {
        _successLabel = [XXLabel labelWithFrame:CGRectMake(0, self.successImageView.bottom + K375(16), kScreen_Width, 24) text:LocalizedString(@"CreateWalletSuccess") font:kFont(17) textColor:kDark100 alignment:NSTextAlignmentCenter];
    }
    return _successLabel;
}

- (UIView *)tipView {
    if (!_tipView) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.successLabel.frame) + 32, kScreen_Width - K375(32), 280)];
        _tipView.layer.borderColor = [KLine_Color CGColor];
        _tipView.layer.borderWidth = 1;
        _tipView.layer.cornerRadius = kBtnBorderRadius;
        _tipView.layer.masksToBounds = YES;
    }
    return _tipView;
}

- (XXLabel *)tipNamelabel1 {
    if (!_tipNamelabel1) {
        _tipNamelabel1 = [XXLabel labelWithFrame:CGRectMake(K375(16), K375(16), kScreen_Width - K375(64), 24) text:LocalizedString(@"CreateWalletBackupTip") font:kFont(17) textColor:kDark100 alignment:NSTextAlignmentLeft];
    }
    return _tipNamelabel1;
}

- (XXLabel *)tipContentlabel1 {
    if (!_tipContentlabel1) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"CreateWalletBackupTipContent") font:kFont(15) width:kScreen_Width - K375(64)];
        _tipContentlabel1 = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipNamelabel1.frame) + 10, kScreen_Width - K375(64), height) text:LocalizedString(@"CreateWalletBackupTipContent") font:kFont(15) textColor:kTipColor alignment:NSTextAlignmentLeft];
        _tipContentlabel1.numberOfLines = 0;
    }
    return _tipContentlabel1;
}

- (XXLabel *)tipNamelabel2 {
    if (!_tipNamelabel2) {
        _tipNamelabel2 = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipContentlabel1.frame) + K375(16), kScreen_Width - K375(64), 24) text:LocalizedString(@"WeSuggest") font:kFont(17) textColor:kDark100 alignment:NSTextAlignmentLeft];
    }
    return _tipNamelabel2;
}

- (XXLabel *)tipContentlabel2 {
    if (!_tipContentlabel2) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"WeSuggestContent") font:kFont(15) width:kScreen_Width - K375(64)];
        _tipContentlabel2 = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipNamelabel2.frame) + 10, kScreen_Width - K375(64), height) text:LocalizedString(@"WeSuggestContent") font:kFont(15) textColor:kTipColor alignment:NSTextAlignmentLeft];
        _tipContentlabel2.numberOfLines = 0;
    }
    return _tipContentlabel2;
}

- (XXButton *)laterBtn {
    if (!_laterBtn) {
        _laterBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), kScreen_Height - kBtnHeight - 24, kScreen_Width/2 - K375(40)/2, kBtnHeight) title:LocalizedString(@"BackupLater") font:kFont(17) titleColor:kBlue100 block:^(UIButton *button) {
            KWindow.rootViewController = [[XXTabBarController alloc] init];
        }];
        _laterBtn.backgroundColor = kBlue20;
        _laterBtn.layer.cornerRadius = kBtnBorderRadius;
        _laterBtn.layer.masksToBounds = YES;
    }
    return _laterBtn;
}

- (XXButton *)immediatelyBtn {
    if (!_immediatelyBtn) {
        MJWeakSelf
        _immediatelyBtn = [XXButton buttonWithFrame:CGRectMake(kScreen_Width/2 + 4, kScreen_Height - kBtnHeight - 24, kScreen_Width/2 - K375(40)/2, kBtnHeight) title:LocalizedString(@"BackupImmediately") font:kFont(17) titleColor:kWhite100 block:^(UIButton *button) {
            [XXScreenShotAlert showWithSureBlock:^{
                XXBackupMnemonicPhraseVC *backupVC = [[XXBackupMnemonicPhraseVC alloc] init];
                [weakSelf.navigationController pushViewController:backupVC animated:YES];
            }];
        }];
        _immediatelyBtn.backgroundColor = kBlue100;
        _immediatelyBtn.layer.cornerRadius = kBtnBorderRadius;
        _immediatelyBtn.layer.masksToBounds = YES;
    }
    return _immediatelyBtn;
}

@end
