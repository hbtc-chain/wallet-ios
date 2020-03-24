//
//  XXCreateWalletSetPasswordVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXCreateWalletSetPasswordVC.h"
#import "XXRepeatPasswordVC.h"

@interface XXCreateWalletSetPasswordVC ()

@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) XXLabel *stepTipLabel;
@property (nonatomic, strong) XXLabel *contentLabel;
@property (nonatomic, strong) XXLabel *nameLabel;
@property (nonatomic, strong) XXTextFieldView *textFieldView;
@property (nonatomic, strong) XXLabel *charCountLabel;
@property (nonatomic, strong) XXButton *createBtn;

@property (nonatomic, strong) XXLabel *ruleTip;
@property (nonatomic, strong) XXLabel *rule1;
@property (nonatomic, strong) XXLabel *rule2;
@property (nonatomic, strong) XXLabel *rule3;
@property (nonatomic, strong) XXLabel *rule4;
@end

@implementation XXCreateWalletSetPasswordVC

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
    [self.view addSubview:self.charCountLabel];
    [self.view addSubview:self.ruleTip];
    [self.view addSubview:self.rule1];
    [self.view addSubview:self.rule2];
    [self.view addSubview:self.rule3];
    [self.view addSubview:self.rule4];
    [self.view addSubview:self.createBtn];
}

- (void)nextStepAction {
    KUser.localPassword = self.textFieldView.textField.text;
    XXRepeatPasswordVC *repeatVC = [[XXRepeatPasswordVC alloc] init];
    [self.navigationController pushViewController:repeatVC animated:YES];
}

- (void)textFiledValueChange:(UITextField *)textField {
    self.rule1.textColor = [self isValidPasswordString:1] ? kTipColor : kRed100;
    self.rule2.textColor = [self isValidPasswordString:2] ? kTipColor : kRed100;
    self.rule3.textColor = [self isValidPasswordString:3] ? kTipColor : kRed100;
    self.rule4.textColor = [self isValidPasswordString:4] ? kTipColor : kRed100;
    self.ruleTip.textColor = textField.text.length ? kTipColor : kRed100;
    self.createBtn.backgroundColor =  [self isValidPasswordString:0] ? kBlue100 : kBtnNotEnableColor;
    self.createBtn.enabled = [self isValidPasswordString:0];
    if (textField.text.length) {
        self.charCountLabel.text = NSLocalizedFormatString(LocalizedString(@"CharCount"),[NSString stringWithFormat:@"%lu",(unsigned long)textField.text.length]);
    } else {
        self.charCountLabel.text = @"";
    }
}

-(BOOL)isValidPasswordString:(int)type {
    NSString *text = self.textFieldView.textField.text;
    BOOL isHaveUppercase = NO;
    BOOL isHaveLowercase = NO;
    BOOL isHaveNumber = NO;
    BOOL isMoreThan8 = NO;
    for (int i = 0; i < text.length; i++) {
        char commitChar = [text characterAtIndex:i];
        if((commitChar>64)&&(commitChar<91)){ // 字符串中含有大写英文字母
            isHaveUppercase = YES;
        }else if((commitChar>96)&&(commitChar<123)){ // 字符串中含有小写英文字母
            isHaveLowercase = YES;
        }else if((commitChar>47)&&(commitChar<58)){ // 字符串中含有数字
            isHaveNumber = YES;
        }else{ // 字符串中含有非法字符
        }
    }
    if (text.length >= 8) {
        isMoreThan8 = YES;
    }
    if (type == 1) {
        return isHaveUppercase;
    } else if (type == 2) {
        return isHaveLowercase;
    } else if (type == 3) {
        return isHaveNumber;
    } else if (type == 4) {
        return isMoreThan8;
    } else {
        return (isHaveUppercase && isHaveLowercase && isHaveNumber && isMoreThan8);
    }
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        CGFloat width = [NSString widthWithText:LocalizedString(@"SetPassword") font:kFontBold(26)];
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), kNavHeight, width, 40) text:LocalizedString(@"SetPassword") font:kFontBold(26) textColor:kDark100 alignment:NSTextAlignmentLeft];
    }
    return _tipLabel;
}

