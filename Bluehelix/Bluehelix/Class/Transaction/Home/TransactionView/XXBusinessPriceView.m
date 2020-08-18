//
//  XXBusinessPriceView.m
//  Bhex
//
//  Created by Bhex on 2018/9/5.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXBusinessPriceView.h"

@interface XXBusinessPriceView () <UITextFieldDelegate>

/** 是否处于长按状态 */
@property (assign, nonatomic) BOOL isLongPressStatus;

@end


@implementation XXBusinessPriceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kViewBackgroundColor;
        
        [self addSubview:self.tokenNameLabel];
        [self addSubview:self.textField];
        [self addSubview:self.lineView];
        [self addSubview:self.reduceButton];
        [self addSubview:self.lineTwoView];
        [self addSubview:self.addButton];
        [self addSubview:self.marketPriceLable];
        
        self.tokenNameLabel.hidden = YES;
        
        MJWeakSelf
        [self whenTapped:^{
            
        }];
    }
    return self;
}

#pragma mark - 1. +按钮事件
- (void)addButtonClick {
    //TODO
//    NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:self.textField.text];
//    NSDecimalNumber *number2 = [NSDecimalNumber decimalNumberWithString:KTrade.currentModel.minPricePrecision];
//    NSString *textString = [[number1 decimalNumberByAdding:number2] stringValue];
//    self.textField.text = [KDecimal decimalNumber:textString RoundingMode:NSRoundDown scale:[KDecimal scale:KTrade.currentModel.minPricePrecision]];
//    if (self.priceValueChange) {
//        self.priceValueChange();
//    }
//    if (self.isLongPressStatus) {
//        [self performSelector:@selector(addButtonClick) withObject:nil afterDelay:0.1];
//    }
}

#pragma mark - 2. -按钮事件
- (void)reduceButtonClick {
    //TODO
//    NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:self.textField.text];
//    NSDecimalNumber *number2 = [NSDecimalNumber decimalNumberWithString:KTrade.currentModel.minPricePrecision];
//    NSString *textString = [[number1 decimalNumberBySubtracting:number2] stringValue];
//
//
//    if ([textString doubleValue] < [KTrade.currentModel.minPricePrecision doubleValue]) {
//        return;
//    }
//    self.textField.text = [KDecimal decimalNumber:textString RoundingMode:NSRoundDown scale:[KDecimal scale:KTrade.currentModel.minPricePrecision]];
//    if (self.priceValueChange) {
//        self.priceValueChange();
//    }
//    if (self.isLongPressStatus) {
//        [self performSelector:@selector(reduceButtonClick) withObject:nil afterDelay:0.1];
//    }
}

#pragma mark - 3. + 按钮长按手势方法
- (void)addButtonLongPressGestureRecognized:(UILongPressGestureRecognizer *)sender {
    UIGestureRecognizerState state = sender.state;
    switch (state) {
            // 已经开始按下
        case UIGestureRecognizerStateBegan:
        {
            self.isLongPressStatus = YES;
            [self addButtonClick];
        }
            // 移动过程中
        case UIGestureRecognizerStateChanged:
            break;
            // 长按手势取消状态
        default: {
            [[self class] cancelPreviousPerformRequestsWithTarget:self];
            self.isLongPressStatus = NO;
            break;
        }
    }
    
}

#pragma mark - 4. - 按钮长按手势方法
- (void)reduceButtonLongPressGestureRecognized:(UILongPressGestureRecognizer *)sender {
    UIGestureRecognizerState state = sender.state;
    switch (state) {
            // 已经开始按下
        case UIGestureRecognizerStateBegan:
        {
            self.isLongPressStatus = YES;
            [self reduceButtonClick];
        }
            // 移动过程中
        case UIGestureRecognizerStateChanged:
            break;
            // 长按手势取消状态
        default: {
            [[self class] cancelPreviousPerformRequestsWithTarget:self];
            self.isLongPressStatus = NO;
            break;
        }
    }
}

#pragma mark - || 懒加载
/** 输入框 */
- (XXFloadtTextField *)textField {
    if (_textField == nil) {
        _textField = [[XXFloadtTextField alloc] initWithFrame:CGRectMake(K375(4), 0, self.width - K375(40), self.height)];
        _textField.textColor = kDark100;
        _textField.font = kFontBold(13.0f);
        _textField.delegate = self;
        _textField.placeholder = LocalizedString(@"Price");
        _textField.placeholderColor = kDark50;
    }
    return _textField;
}

- (XXLabel *)tokenNameLabel {
    if (_tokenNameLabel == nil) {
        _tokenNameLabel = [XXLabel labelWithFrame:CGRectMake(self.width - K375(88), 0, K375(80), self.height) text:@"" font:kFont14 textColor:kDark50 alignment:NSTextAlignmentRight];
    }
    return _tokenNameLabel;
}

/** 分割线 */
- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.width - K375(66), 0, K375(1), self.height)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

/** - 按钮 */
- (XXButton *)reduceButton {
    if (_reduceButton == nil) {
        MJWeakSelf
        _reduceButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.lineView.frame), 0, K375(32), self.height) block:^(UIButton *button) {
            [weakSelf reduceButtonClick];
        }];
        [_reduceButton setImage:[UIImage textImageName:@"price_less"] forState:UIControlStateNormal];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(reduceButtonLongPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.4;
        [_reduceButton addGestureRecognizer:longPress];
    }
    return _reduceButton;
}

/** 分割线2 */
- (UIView *)lineTwoView {
    if (_lineTwoView == nil) {
        _lineTwoView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.reduceButton.frame), (self.height - 12.0)/2.0, K375(1), 12)];
        _lineTwoView.backgroundColor = kDark10;
    }
    return _lineTwoView;
}

/** + 按钮 */
- (XXButton *)addButton {
    if (_addButton == nil) {
        MJWeakSelf
        _addButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.lineTwoView.frame), 0, K375(32), self.height) block:^(UIButton *button) {
            [weakSelf addButtonClick];
        }];
        [_addButton setImage:[UIImage textImageName:@"price_add"] forState:UIControlStateNormal];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addButtonLongPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.4;
        [_addButton addGestureRecognizer:longPress];
    }
    return _addButton;
}

- (XXLabel *)marketPriceLable {
    if (_marketPriceLable == nil) {
        
        _marketPriceLable = [XXLabel labelWithFrame:self.bounds text:LocalizedString(@"TheBestMarketPrice") font:kFontBold14 textColor:kDark100 alignment:NSTextAlignmentCenter];
        _marketPriceLable.backgroundColor = kGrayColor;
        _marketPriceLable.userInteractionEnabled = YES;
        _marketPriceLable.hidden = YES;
    }
    return _marketPriceLable;
}


@end
