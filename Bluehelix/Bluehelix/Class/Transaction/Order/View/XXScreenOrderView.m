//
//  XXScreenOrderView.m
//  Bhex
//
//  Created by BHEX on 2018/7/23.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXScreenOrderView.h"

#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

@interface XXScreenOrderView () <UITextFieldDelegate>

/** 币种 */
@property (strong, nonatomic) NSString *baseToken;

/** 计价单位 */
@property (strong, nonatomic) NSString *quoteToken;

/** 订单状态 */
@property (strong, nonatomic) NSString *side;

/** 蒙版按钮 */
@property (strong, nonatomic) XXButton *mengButton;

/** 背景图片 */
@property (strong, nonatomic) UIImageView *bgImageView;

/** 币对 */
@property (strong, nonatomic) XXLabel *symbolLabel;

/** 左输入视图 */
@property (strong, nonatomic) UIView *leftView;

/** 左输入框 */
@property (strong, nonatomic) XXTextField *leftTextField;

/** 斜杠标签 */
@property (strong, nonatomic) XXLabel *lineLabel;

/** 右视图 */
@property (strong, nonatomic) UIView *rightView;

/** 右输入框 */
@property (strong, nonatomic) XXTextField *rightTextField;

/** 订单状态标签 */
@property (strong, nonatomic) XXLabel *statusNameLabel;

/** 买卖状态按钮数组 */
@property (strong, nonatomic) NSMutableArray *sideButtonsArray;

/** 底部线条 */
@property (strong, nonatomic) UIView *lowLineView;

/** 重置按钮 */
@property (strong, nonatomic) XXButton *reButton;

/** 完成按钮 */
@property (strong, nonatomic) XXButton *okButton;

@end

@implementation XXScreenOrderView

- (void)show {
 
    self.alpha = 1.0;
    self.mengButton.alpha = 0;
    self.bgImageView.top = -self.bgImageView.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgImageView.top = 0;
        self.mengButton.alpha = 1;
    } completion:^(BOOL finished) {
        self.isShowing = YES;
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.mengButton.alpha = 0;
        self.bgImageView.top = -self.bgImageView.height;
    } completion:^(BOOL finished) {
        self.alpha = 0.0;
        self.isShowing = NO;
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kViewBackgroundColor;
        self.baseToken = @"";
        self.quoteToken = @"";
        self.side = @"";
        [self setupUI];
        self.alpha = 0;
    }
    return self;
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    
    [self addSubview:self.mengButton];
    [self addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.symbolLabel];
    [self.bgImageView addSubview:self.leftView];
    [self.leftView addSubview:self.leftTextField];
    [self.bgImageView addSubview:self.lineLabel];
    [self.bgImageView addSubview:self.rightView];
    [self.rightView addSubview:self.rightTextField];
    [self.bgImageView addSubview:self.statusNameLabel];
    
    self.sideButtonsArray = [NSMutableArray array];
    CGFloat offetY = 130;
    NSArray *sideNamesArray = @[LocalizedString(@"All"), LocalizedString(@"Buy"), LocalizedString(@"Sell")];
    MJWeakSelf
    for (NSInteger i=0; i < 3; i ++) {
        XXButton *itemButton = [XXButton buttonWithFrame:CGRectMake(K375(24) + 109*i, offetY, 100, 30) title:sideNamesArray[i] font:kFont14 titleColor:kDark50 block:^(UIButton *button) {
            [weakSelf statusButtonClick:button];
        }];
        [itemButton setTitleColor:kBlue100 forState:UIControlStateSelected];
        [itemButton setBackgroundImage:[UIImage imageNamed:KUser.isNightType ? @"screen_n" : @"screen_n_0"] forState:UIControlStateNormal];
        [itemButton setBackgroundImage:[UIImage imageNamed:@"screen_s"] forState:UIControlStateSelected];
        itemButton.tag = i;
        if (i==0) {
            itemButton.selected = YES;
        }
        [self.bgImageView addSubview:itemButton];
        [self.sideButtonsArray addObject:itemButton];
    }
    
    [self.bgImageView addSubview:self.lowLineView];
    [self.bgImageView addSubview:self.reButton];
    [self.bgImageView addSubview:self.okButton];
}

#pragma mark - 2. 状态按钮点击事件
- (void)statusButtonClick:(UIButton *)sender {
    if (sender.tag == 0) {
        self.side = @"";
    } else if (sender.tag == 1) {
        self.side = @"buy";
    } else {
        self.side = @"sell";
    }
    
    for (NSInteger i=0; i < self.sideButtonsArray.count; i ++) {
        UIButton *itemButton = self.sideButtonsArray[i];
        if (itemButton.tag == sender.tag) {
            itemButton.selected = YES;
        } else {
            itemButton.selected = NO;
        }
    }
}

#pragma mark - 4. 重置按钮点击事件
- (void)reButtonClick:(UIButton *)sender {
    
    for (NSInteger i=0; i < self.sideButtonsArray.count; i ++) {
        UIButton *itemButton = self.sideButtonsArray[i];
        if (itemButton.tag == 0) {
            itemButton.selected = YES;
        } else {
            itemButton.selected = NO;
        }
    }
    
    self.leftTextField.text = @"";
    self.rightTextField.text = @"";
    
    self.baseToken = @"";
    self.quoteToken = @"";
    self.side = @"";
}

