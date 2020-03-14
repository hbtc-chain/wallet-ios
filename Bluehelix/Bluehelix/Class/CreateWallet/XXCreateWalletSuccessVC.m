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
    [self.view addSubview:self.immediatelyBtn];
    [self.view addSubview:self.laterBtn];
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
        _successLabel = [XXLabel labelWithFrame:CGRectMake(0, self.successImageView.bottom + K375(16), kScreen_Width, 24) text:LocalizedString(@"CreateWalletSuccess") font:kFont16 textColor:kDark100 alignment:NSTextAlignmentCenter];
    }
    return _successLabel;
}

- (XXButton *)immediatelyBtn {
    if (!_immediatelyBtn) {
        MJWeakSelf
        _immediatelyBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), kScreen_Height - 120, kScreen_Width - K375(32), 44) title:LocalizedString(@"BackupImmediately") font:kFont(17) titleColor:kWhite100 block:^(UIButton *button) {
            [XXScreenShotAlert showWithSureBlock:^{
                XXBackupMnemonicPhraseVC *backupVC = [[XXBackupMnemonicPhraseVC alloc] init];
                [weakSelf.navigationController pushViewController:backupVC animated:YES];
            }];
        }];
        _immediatelyBtn.backgroundColor = kBlue100;
        _immediatelyBtn.layer.cornerRadius = 4;
        _immediatelyBtn.layer.masksToBounds = YES;
    }
    return _immediatelyBtn;
}

- (XXButton *)laterBtn {
    if (!_laterBtn) {
        _laterBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), kScreen_Height - 68, kScreen_Width - K375(32), 44) title:LocalizedString(@"BackupLater") font:kFontBold18 titleColor:kBlue100 block:^(UIButton *button) {
            KWindow.rootViewController = [[XXTabBarController alloc] init];
        }];
        _laterBtn.backgroundColor = kWhite100;
        _laterBtn.layer.cornerRadius = 4;
        _laterBtn.layer.masksToBounds = YES;
    }
    return _laterBtn;
}

@end
