//
//  XXBuySellButton.m
//  Bhex
//
//  Created by Bhex on 2018/9/5.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXBuySellButton.h"

@interface XXBuySellButton ()

/** 选中视图 */
@property (strong, nonatomic) UIView *selectView;

@end

@implementation XXBuySellButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kViewBackgroundColor;
        [self addSubview:self.buyButton];
        [self addSubview:self.sellButton];
        [self addSubview:self.selectView];
    }
    return self;
}

#pragma mark - 1. 按钮点击事件
- (void)buttonClick:(UIButton *)sender {
    if (sender.tag == 0) {
        [_buyButton setTitleColor:kGreen100 forState:UIControlStateNormal];
        [_sellButton setTitleColor:kDark100 forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2f animations:^{
            self.selectView.left = 0;
            self.selectView.layer.borderColor = (kGreen100).CGColor;
        }];
    } else {
        [_buyButton setTitleColor:kDark100 forState:UIControlStateNormal];
        [_sellButton setTitleColor:kRed100 forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2f animations:^{
            self.selectView.left = self.width/2.0f;
            self.selectView.layer.borderColor = (kRed100).CGColor;
        }];
    }
    
    if (self.buySellBlock) {
        self.buySellBlock(sender.tag);
    }
}

- (void)setIndexType:(NSInteger)indexType {
    if (indexType == 0) {
        _buyButton.layer.borderColor = (kGreen100).CGColor;
        _sellButton.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        _buyButton.layer.borderColor = [UIColor clearColor].CGColor;
        _sellButton.layer.borderColor = (kRed100).CGColor;
    }
}

- (void)changeIndex:(NSInteger)index {
    if (index == 0) {
        UIColor *selectColor = self.colorIsNegative ? kRed100 : kGreen100;
        [_buyButton setTitleColor:selectColor forState:UIControlStateNormal];
        [_sellButton setTitleColor:kDark100 forState:UIControlStateNormal];
        self.selectView.left = 0;
        self.selectView.layer.borderColor = (selectColor).CGColor;
    } else {
        UIColor *selectColor = self.colorIsNegative ? kGreen100 : kRed100;
        [_buyButton setTitleColor:kDark100 forState:UIControlStateNormal];
        [_sellButton setTitleColor:selectColor forState:UIControlStateNormal];
        self.selectView.left = self.width/2.0f;
        self.selectView.layer.borderColor = (selectColor).CGColor;
    }
}

#pragma mark - || 懒加载
- (XXButton *)buyButton {
    if (_buyButton == nil) {
        MJWeakSelf
        _buyButton = [XXButton buttonWithFrame:CGRectMake(0, 0, self.width/2, self.height) title:LocalizedString(@"BUY") font:kFontBold14 titleColor:kGreen100 block:^(UIButton *button) {
            [weakSelf buttonClick:button];
        }];
        _buyButton.tag = 0;
    }
    return _buyButton;
}

- (XXButton *)sellButton {
    if (_sellButton == nil) {
        MJWeakSelf
        _sellButton = [XXButton buttonWithFrame:CGRectMake(self.width/2, 0, self.width/2, self.height) title:LocalizedString(@"SELL") font:kFontBold14 titleColor:kDark100 block:^(UIButton *button) {
            [weakSelf buttonClick:button];
        }];
        _sellButton.tag = 1;
    }
    return _sellButton;
}

- (UIView *)selectView {
    if (_selectView == nil) {
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width/2, self.height)];
        _selectView.layer.cornerRadius = 3;
        _selectView.layer.borderColor = (kGreen100).CGColor;
        _selectView.layer.borderWidth = 1;
        _selectView.layer.masksToBounds = YES;
        _selectView.userInteractionEnabled = NO;
    }
    return _selectView;
}
@end
