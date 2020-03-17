//
//  XXImportMnemonicPhraseVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXImportMnemonicPhraseVC.h"
#import "Account.h"

@interface XXImportMnemonicPhraseVC () <UITextViewDelegate>

@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) XXButton *createBtn;

@end

@implementation XXImportMnemonicPhraseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)nextStepAction {
    NSLog(@"%@",self.textView.text);
    Account *account = [Account accountWithMnemonicPhrase:self.textView.text];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:account.privateKey forKey:@"privateKey"];
    [dic setObject:account.BHAddress forKey:@"BHAddress"];
    [dic setObject:@"test" forKey:@"userName"];
    [dic setObject:@"test" forKey:@"password"];

    [KUser addAccount:dic];
    KUser.rootAccount = dic;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"ImportMnemonicPhrase");
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.createBtn];
}

- (void)textViewDidChange:(UITextView *)textView {
        if (textView.text.length) {
            self.createBtn.enabled = YES;
            self.createBtn.backgroundColor = kBlue100;
        } else {
            self.createBtn.enabled = NO;
            self.createBtn.backgroundColor = kBtnNotEnableColor;
        }
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"ImportMnemonicPhraseTip") font:kFont(15) width:kScreen_Width - K375(32)];
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), kNavHeight, kScreen_Width - K375(32), height) text:LocalizedString(@"ImportMnemonicPhraseTip") font:kFont(15) textColor:kTipColor alignment:NSTextAlignmentLeft];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipLabel.frame) + 16, kScreen_Width - K375(32), K375(144))];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = kFont(13);
        _textView.delegate = self;
    }
    return _textView;
}

- (XXButton *)createBtn {
    if (!_createBtn) {
        MJWeakSelf
        _createBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.textView.frame) + 24, kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"NextStep") font:kFontBold18 titleColor:kWhite100 block:^(UIButton *button) {
            [weakSelf nextStepAction];
        }];
        _createBtn.backgroundColor = kBtnNotEnableColor;
        _createBtn.layer.cornerRadius = kBtnBorderRadius;
        _createBtn.layer.masksToBounds = YES;
        _createBtn.enabled = NO;
    }
    return _createBtn;
}

@end

