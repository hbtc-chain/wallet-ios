//
//  XXCreateWalletSetPasswordVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXCreateWalletSetPasswordVC.h"
#import "XXRepeatPasswordVC.h"
#import "XYHNumbersLabel.h"
#import "IQKeyboardManager.h"
#import "XXSetPasswordNumTextFieldView.h"

@interface XXCreateWalletSetPasswordVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) XXLabel *stepTipLabel;
@property (nonatomic, strong) XYHNumbersLabel *contentLabel;
@property (nonatomic, strong) XXLabel *nameLabel;
@property (nonatomic, strong) XXSetPasswordNumTextFieldView *passwordView;
@property (nonatomic, strong) XXButton *createBtn;
@end

@implementation XXCreateWalletSetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [IQKeyboardManager sharedManager].enable = NO;
    [self buildUI];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"CreateWallet");
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tipLabel];
    [self.scrollView addSubview:self.stepTipLabel];
    [self.scrollView addSubview:self.contentLabel];
    [self.scrollView addSubview:self.nameLabel];
    [self.scrollView addSubview:self.passwordView];
    [self.scrollView addSubview:self.createBtn];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.createBtn.frame) + 30);
}

- (void)nextStepAction {
    KUser.localPassword = self.passwordView.text;
    XXRepeatPasswordVC *repeatVC = [[XXRepeatPasswordVC alloc] init];
    [self.navigationController pushViewController:repeatVC animated:YES];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        CGFloat width = [NSString widthWithText:LocalizedString(@"SetPassword") font:kFontBold(26)];
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), kNavHeight, width, 40) text:LocalizedString(@"SetPassword") font:kFontBold(26) textColor:kGray900 alignment:NSTextAlignmentLeft];
    }
    return _tipLabel;
}

- (XXLabel *)stepTipLabel {
    if (!_stepTipLabel) {
        _stepTipLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.tipLabel.frame) + 5, kNavHeight + 15, kScreen_Width - K375(32) - self.tipLabel.width, 20) text:LocalizedString(@"Step2") font:kFont12 textColor:kGray500 alignment:NSTextAlignmentLeft];
    }
    return _stepTipLabel;
}

- (XYHNumbersLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipLabel.frame) + 10, kScreen_Width - K375(32), 0) font:kFont(15)];
        _contentLabel.textColor = kGray500;
        [_contentLabel setText:LocalizedString(@"SetPasswordTip") alignment:NSTextAlignmentLeft];
    }
    return _contentLabel;
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.contentLabel.frame) + 24, kScreen_Width - K375(32), 40) text:LocalizedString(@"SetPasswordRuleTip") font:kFont15 textColor:kGray700 alignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (XXSetPasswordNumTextFieldView *)passwordView {
    if (_passwordView == nil) {
        _passwordView = [[XXSetPasswordNumTextFieldView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.nameLabel.frame) + 24, kScreen_Width - K375(32), 24)];
        MJWeakSelf
        _passwordView.finishBlock = ^(NSString * _Nonnull text) {
            KUser.localPassword = text;
            XXRepeatPasswordVC *repeatVC = [[XXRepeatPasswordVC alloc] init];
            [weakSelf.navigationController pushViewController:repeatVC animated:YES];
        };
    }
    return _passwordView;
}

- (XXButton *)createBtn {
    if (!_createBtn) {
        MJWeakSelf
        _createBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.passwordView.frame) + 24, kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"NextStep") font:kFontBold18 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf nextStepAction];
        }];
        _createBtn.backgroundColor = kPrimaryMain;
        _createBtn.layer.cornerRadius = kBtnBorderRadius;
        _createBtn.layer.masksToBounds = YES;
//        _createBtn.enabled = NO;
    }
    return _createBtn;
}

@end
