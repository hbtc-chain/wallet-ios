//
//  XXOrderTypeView.m
//  Bhex
//
//  Created by Bhex on 2018/10/21.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXOrderTypeView.h"

@interface XXOrderTypeView ()


/** 当前委托 */
@property (strong, nonatomic) XXButton *currentButton;

/** 历史委托 */
@property (strong, nonatomic) XXButton *historyButton;

/** 全部取消 */
@property (strong, nonatomic) XXButton *allCancelButton;

/** 底部线条 */
@property (strong, nonatomic) UIView *lineView;

/** 线条 */
@property (strong, nonatomic) UIView *indexLine;

@end

@implementation XXOrderTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.indexType = 0;
        [self addSubview:self.currentButton];
        [self addSubview:self.historyButton];
        [self addSubview:self.allCancelButton];
        [self addSubview:self.lineView];
        [self addSubview:self.indexLine];
    }
    return self;
}

#pragma mark - 2. 按钮点击事件
- (void)buttonClick:(UIButton *)button {
    if (self.indexType == button.tag) {
        return;
    }
    self.indexType = button.tag;
    if (self.selectOrderTypeBlock) {
        self.selectOrderTypeBlock(self.indexType);
    }
}

#pragma mark - 2. 按钮类型
- (void)setChangeIndex:(NSInteger)changeIndex {
    
    _changeIndex = changeIndex;
    UIButton *button = _changeIndex == 0 ? self.currentButton : self.historyButton;
    CGFloat width = button.titleLabel.width;
    CGFloat lineLeftX = button.centerX - width / 2.0f;
    [UIView animateWithDuration:0.3 animations:^{
        self.indexLine.left = lineLeftX;
        self.indexLine.width = width;
    }];
    button.selected = YES;
    self.indexType = changeIndex;
    if (button.tag == 0) { // 当前委托
        self.allCancelButton.hidden = NO;
        self.historyButton.selected = NO;
    } else if (button.tag == 1) { // 历史委托
        self.allCancelButton.hidden = YES;
        self.currentButton.selected = NO;
    }
}

#pragma mark - 懒加载
/** 当前委托 */
- (XXButton *)currentButton {
    if (_currentButton == nil) {
        MJWeakSelf
        _currentButton = [XXButton buttonWithFrame:CGRectMake(0, 0, KSpacing*2 + [NSString widthWithText:LocalizedString(@"OpenOrder") font:kFontBold16], self.height - 3) title:LocalizedString(@"OpenOrder") font:kFontBold16 titleColor:kDark100 block:^(UIButton *button) {
            [weakSelf buttonClick:button];
        }];
        [_currentButton setTitleColor:kBlue100 forState:UIControlStateSelected];
        _currentButton.selected = YES;
        _currentButton.tag = 0;
    }
    return _currentButton;
}

/** 历史委托 */
- (XXButton *)historyButton {
    if (_historyButton == nil) {
        MJWeakSelf
        _historyButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.currentButton.frame), 0, KSpacing*2 + [NSString widthWithText:LocalizedString(@"OrderHistory") font:kFontBold16], self.height - 3) title:LocalizedString(@"OrderHistory") font:kFontBold16 titleColor:kDark100 block:^(UIButton *button) {
            [weakSelf buttonClick:button];
        }];
        _historyButton.tag = 1;
        [_historyButton setTitleColor:kBlue100 forState:UIControlStateSelected];
    }
    return _historyButton;
}

/** 全部取消 CancelAllOrders */
- (XXButton *)allCancelButton {
    if (_allCancelButton == nil) {
        MJWeakSelf
        CGFloat btnWidth = K375(10) + [NSString widthWithText:LocalizedString(@"CancelAllOrders")  font:kFontBold12];
        _allCancelButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - btnWidth - K375(24), (self.height - 3 - 24)/2, btnWidth, 24) title:LocalizedString(@"CancelAllOrders") font:kFontBold12 titleColor:kDark100 block:^(UIButton *button) {
            if (weakSelf.allOrdersCancelBlock) {
                weakSelf.allOrdersCancelBlock();
            }
        }];
        _allCancelButton.backgroundColor = kBlue10;
        _allCancelButton.layer.cornerRadius = 3;
        _allCancelButton.layer.masksToBounds = YES;
    }
    return _allCancelButton;
}

/** 底部线条 */
- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, kScreen_Width, 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

/** 线条 */
- (UIView *)indexLine {
    if (_indexLine == nil) {
        
        CGFloat width = [NSString widthWithText:LocalizedString(@"OpenOrder") font:kFontBold16];
        _indexLine = [[UIView alloc] initWithFrame:CGRectMake(KSpacing, self.height - 3, width, 3)];
        _indexLine.backgroundColor = kBlue100;
    }
    return _indexLine;
}

@end
