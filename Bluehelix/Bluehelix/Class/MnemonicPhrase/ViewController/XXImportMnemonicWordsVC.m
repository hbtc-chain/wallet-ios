//
//  XXImportMnemonicWordsVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/7/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXImportMnemonicWordsVC.h"
#import "XXCreateWalletVC.h"
#import "Account.h"
#import "SecureData.h"
#import "XXMnemonicWordTextFieldView.h"
#include "bip39.h"

@interface XXImportMnemonicWordsVC () <UITextFieldDelegate,KeyInputTextFieldDelegate>

@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) UIView *textBackView;
@property (nonatomic, strong) XXButton *createBtn;
@property (nonatomic, strong) NSMutableArray *textFieldArray;
@property (nonatomic, strong) NSMutableArray *wordsArray;
@property (nonatomic, strong) NSMutableArray *inputWordsArray; //输入的助记词

@end

@implementation XXImportMnemonicWordsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"ImportMnemonicPhrase");
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.textBackView];
    [self buildWords];
    XXMnemonicWordTextFieldView *view = [self.textFieldArray firstObject];
    [view.textField becomeFirstResponder];
    [self.view addSubview:self.createBtn];
}

- (void)buildWords {
    [self.textBackView removeAllSubviews];
    [self.textFieldArray removeAllObjects];
    CGFloat space = 16;
    CGFloat width = (self.textBackView.width - 5*space)/4;
    CGFloat height = 32;
    int index = 0;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 4; j++) {
            XXMnemonicWordTextFieldView *textFieldView = [[XXMnemonicWordTextFieldView alloc] initWithFrame:CGRectMake(space + (width+space)*j, space + (space+height)*i, width, height)];
            textFieldView.hidden = index == 0 ? NO : YES;
            textFieldView.index = index++;
            textFieldView.textField.delegate = self;
            textFieldView.textField.keyInputDelegate = self;
            [textFieldView.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            [self.textBackView addSubview:textFieldView];
            [self.textFieldArray addObject:textFieldView];
        }
    }
}

