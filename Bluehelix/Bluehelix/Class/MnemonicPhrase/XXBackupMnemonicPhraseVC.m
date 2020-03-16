//
//  XXBackupMnemonicPhraseVC.m
//  Wallet
//
//  Created by 袁振 on 2020/03/06.
//  Copyright © 2020 yuanzhen. All rights reserved.
//

#import "XXBackupMnemonicPhraseVC.h"
#import "XXMnemonicBtn.h"
#import "XXVerifyMnemonicPhraseVC.h"

@interface XXBackupMnemonicPhraseVC ()

@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) XXLabel *contentLabel;
@property (nonatomic, strong) XXButton *backupBtn;
@end

@implementation XXBackupMnemonicPhraseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = LocalizedString(@"BackupMnemonicPhrase");
    [self buildUI];
}

- (void)buildUI {
    self.view.backgroundColor = kWhite100;
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.contentLabel];
    [self drawPhraseBtn];
    [self.view addSubview:self.backupBtn];
}

- (void)drawPhraseBtn {
    NSArray *phraseArr = @[@"useful",@"key",@"amatur",@"dearagon",@"shaft",@"orbit",@"series",@"slogan",@"float",@"cereal"];
    int HSpace = K375(16);
    int VSpace = K375(8);
    int Width = (kScreen_Width - 4*HSpace)/3;
    int Height = K375(56);
    int Left = HSpace;
    int Top = VSpace + CGRectGetMaxY(self.contentLabel.frame) + 16;
    for (int i = 0; i < phraseArr.count; i++) {
        Left = HSpace + (HSpace+Width)*(i%3);
        if (i % 3 == 0 && i != 0) {
            Top = Top + Height + VSpace;
            Left = HSpace;
        }
        XXMnemonicBtn *btn = [[XXMnemonicBtn alloc] initWithFrame:CGRectMake(Left, Top, Width, Height) order:[NSString stringWithFormat:@"%d",i+1] title:phraseArr[i]];
        [self.view addSubview:btn];
    }
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), kNavHeight, kScreen_Width - K375(32), 40) text:LocalizedString(@"BackupTip") font:kFontBold(26) textColor:kDark100 alignment:NSTextAlignmentLeft];
    }
    return _tipLabel;
}

- (XXLabel *)contentLabel {
    if (!_contentLabel) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"BackupTipContent") font:kFont(15) width:kScreen_Width - K375(32)];
        _contentLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipLabel.frame), kScreen_Width - K375(32), height) text:LocalizedString(@"BackupTipContent") font:kFont(15) textColor:kDark50 alignment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (XXButton *)backupBtn {
    if (!_backupBtn) {
        _backupBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), kScreen_Height - kBtnHeight - K375(16), kScreen_Width - K375(32), 44) title:LocalizedString(@"StartBackup") font:kFontBold18 titleColor:kWhite100 block:^(UIButton *button) {
            XXVerifyMnemonicPhraseVC *verifyVC = [[XXVerifyMnemonicPhraseVC alloc] init];
            [self.navigationController pushViewController:verifyVC animated:YES];
        }];
        _backupBtn.backgroundColor = kBlue100;
        _backupBtn.layer.cornerRadius = kBtnBorderRadius;
        _backupBtn.layer.masksToBounds = YES;
    }
    return _backupBtn;
}

@end
