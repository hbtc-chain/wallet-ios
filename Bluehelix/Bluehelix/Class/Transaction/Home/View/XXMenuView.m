//
//  XXMenuView.m
//  Bhex
//
//  Created by Bhex on 2019/1/22.
//  Copyright © 2019年 Bhex. All rights reserved.
//

#import "XXMenuView.h"

@interface XXMenuView ()

/** 滚动式图 */
@property (strong, nonatomic) UIScrollView *scrollView;

/** 按钮数组 */
@property (strong, nonatomic) NSMutableArray *buttonsArray;

/** 当前被选中的按钮 */
@property (strong, nonatomic) UIButton *selectButton;

@end

@implementation XXMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.lowLine];
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.lineView];
    }
    return self;
}

#pragma mark - 1. 数组项目赋值
- (void)setNamesArray:(NSMutableArray *)namesArray {
    
    _namesArray = namesArray;
    
    if (!self.selectColor) {
        self.selectColor = kBlue100;
    }
    
    if (!self.normalColor) {
        self.normalColor = kDark100;
    }
    
    if (!self.maxFont) {
        self.maxFont = kFontBold16;
        self.minFont = kFontBold14;
    }
    
    if (self.buttonsArray) {
        for (NSInteger i=0; i < self.buttonsArray.count; i ++) {
            XXButton *buttion = self.buttonsArray[i];
            [buttion removeFromSuperview];
        }
        [self.buttonsArray removeAllObjects];
    } else {
        self.buttonsArray = [NSMutableArray array];
    }
    
    CGFloat leftX = 0;
    for (NSInteger i=0; i < _namesArray.count; i ++) {
        
        NSString *btnTitle = _namesArray[i];
        CGFloat itemWidth = [NSString widthWithText:btnTitle font:self.minFont] + KSpacing*2;
        if ([btnTitle isEqualToString:@"自选"] ) {
            itemWidth = 24 + KSpacing*2;
        }
        
        MJWeakSelf
        XXButton *itemButton = [XXButton buttonWithFrame:CGRectMake(leftX, 0, itemWidth, self.scrollView.height - 3) title:btnTitle font:self.minFont titleColor:self.normalColor block:^(UIButton *button) {
            [weakSelf itemButtonClick:button];
        }];
        itemButton.tag = i;
        [itemButton setTitleColor:self.selectColor forState:UIControlStateSelected];
        [self.scrollView addSubview:itemButton];
        [self.buttonsArray addObject:itemButton];
        if ([btnTitle isEqualToString:@"自选"] ) {
            [itemButton setTitle:@"" forState:UIControlStateNormal];
            [itemButton setImage:[UIImage textImageName:@"save_no"] forState:UIControlStateNormal];
            [itemButton setImage:[UIImage mainImageName:@"save_select"] forState:UIControlStateSelected];
        }
        
        if (i == 0) {
            self.indexClass = 0;
            itemButton.titleLabel.font = self.maxFont;
            self.selectButton = itemButton;
            self.selectButton.selected = YES;
            
            self.lineView.left = KSpacing;
            self.lineView.width = itemWidth - KSpacing*2;
            self.lineView.hidden = NO;
        }
        
        leftX += itemWidth;
    }
    
    self.scrollView.contentSize = CGSizeMake(leftX, 0);
    if (leftX < self.width) {
        
        if (self.alignment == NSTextAlignmentLeft) {
            self.scrollView.left = 0;
            self.scrollView.width = leftX;
        } else if (self.alignment == NSTextAlignmentCenter) {
            self.scrollView.left = (self.width - leftX) / 2;
            self.scrollView.width = leftX;
        } else {
            self.scrollView.left = self.width - leftX;
            self.scrollView.width = leftX;
        }
    } else {
        self.scrollView.left = 0;
        self.scrollView.width = self.width;
    }
}

#pragma mark - 2. 分类按钮点击事件
- (void)itemButtonClick:(UIButton *)sender {
    
    if ( sender.tag != self.indexClass ) {
        
        self.indexClass = sender.tag;
        if ([self.delegate respondsToSelector:@selector(menuViewItemDidselctIndex:name:)]) {
            [self.delegate menuViewItemDidselctIndex:self.indexClass name:self.namesArray[self.indexClass]];
        }
    }
}

#pragma mark - 3. 按钮状态 和 滚动范围的控制
- (void)selectIndexItem:(NSInteger)indexItem {
    
    XXButton *selectButton = self.buttonsArray[indexItem];
    if ( indexItem != self.indexClass ) {
        
        CGFloat contentWidth = self.scrollView.contentSize.width;
        if (contentWidth > self.scrollView.width) {
            
            CGFloat setOffX = selectButton.centerX - self.width/2.0;
            if (setOffX + self.scrollView.width > contentWidth) {
                setOffX = contentWidth - self.width;
            }
            if (setOffX < 0) {
                setOffX = 0;
            }
            [self.scrollView setContentOffset:CGPointMake(setOffX, 0) animated:YES];
        }
        
        // 2. 索引值赋值
        self.indexClass = indexItem;
        
        // 3. 刷新表格
        self.selectButton.selected = NO;
        self.selectButton.titleLabel.font = self.minFont;
        UIButton *currentButton = self.buttonsArray[self.indexClass];
        currentButton.selected = YES;
        currentButton.titleLabel.font = self.maxFont;
        self.selectButton = currentButton;
    }
}

- (void)setChangeToIndex:(CGFloat)changeToIndex {
    
    _changeToIndex = changeToIndex;
    [self selectIndexItem:(NSInteger)(_changeToIndex + 0.5)];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.lineView.left = self.selectButton.left + KSpacing;
        self.lineView.width = self.selectButton.width - KSpacing*2;
    }];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    
    XXButton *selectButton = self.buttonsArray[selectIndex];
    CGFloat contentWidth = self.scrollView.contentSize.width;
    if (contentWidth > self.scrollView.width) {
        
        CGFloat setOffX = selectButton.centerX - self.width/2.0;
        if (setOffX + self.scrollView.width > contentWidth) {
            setOffX = contentWidth - self.width;
        }
        if (setOffX < 0) {
            setOffX = 0;
        }
        [self.scrollView setContentOffset:CGPointMake(setOffX, 0) animated:YES];
    }
    
    // 2. 索引值赋值
    self.indexClass = _selectIndex;
    
    // 3. 刷新字体颜色
    self.selectButton.selected = NO;
    self.selectButton.titleLabel.font = self.minFont;
    UIButton *currentButton = self.buttonsArray[self.indexClass];
    currentButton.selected = YES;
    currentButton.titleLabel.font = self.maxFont;
    self.selectButton = currentButton;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.lineView.left = self.selectButton.left + KSpacing;
        self.lineView.width = self.selectButton.width - KSpacing*2;
    }];
}

#pragma mark - || 懒加载
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.layer.masksToBounds = NO;
        _scrollView.layer.masksToBounds = YES;
    }
    return _scrollView;
}

/** 指示线 */
- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 3, 10, 3)];
        _lineView.backgroundColor = kBlue100;
    }
    return _lineView;
}

/** 横向分割线 */
- (UIView *)lowLine {
    if (_lowLine == nil) {
        _lowLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
        _lowLine.backgroundColor = KLine_Color;
    }
    return _lowLine;
}


@end