- (void)refreshWords {
    for (int i = 0; i < 12; i++) {
        XXMnemonicWordTextFieldView *textFieldView = self.textFieldArray[i];
        if (i < self.inputWordsArray.count) {
            NSString *word = self.inputWordsArray[i];
            textFieldView.textField.text = word;
            if ([self.wordsArray containsObject:word]) {
                textFieldView.type = MnemonicWordTextFieldViewType_Normal;
            } else {
                textFieldView.type = MnemonicWordTextFieldViewType_Wrong;
            }
            textFieldView.hidden = NO;
        } else {
            textFieldView.hidden = YES;
            textFieldView.textField.text = @"";
            textFieldView.type = MnemonicWordTextFieldViewType_Wrong;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "]) {
        if (self.inputWordsArray.count < 12) {
            [self.inputWordsArray replaceObjectAtIndex:[self getInputIndex:textField] withObject:textField.text];
            [self.inputWordsArray addObject:@""];
            [self refreshWords];
            [self setFirstResponder:[self getInputIndex:textField] + 1];
        } else if (self.inputWordsArray.count == 12) {
            [self.inputWordsArray replaceObjectAtIndex:[self getInputIndex:textField] withObject:textField.text];
            [self refreshWords];
            [self setFirstResponder:[self getInputIndex:textField] + 1];
        }
        return NO;
    } else {
        return YES;
    }
}

- (void)textFieldChanged:(UITextField *)textField {
    NSArray *separatedArr = [textField.text componentsSeparatedByString:@" "];
    if (separatedArr.count > 1) {
        for (int i = 0; i < separatedArr.count; i++) {
            if (i == 0) {
                [self.inputWordsArray replaceObjectAtIndex:[self getInputIndex:textField] withObject:separatedArr[i]];
            } else {
                [self.inputWordsArray addObject:separatedArr[i]];
            }
        }
        [self refreshWords];
    }
    [self.inputWordsArray replaceObjectAtIndex:[self getInputIndex:textField] withObject:textField.text];
    //判断是否符合规则
    [self reloadBtnState];

}

- (void)deleteBackward:(UITextField *)textField {
    if (IsEmpty(textField.text)) {
        for (XXMnemonicWordTextFieldView *view in self.textFieldArray) {
            if (view.textField == textField) {
                if (view.index == 0 && self.inputWordsArray.count == 1) {
                    return;
                } else {
                    [self.inputWordsArray removeObjectAtIndex:view.index];
                    [self refreshWords];
                    [self setFirstResponder:view.index - 1];
                }
            }
        }
    }
    [self reloadBtnState];
}

- (void)setFirstResponder:(NSInteger)index {
    if (index > 12 || index < 0) {
        return;
    }
    XXMnemonicWordTextFieldView *view = self.textFieldArray[index];
    [view.textField becomeFirstResponder];
}

- (NSInteger)getInputIndex:(UITextField *)textField {
    for (XXMnemonicWordTextFieldView *view in self.textFieldArray) {
        if (view.textField == textField) {
            return view.index;
        }
    }
    return 0;
}

- (void)reloadBtnState {
    if (self.inputWordsArray.count > 11) {
        self.createBtn.enabled = YES;
        self.createBtn.backgroundColor = kPrimaryMain;
    } else {
        self.createBtn.enabled = NO;
        self.createBtn.backgroundColor = kGray100;
    }
}

- (void)nextStepAction {
    NSMutableString *mnemonicPhrase = [[NSMutableString alloc] init];
    for (int i = 0; i < 12; i++) {
        if (i == 0) {
            mnemonicPhrase = [[NSMutableString alloc] initWithString:self.inputWordsArray[i]];
        } else {
            [mnemonicPhrase appendString:[NSString stringWithFormat:@" %@",self.inputWordsArray[i]]];
        }
    }
    Account *account = [Account accountWithMnemonicPhrase:mnemonicPhrase];
    if (account) {
        //判断是否重复导入
        if (KUser.accounts) {
            for (XXAccountModel *model in KUser.accounts) {
                if ([model.address isEqualToString:account.BHAddress]) {
                    Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"MnemonicPhraseRepetition") duration:kAlertDuration completion:^{
                    }];
                    [alert showAlert];
                    return;
                }
            }
        }
        KUser.localPhraseString = mnemonicPhrase;
        KUser.localPrivateKey = @"";
        XXCreateWalletVC *createVC = [[XXCreateWalletVC alloc] init];
        [self.navigationController pushViewController:createVC animated:YES];
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"MnemonicPhraseOutOfOrder") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
    }
}


- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"ImportMnemonicPhraseTip") font:kFont(15) width:kScreen_Width - K375(32)];
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), kNavHeight, kScreen_Width - K375(32), height) text:LocalizedString(@"ImportMnemonicPhraseTip") font:kFont(15) textColor:kGray500 alignment:NSTextAlignmentLeft];
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

- (NSMutableArray *)textFieldArray {
    if (!_textFieldArray) {
        _textFieldArray = [[NSMutableArray alloc] init];
    }
    return _textFieldArray;
}

- (NSMutableArray *)wordsArray {
    if (!_wordsArray) {
        _wordsArray = [[NSMutableArray alloc] init];
        const char* const *wordlist = mnemonic_wordlist();
        int i = 0;
        while (YES) {
            const char *word = wordlist[i++];
            if (!word) { break; }
            [_wordsArray addObject:[NSString stringWithUTF8String:word]];
        }
    }
    return _wordsArray;
}

- (NSMutableArray *)inputWordsArray {
    if (!_inputWordsArray) {
        _inputWordsArray = [[NSMutableArray alloc] init];
        [_inputWordsArray addObject:@""];
    }
    return _inputWordsArray;
}

@end
