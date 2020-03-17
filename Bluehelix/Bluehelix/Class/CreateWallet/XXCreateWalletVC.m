//
//  XXCreateWalletVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/10.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXCreateWalletVC.h"
#import "XXCreateWalletSetPasswordVC.h"

@interface XXCreateWalletVC ()

@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) XXLabel *stepTipLabel;
@property (nonatomic, strong) XXLabel *contentLabel;
@property (nonatomic, strong) XXLabel *nameLabel;
@property (nonatomic, strong) XXTextFieldView *textFieldView;
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
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.stepTipLabel];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.textFieldView];
    [self.view addSubview:self.createBtn];
}

- (void)nextStepAction {
    if (self.textFieldView.textField.text.length > 20) {
        //TODO alert
        [MBProgressHUD showErrorMessage:LocalizedString(@"AccountNameRuleAlert")];
        return;
    }
    KUser.localUserName = self.textFieldView.textField.text;
    XXCreateWalletSetPasswordVC *passwordVC = [[XXCreateWalletSetPasswordVC alloc] init];
    [self.navigationController pushViewController:passwordVC animated:YES];
}

- (void)textFiledValueChange:(UITextField *)textField {
    if (textField.text.length) {
        self.createBtn.enabled = YES;
        self.createBtn.backgroundColor = kBlue100;
    } else {
        self.createBtn.enabled = NO;
        self.createBtn.backgroundColor = kBtnNotEnableColor;
    }
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        CGFloat width = [NSString widthWithText:LocalizedString(@"SetName") font:kFontBold(26)];
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), kNavHeight, width, 40) text:LocalizedString(@"SetName") font:kFontBold(26) textColor:kDark100 alignment:NSTextAlignmentLeft];
    }
    return _tipLabel;
}

- (XXLabel *)stepTipLabel {
    if (!_stepTipLabel) {
        _stepTipLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.tipLabel.frame) + 5, kNavHeight + 15, kScreen_Width - K375(32) - self.tipLabel.width, 20) text:LocalizedString(@"Step1") font:kFont12 textColor:kTipColor alignment:NSTextAlignmentLeft];
    }
    return _stepTipLabel;
}

- (XXLabel *)contentLabel {
    if (!_contentLabel) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"SetNameTip") font:kFont(15) width:kScreen_Width - K375(32)];
        _contentLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipLabel.frame) + 10, kScreen_Width - K375(32), height) text:LocalizedString(@"SetNameTip") font:kFont(15) textColor:kTipColor alignment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.contentLabel.frame) + 6, kScreen_Width - K375(32), 40) text:LocalizedString(@"WalletName") font:kFont15 textColor:kDark100 alignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (XXTextFieldView *)textFieldView {
    if (!_textFieldView) {
        _textFieldView = [[XXTextFieldView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.nameLabel.frame), kScreen_Width - K375(32), 48)];
        _textFieldView.textField.placeholder = LocalizedString(@"SetNamePlaceHolder");
        [_textFieldView.textField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _textFieldView;
}

- (XXButton *)createBtn {
    if (!_createBtn) {
        MJWeakSelf
        _createBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.textFieldView.frame) + 24, kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"NextStep") font:kFontBold18 titleColor:kWhite100 block:^(UIButton *button) {
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
