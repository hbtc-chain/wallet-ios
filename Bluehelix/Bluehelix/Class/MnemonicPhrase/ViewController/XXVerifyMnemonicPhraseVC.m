//
//  XXVerifyMnemonicPhraseVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/09.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXVerifyMnemonicPhraseVC.h"
#import "XXMnemonicBtn.h"
#import "XXTabBarController.h"
#import "AESCrypt.h"


@interface XXVerifyMnemonicPhraseVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *formView; //顶部表格
@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) NSMutableArray *selectedArray; //选中的助记词数组
@property (nonatomic, strong) XXButton *backupBtn;
@property (nonatomic, assign) CGFloat contentHeight; //scrollView Height
@property (nonatomic, strong) NSArray *drawArray; //随机改变顺序后
@property (nonatomic, strong) NSArray *phraseArray; //正确的顺序
@end

@implementation XXVerifyMnemonicPhraseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = LocalizedString(@"VerifyMnemonicPhrase");
    [self initPhraseData];
    [self.view addSubview:self.scrollView];
    [self buildUI];
}

- (void)initPhraseData {
    XXAccountModel *model = [[XXSqliteManager sharedSqlite] accountByAddress:KUser.address];
        NSString *sectureStr = model.mnemonicPhrase;
    NSString *phraseStr = [AESCrypt decrypt:sectureStr password:[NSString md5:self.text]];
    self.phraseArray = [phraseStr componentsSeparatedByString:@" "];
    self.drawArray = [self randomArray];
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

//上边选中的
- (void)drawFormView {
    self.formView = [[UIView alloc] initWithFrame:CGRectMake(K375(16), self.tipLabel.bottom + K375(24), kScreen_Width - K375(32), K375(192))];
    self.formView.backgroundColor = kWhiteColor;
    self.formView.layer.borderColor = [kE5EDFE CGColor];
    self.formView.layer.borderWidth = KLine_Height;
    self.formView.layer.cornerRadius = kBtnBorderRadius;
    self.formView.layer.masksToBounds = YES;
    [self.scrollView addSubview:self.formView];
    
    int rightCount = 0;
    int Width = (kScreen_Width - K375(32))/3;
    int Height = K375(48);
    int Left = 0;
    int Top = 0;
    for (int i = 0; i < self.selectedArray.count; i++) {
        Left = Width*(i%3);
        if (i % 3 == 0 && i != 0) {
            Top = Top + Height;
            Left = 0;
        }
        NSDictionary *selectedDic = self.selectedArray[i];
        XXMnemonicBtn *btn = [[XXMnemonicBtn alloc] initWithFrame:CGRectMake(Left, Top, Width, Height) order:[NSString stringWithFormat:@"%d",i+1] dic:self.selectedArray[i]];
        MJWeakSelf
        btn.clickBlock = ^(NSDictionary * _Nonnull dic, XXMnemonicBtn * _Nonnull btn) {
            [weakSelf.selectedArray removeObject:dic];
            [weakSelf reloadUI];
            NSLog(@"%@",weakSelf.selectedArray);
        };
        if ([selectedDic[@"word"] isEqualToString:self.phraseArray[i]]) {
            btn.state = MnemonicBtnType_Normal;
            rightCount ++;
        } else {
            btn.state = MnemonicBtnType_Wrong;
        }
        btn.backgroundColor = kWhiteColor;
        [self.formView addSubview:btn];
    }
    
    for (int i = 0; i < 3; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, K375(48) + i*K375(48) - 1, self.formView.width, KLine_Height)];
        lineView.backgroundColor = kE5EDFE;
        [self.formView addSubview:lineView];
    }
    
    for (int i = 1; i < 3; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i*K375(115), 0, KLine_Height, self.formView.height)];
        lineView.backgroundColor = kE5EDFE;
        [self.formView addSubview:lineView];
    }
    if (rightCount == self.phraseArray.count) {
        self.backupBtn.enabled = YES;
        self.backupBtn.backgroundColor = kPrimaryMain;
    } else {
        self.backupBtn.enabled = NO;
        self.backupBtn.backgroundColor = kGray100;
    }
}

// 下边待选择的
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
        NSDictionary *dic = self.drawArray[i];
        XXMnemonicBtn *btn = [[XXMnemonicBtn alloc] initWithFrame:CGRectMake(Left, Top, Width, Height) order:[NSString stringWithFormat:@"%d",i+1] dic:dic];
        MJWeakSelf
        btn.clickBlock = ^(NSDictionary * _Nonnull dic,XXMnemonicBtn *btn) {
            [weakSelf.selectedArray addObject:dic];
            [weakSelf reloadUI];
        };
        if ([self.selectedArray containsObject:btn.dic]) {
            btn.state = MnemonicBtnType_Selected;
        }

        btn.orderLabel.hidden = YES;
        [self.scrollView addSubview:btn];
    }
    _contentHeight = Top + Height;
}

- (NSArray *)randomArray {
    NSArray *phraseArr = self.phraseArray;
    NSMutableArray *array = [NSMutableArray array];
    phraseArr = [phraseArr sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    for (int i=0; i<phraseArr.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:phraseArr[i] forKey:@"word"];
        [dic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"id"];
        [array addObject:dic];
    }
    return array;
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
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), kNavHeight, kScreen_Width - K375(32), height) text:LocalizedString(@"VerifyMnemonicPhraseTip") font:kFont(15) textColor:kGray500 alignment:NSTextAlignmentLeft];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (XXButton *)backupBtn {
    if (!_backupBtn) {
        _backupBtn = [XXButton buttonWithFrame:CGRectMake(K375(16), _contentHeight > kScreen_Height - kBtnHeight - K375(16) ? _contentHeight + 20 : kScreen_Height - kBtnHeight - K375(16), kScreen_Width - K375(32), kBtnHeight) title:LocalizedString(@"StartBackup") font:kFontBold18 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [[XXSqliteManager sharedSqlite] updateAccountColumn:@"backupFlag" value:@1];
            [[XXSqliteManager sharedSqlite] updateAccountColumn:@"mnemonicPhrase" value:@""];
            KWindow.rootViewController = [[XXTabBarController alloc] init];
        }];
        _backupBtn.layer.cornerRadius = kBtnBorderRadius;
        _backupBtn.layer.masksToBounds = YES;
        _contentHeight = _contentHeight + kBtnHeight + 20 + K375(16);
        _backupBtn.backgroundColor = kGray100;
        _backupBtn.enabled = NO;
    }
    return _backupBtn;
}

- (NSMutableArray *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
}

@end