- (XXLabel *)stepTipLabel {
    if (!_stepTipLabel) {
        _stepTipLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.tipLabel.frame) + 5, kNavHeight + 15, kScreen_Width - K375(32) - self.tipLabel.width, 20) text:LocalizedString(@"Step2") font:kFont12 textColor:kDark50 alignment:NSTextAlignmentLeft];
    }
    return _stepTipLabel;
}

- (XXLabel *)contentLabel {
    if (!_contentLabel) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"SetPasswordTip") font:kFont(15) width:kScreen_Width - K375(32)];
        _contentLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.tipLabel.frame) + 10, kScreen_Width - K375(32), height) text:LocalizedString(@"SetPasswordTip") font:kFont(15) textColor:kTipColor alignment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (XXLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.contentLabel.frame) + 6, kScreen_Width - K375(32), 40) text:LocalizedString(@"WalletPassword") font:kFont15 textColor:kTipColor alignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (XXTextFieldView *)textFieldView {
    if (!_textFieldView) {
        _textFieldView = [[XXTextFieldView alloc] initWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.nameLabel.frame), kScreen_Width - K375(32), 48)];
        _textFieldView.textField.placeholder = LocalizedString(@"SetPasswordPlaceHolder");
        _textFieldView.showLookBtn = YES;
        [_textFieldView.textField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFieldView;
}

- (XXLabel *)charCountLabel {
    if (!_charCountLabel) {
        _charCountLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.textFieldView.frame)+3, kScreen_Width - K375(32), 20) text:@"" font:kFont(15) textColor:kTipColor alignment:NSTextAlignmentRight];
    }
    return _charCountLabel;
}

- (XXLabel *)ruleTip {
    if (!_ruleTip) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"RuleTip") font:kFont(15) width:kScreen_Width - K375(32)];
        _ruleTip = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.charCountLabel.frame), kScreen_Width - K375(32), height) text:LocalizedString(@"RuleTip") font:kFont(15) textColor:kRed100 alignment:NSTextAlignmentLeft];
        _ruleTip.numberOfLines = 0;
    }
    return _ruleTip;
}

- (XXLabel *)rule1 {
    if (!_rule1) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"RuleTip1") font:kFont(15) width:kScreen_Width - K375(32)];
        _rule1 = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.ruleTip.frame) + 10, kScreen_Width - K375(32), height) text:LocalizedString(@"RuleTip1") font:kFont(15) textColor:kRed100 alignment:NSTextAlignmentLeft];
        _rule1.numberOfLines = 0;
    }
    return _rule1;
}

- (XXLabel *)rule2 {
    if (!_rule2) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"RuleTip2") font:kFont(15) width:kScreen_Width - K375(32)];
        _rule2 = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.rule1.frame) + 10, kScreen_Width - K375(32), height) text:LocalizedString(@"RuleTip2") font:kFont(15) textColor:kRed100 alignment:NSTextAlignmentLeft];
        _rule2.numberOfLines = 0;
    }
    return _rule2;
}

- (XXLabel *)rule3 {
    if (!_rule3) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"RuleTip3") font:kFont(15) width:kScreen_Width - K375(32)];
        _rule3 = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.rule2.frame) + 10, kScreen_Width - K375(32), height) text:LocalizedString(@"RuleTip3") font:kFont(15) textColor:kRed100 alignment:NSTextAlignmentLeft];
        _rule3.numberOfLines = 0;
    }
    return _rule3;
}

- (XXLabel *)rule4 {
    if (!_rule4) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"RuleTip4") font:kFont(15) width:kScreen_Width - K375(32)];
        _rule4 = [XXLabel labelWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.rule3.frame) + 10, kScreen_Width - K375(32), height) text:LocalizedString(@"RuleTip4") font:kFont(15) textColor:kRed100 alignment:NSTextAlignmentLeft];
        _rule4.numberOfLines = 0;
    }
    return _rule4;
}

- (XXButton *)createBtn {
    if (!_createBtn) {
        MJWeakSelf
        _createBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), CGRectGetMaxY(self.rule4.frame) + 24, kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"NextStep") font:kFontBold18 titleColor:kWhite100 block:^(UIButton *button) {
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