#pragma mark - 5. 完成按钮点击事件
- (void)okButtonClick:(UIButton *)sender {

    [self endEditing:NO];
    if (self.leftTextField.text.length > 0) {
        self.baseToken = self.leftTextField.text;
    } else {
        self.baseToken = @"";
    }
    
    if (self.rightTextField.text.length > 0) {
        self.quoteToken = self.rightTextField.text;
    } else {
        self.quoteToken = @"";
    }
    
    [self dismiss];
    if (self.finishBlock) {
        self.finishBlock(self.baseToken, self.quoteToken, self.side);
    }
}

#pragma mark - 6. <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHA] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL isOk = [string isEqualToString:filtered];
    return isOk;
}

- (void)textFiledValueChange:(UITextField *)textField {
    textField.text = [textField.text uppercaseString];
}

#pragma mark - || 懒加载
/** 蒙版按钮 */
- (XXButton *)mengButton {
    if (_mengButton == nil) {
        MJWeakSelf
        _mengButton = [XXButton buttonWithFrame:self.bounds block:^(UIButton *button) {
            [weakSelf dismiss];
        }];
        _mengButton.backgroundColor = kDark20;
    }
    return _mengButton;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 225)];
        _bgImageView.backgroundColor = kViewBackgroundColor;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

/** 币对 */
- (XXLabel *)symbolLabel {
    if (_symbolLabel == nil) {
        _symbolLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), 0, 200, 40) text:LocalizedString(@"CoinPairs") font:kFont15 textColor:kDark100];
    }
    return _symbolLabel;
}

/** 左输入视图 */
- (UIView *)leftView {
    if (_leftView == nil) {
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.symbolLabel.frame), K375(148), 40)];
        _leftView.layer.cornerRadius = 3;
        _leftView.layer.borderColor = KLine_Color.CGColor;
        _leftView.layer.borderWidth = 1;
        _leftView.layer.masksToBounds = YES;
    }
    return _leftView;
}

- (XXTextField *)leftTextField {
    if (_leftTextField == nil) {
        _leftTextField = [[XXTextField alloc] initWithFrame:CGRectMake(10, 0, self.leftView.width - 20, self.leftView.height)];
        _leftTextField.delegate = self;
        _leftTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _leftTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _leftTextField.textColor = kDark100;
        _leftTextField.font = kFont15;
        [_leftTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
        _leftTextField.placeholder = LocalizedString(@"Coin");
        _leftTextField.placeholderColor = kDark50;
    }
    return _leftTextField;
}

/** 斜杠标签 */
- (XXLabel *)lineLabel {
    if (_lineLabel == nil) {
        _lineLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.leftView.frame), self.leftView.top, 31, self.leftView.height) text:@"/" font:kFont18 textColor:kDark100 alignment:NSTextAlignmentCenter];
    }
    return _lineLabel;
}

/** 右视图 */
- (UIView *)rightView {
    if (_rightView == nil) {
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lineLabel.frame), self.leftView.top, self.leftView.width, self.leftView.height)];
        _rightView.layer.cornerRadius = 3;
        _rightView.layer.borderColor = KLine_Color.CGColor;
        _rightView.layer.borderWidth = KLine_Height;
        _rightView.layer.masksToBounds = YES;
    }
    return _rightView;
}

/** 右输入框 */
- (XXTextField *)rightTextField {
    if (_rightTextField == nil) {
        _rightTextField = [[XXTextField alloc] initWithFrame:CGRectMake(10, 0, self.rightView.width - 20, self.rightView.height)];
        _rightTextField.delegate = self;
        _rightTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _rightTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _rightTextField.textColor = kDark100;
        _rightTextField.font = kFont15;
        [_rightTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
        _rightTextField.placeholder = LocalizedString(@"ChargeCoin");
        _rightTextField.placeholderColor = kDark50;
    }
    return _rightTextField;
}

/** 订单状态标签 */
- (XXLabel *)statusNameLabel {
    if (_statusNameLabel == nil) {
        _statusNameLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.leftView.frame) + 10, 200, 40) text:LocalizedString(@"OrderStatus") font:kFont15 textColor:kDark100];
    }
    return _statusNameLabel;
}

- (UIView *)lowLineView {
    if (_lowLineView == nil) {
        _lowLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 179, kScreen_Width, 1)];
        _lowLineView.backgroundColor = KLine_Color;
    }
    return _lowLineView;
}

/** 重置按钮 */
- (XXButton *)reButton {
    if (_reButton == nil) {
        MJWeakSelf
        _reButton = [XXButton buttonWithFrame:CGRectMake(0, 180, kScreen_Width/2, 45) title:LocalizedString(@"Reset") font:kFontBold14 titleColor:kDark50 block:^(UIButton *button) {
            [weakSelf reButtonClick:button];
        }];
    }
    return _reButton;
}

/** 完成按钮 */
- (XXButton *)okButton {
    if (_okButton == nil) {
        MJWeakSelf
        _okButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Width/2, self.reButton.top, kScreen_Width/2, self.reButton.height) title:LocalizedString(@"Done") font:kFontBold14 titleColor:kMainTextColor block:^(UIButton *button) {
            [weakSelf okButtonClick:button];
        }];
        _okButton.backgroundColor = kBlue100;
    }
    return _okButton;
}
@end
