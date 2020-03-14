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
    NSArray *phraseArr = @[@"useful",@"key",@"amatur",@"dearagon",@"shaft",@"orbit",@"series",@"slogan",@"float",@"cereal"];
    int HSpace = K375(16);
    int VSpace = K375(8);
    int Width = (kScreen_Width - 4*HSpace)/3;
    int Height = K375(56);
    int Left = HSpace;
    int Top = VSpace+kNavHeight;
    for (int i = 0; i < phraseArr.count; i++) {
        Left = HSpace + (HSpace+Width)*(i%3);
        if (i % 3 == 0 && i != 0) {
            Top = Top + Height + VSpace;
            Left = HSpace;
        }
        XXMnemonicBtn *btn = [[XXMnemonicBtn alloc] initWithFrame:CGRectMake(Left, Top, Width, Height) order:[NSString stringWithFormat:@"%d",i+1] title:phraseArr[i]];
        [self.view addSubview:btn];
    }
    
    XXButton *startBackupBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), kScreen_Height - 84, kScreen_Width - K375(32), 44) title:LocalizedString(@"StartBackup") font:kFontBold18 titleColor:kWhite100 block:^(UIButton *button) {
        XXVerifyMnemonicPhraseVC *verifyVC = [[XXVerifyMnemonicPhraseVC alloc] init];
        [self.navigationController pushViewController:verifyVC animated:YES];
    }];
    startBackupBtn.backgroundColor = kBlue100;
    startBackupBtn.layer.cornerRadius = 4;
    startBackupBtn.layer.masksToBounds = YES;
    [self.view addSubview:startBackupBtn];
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
