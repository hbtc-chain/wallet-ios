//
//  XXVerifyMnemonicPhraseVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/09.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXVerifyMnemonicPhraseVC.h"
#import "XXMnemonicBtn.h"
#import "XXTabBarController.h"

@interface XXVerifyMnemonicPhraseVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *formView; //顶部表格
@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) NSMutableArray *selectedWordsArray; //选中的助记词数组
@property (nonatomic, strong) XXButton *backupBtn;
@property (nonatomic, assign) CGFloat contentHeight; //scrollView Height
@property (nonatomic, strong) NSArray *drawArray;
@end

@implementation XXVerifyMnemonicPhraseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = LocalizedString(@"VerifyMnemonicPhrase");
    self.drawArray = [self randomArray];
    [self.view addSubview:self.scrollView];
    [self buildUI];
}

- (void)buildUI {
    [self.scrollView addSubview:self.tipLabel];
    [self drawFormView]; //画顶部表格
    [self drawWords]; //画下边可选单词
    [self.scrollView addSubview:self.backupBtn];
    if (_contentHeight > self.scrollView.contentSize.height) {
        self.scrollView.contentSize = CGSizeMake(kScreen_Width, _contentHeight);
    }
}

- (void)reloadUI {
    [self.scrollView removeAllSubviews];
    [self buildUI];
}

- (void)drawFormView {
    NSString *phraseStr = KUser.rootAccount[@"mnemonicPhrase"];
    NSArray *phraseArr = [phraseStr componentsSeparatedByString:@" "];
    self.formView = [[UIView alloc] initWithFrame:CGRectMake(K375(16), self.tipLabel.bottom + K375(24), kScreen_Width - K375(32), K375(192))];
    self.formView.backgroundColor = kWhite100;
    self.formView.layer.borderColor = [KLine_Color CGColor];
    self.formView.layer.borderWidth = KLine_Height;
    self.formView.layer.cornerRadius = 2;
    self.formView.layer.masksToBounds = YES;
    [self.scrollView addSubview:self.formView];
    
    int Width = (kScreen_Width - K375(32))/3;
    int Height = K375(48);
    int Left = 0;
    int Top = 0;
    for (int i = 0; i < self.selectedWordsArray.count; i++) {
        Left = Width*(i%3);
        if (i % 3 == 0 && i != 0) {
            Top = Top + Height;
            Left = 0;
        }
        NSString *selectedWord = self.selectedWordsArray[i];
        XXMnemonicBtn *btn = [[XXMnemonicBtn alloc] initWithFrame:CGRectMake(Left, Top, Width, Height) order:[NSString stringWithFormat:@"%d",i+1] title:self.selectedWordsArray[i]];
        MJWeakSelf
        btn.clickBlock = ^(NSString * _Nonnull title) {
            [weakSelf.selectedWordsArray removeObject:title];
            [weakSelf reloadUI];
            NSLog(@"%@",weakSelf.selectedWordsArray);
        };
        if ([selectedWord isEqualToString:phraseArr[i]]) {
            btn.state = MnemonicBtnType_Normal;
        } else {
            btn.state = MnemonicBtnType_Wrong;
        }
        btn.backgroundColor = kWhite100;
        [self.formView addSubview:btn];
    }
    
    for (int i = 0; i < 3; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, K375(48) + i*K375(48) - 1, self.formView.width, KLine_Height)];
        lineView.backgroundColor = KLine_Color;
        [self.formView addSubview:lineView];
    }
    
    for (int i = 1; i < 3; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i*K375(115), 0, KLine_Height, self.formView.height)];
        lineView.backgroundColor = KLine_Color;
        [self.formView addSubview:lineView];
    }
}

- (void)drawWords {
    int HSpace = K375(16);
    int VSpace = K375(8);
    int Width = (kScreen_Width - 4*HSpace)/3;
    int Height = K375(48);
    int Left = HSpace;
    int Top = K375(30) + self.formView.bottom;
    for (int i = 0; i < self.drawArray.count; i++) {
        Left = HSpace + (HSpace+Width)*(i%3);
        if (i % 3 == 0 && i != 0) {
            Top = Top + Height + VSpace;
            Left = HSpace;
        }
        XXMnemonicBtn *btn = [[XXMnemonicBtn alloc] initWithFrame:CGRectMake(Left, Top, Width, Height) order:[NSString stringWithFormat:@"%d",i+1] title:self.drawArray[i]];
        MJWeakSelf
        btn.clickBlock = ^(NSString * _Nonnull title) {
            [weakSelf.selectedWordsArray addObject:title];
            [weakSelf reloadUI];
        };
        if ([self.selectedWordsArray containsObject:btn.title]) {
            btn.state = MnemonicBtnType_Selected;
        }
        btn.orderLabel.hidden = YES;
        [self.scrollView addSubview:btn];
    }
    _contentHeight = Top + Height;
}

- (NSArray *)randomArray {
    NSString *phraseStr = KUser.rootAccount[@"mnemonicPhrase"];
    NSArray *phraseArr = [phraseStr componentsSeparatedByString:@" "];
    phraseArr = [phraseArr sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    return phraseArr;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (XXLabel *)tipLabel {
    if (_tipLabel == nil) {
        CGFloat height = [NSString heightWithText:LocalizedString(@"VerifyMnemonicPhraseTip") font:kFont(15) width:kScreen_Width - K375(32)];
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), kNavHeight, kScreen_Width - K375(32), height) text:LocalizedString(@"VerifyMnemonicPhraseTip") font:kFont(15) textColor:kDark50 alignment:NSTextAlignmentLeft];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (XXButton *)backupBtn {
    if (!_backupBtn) {
        _backupBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), _contentHeight > kScreen_Height - kBtnHeight - K375(16) ? _contentHeight + 20 : kScreen_Height - kBtnHeight - K375(16), kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"StartBackup") font:kFontBold18 titleColor:kWhite100 block:^(UIButton *button) {
            KWindow.rootViewController = [[XXTabBarController alloc] init];
        }];
        _backupBtn.backgroundColor = kBlue100;
        _backupBtn.layer.cornerRadius = kBtnBorderRadius;
        _backupBtn.layer.masksToBounds = YES;
        _contentHeight = _contentHeight + kBtnHeight + 20 + K375(16);
    }
    return _backupBtn;
}

- (NSMutableArray *)selectedWordsArray {
    if (_selectedWordsArray == nil) {
        _selectedWordsArray = [[NSMutableArray alloc] init];
    }
    return _selectedWordsArray;
}

@end
