//
//  XXImportKeystoreVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/5/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXImportKeystoreVC.h"
#import "XXCreateWalletVC.h"
#import "SecureData.h"
#import "Account.h"

@interface XXImportKeystoreVC () <UITextViewDelegate>

@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) XXButton *createBtn;
@property (nonatomic, strong) UIView *textBackView;
@end

@implementation XXImportKeystoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)nextStepAction {
    NSLog(@"%@",self.textView.text);
//    SecureData * data = [SecureData secureDataWithHexString:self.textView.text];
//    Account *account = [Account accountWithPrivateKey:data.data];
//    if (account) {
//        //判断是否重复导入
//        if (KUser.accounts) {
//            for (XXAccountModel *model in KUser.accounts) {
//                if ([model.address isEqualToString:account.BHAddress]) {
//                    Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"KeystoreRepetition") duration:kAlertDuration completion:^{
//                    }];
//                    [alert showAlert];
//                    return;
//                }
//            }
//        }
//        KUser.localPrivateKey = self.textView.text;
//        KUser.localPhraseString = @"";
//        XXCreateWalletVC *createVC = [[XXCreateWalletVC alloc] init];
//        [self.navigationController pushViewController:createVC animated:YES];
//    } else {
//        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"KeystoreOutOfOrder") duration:kAlertDuration completion:^{
//                   }];
//        [alert showAlert];
//    }
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"ImportKeystore");
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.textBackView];
    [self.textBackView addSubview:self.textView];
    [self.view addSubview:self.createBtn];
}

- (void)textViewDidChange:(UITextView *)textView {
        if (textView.text.length) {
            self.createBtn.enabled = YES;
            self.createBtn.backgroundColor = kPrimaryMain;
        } else {
            self.createBtn.enabled = NO;
            self.createBtn.backgroundColor = kGray100;
        }
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"ImportKeystoreTip") font:kFont(15) width:kScreen_Width - K375(32)];
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), kNavHeight, kScreen_Width - K375(32), height) text:LocalizedString(@"ImportKeystoreTip") font:kFont(15) textColor:kGray500 alignment:NSTextAlignmentLeft];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UIView *)textBackView {
    if (!_textBackView) {
        _textBackView = [[UIView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipLabel.frame) + 16, kScreen_Width - K375(32), K375(144))];
        _textBackView.backgroundColor = kGray50;
        _textBackView.layer.cornerRadius = kBtnBorderRadius;
        _textBackView.layer.masksToBounds = YES;
    }
    return _textBackView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.textBackView.bounds];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = kFont(13);
        _textView.delegate = self;
        _textView.textColor = kGray900;
    }
    return _textView;
}

- (XXButton *)createBtn {
    if (!_createBtn) {
        MJWeakSelf
        _createBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.textBackView.frame) + 24, kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"NextStep") font:kFontBold18 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf nextStepAction];
        }];
        _createBtn.backgroundColor = kGray100;
        _createBtn.layer.cornerRadius = kBtnBorderRadius;
        _createBtn.layer.masksToBounds = YES;
        _createBtn.enabled = NO;
    }
    return _createBtn;
}

@end
