//
//  XXVerifyMnemonicPhraseVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/09.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXVerifyMnemonicPhraseVC.h"
#import "XXMnemonicBtn.h"

@interface XXVerifyMnemonicPhraseVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *formView; //顶部表格
@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) NSMutableArray *selectedWordsArray; //选中的助记词数组

@property (nonatomic, strong) NSArray *testArray; //测试助记词
@end

@implementation XXVerifyMnemonicPhraseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.testArray = @[@"useful",@"key",@"amatur",@"22"];
    self.titleLabel.text = LocalizedString(@"VerifyMnemonicPhrase");
    [self.view addSubview:self.scrollView];
    [self buildUI];
}

- (void)buildUI {
    [self.scrollView addSubview:self.tipLabel];
    [self drawFormView]; //画顶部表格
    [self drawWords]; //画下边可选单词
}

- (void)reloadUI {
    [self.scrollView removeAllSubviews];
    [self buildUI];
}

- (void)drawFormView {
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
          if ([selectedWord isEqualToString:self.testArray[i]]) {
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
         
         for (int i = 0; i < 2; i++) {
             UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i*K375(115), K375(48) + i*K375(48), KLine_Height, self.formView.width)];
             lineView.backgroundColor = KLine_Color;
             [self.formView addSubview:lineView];
         }
}

- (void)drawWords {
    NSArray *phraseArr = @[@"useful",@"key",@"amatur",@"dearagon",@"shaft",@"orbit",@"series",@"slogan",@"float",@"cereal"];
       int HSpace = K375(16);
       int VSpace = K375(8);
       int Width = (kScreen_Width - 4*HSpace)/3;
       int Height = K375(48);
       int Left = HSpace;
       int Top = K375(30) + self.formView.bottom;
       for (int i = 0; i < phraseArr.count; i++) {
           Left = HSpace + (HSpace+Width)*(i%3);
           if (i % 3 == 0 && i != 0) {
               Top = Top + Height + VSpace;
               Left = HSpace;
           }
           XXMnemonicBtn *btn = [[XXMnemonicBtn alloc] initWithFrame:CGRectMake(Left, Top, Width, Height) order:[NSString stringWithFormat:@"%d",i+1] title:phraseArr[i]];
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
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(16), kNavHeight, kScreen_Width - K375(32), 30) text:LocalizedString(@"VerifyMnemonicPhraseTip") font:kFont(15) textColor:kDark50 alignment:NSTextAlignmentLeft];
    }
    return _tipLabel;
}

- (NSMutableArray *)selectedWordsArray {
    if (_selectedWordsArray == nil) {
        _selectedWordsArray = [[NSMutableArray alloc] init];
    }
    return _selectedWordsArray;
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
