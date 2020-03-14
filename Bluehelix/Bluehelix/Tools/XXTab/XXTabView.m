//
//  XXTabView.m
//  Bhex
//
//  Created by Bhex on 2018/9/17.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXTabView.h"

@interface XXTabView ()

/** 当前被选中的按钮 */
@property (strong, nonatomic) UIButton *currentButton;

/** 按钮数组 */
@property (strong, nonatomic) NSMutableArray *buttonsArray;

/** 底部线条 */
@property (strong, nonatomic) UIView *lowLineView;

/** 滚动式图 */
@property (strong, nonatomic) UIScrollView *scrollView;

/** 指示线 */
@property (strong, nonatomic) UIView *indexLineView;

@end

@implementation XXTabView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.lowLineView];
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.indexLineView];
    }
    return self;
}

#pragma mark - 1. 按钮标题数组赋值
- (void)setButtonTitlesArray:(NSMutableArray *)buttonTitlesArray {
    _buttonTitlesArray = buttonTitlesArray;
    [self setupButtonsUI];
}

#pragma mark - 2. 初始化所有按钮
- (void)setupButtonsUI {
    
    if (self.buttonPadding == 0) {
        self.buttonPadding = K375(40);
    }
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, self.leftPadding, 0, 0);
    
    CGFloat leftX = 0;
    CGFloat buttonWidth = 0;
    self.buttonsArray = [NSMutableArray array];
    for (NSInteger i=0; i < self.buttonTitlesArray.count; i ++) {
        NSString *buttonTitle = self.buttonTitlesArray[i];
        buttonWidth = [NSString widthWithText:buttonTitle font:kFontBold16] + self.buttonPadding;
        UIButton *itemButton = [[UIButton alloc] initWithFrame:CGRectMake(leftX, 0, buttonWidth, self.height)];
        itemButton.titleLabel.font = kFontBold16;
        [itemButton setTitleColor:kDark100 forState:UIControlStateNormal];
        [itemButton setTitleColor:kBlue100 forState:UIControlStateSelected];
        [itemButton setTitle:buttonTitle forState:UIControlStateNormal];
        itemButton.tag = i;
        [itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsArray addObject:itemButton];
        [self.scrollView addSubview:itemButton];
        leftX += buttonWidth;
        if (i == 0) {
            self.currentButton = itemButton;
            itemButton.selected = YES;
            self.indexLineView.width = buttonWidth - self.buttonPadding + K375(10);
            self.indexLineView.centerX = itemButton.centerX;
            self.lowLineView.left = self.leftPadding + self.buttonPadding/2 - 5;
            self.lowLineView.width = self.width - self.lowLineView.left;
        }
    }
}

#pragma mark - 3. 按钮点击事件
- (void)itemButtonClick:(UIButton *)sender {
    if (sender.tag == self.currentButton.tag) {
        return;
    }
    
    self.currentButton.selected = NO;
    sender.selected = YES;
    self.currentButton = sender;
    [UIView animateWithDuration:0.25f animations:^{
        self.indexLineView.width = sender.width - 30;
        self.indexLineView.centerX = sender.centerX;
    }];
    
    if ([self.delegate respondsToSelector:@selector(tabViewDidSelectItemIndex:name:)]) {
        [self.delegate tabViewDidSelectItemIndex:sender.tag name:self.buttonTitlesArray[sender.tag]];
    }
}

#pragma mark - 4. 设置索引按钮
- (void)setIndexButton:(NSInteger)indexButton {
    
    if (_indexButton == indexButton) {
        return;
    }
    _indexButton = indexButton;
    
    self.currentButton.selected = NO;
    self.currentButton = self.buttonsArray[_indexButton];
    self.currentButton.selected = YES;
    [UIView animateWithDuration:0.25f animations:^{
        self.indexLineView.width = self.currentButton.width - 30;
        self.indexLineView.centerX = self.currentButton.centerX;
    }];
}

#pragma mark - || 懒加载
/** 按钮数组 */
- (NSArray *)buttonsArrayAtIndexes:(NSIndexSet *)indexes {
    if (_buttonsArray == nil) {
        _buttonsArray = [NSMutableArray array];
    }
    return _buttonsArray;
}

/** 底部线条 */
- (UIView *)lowLineView {
    if (_lowLineView == nil) {
        _lowLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
        _lowLineView.backgroundColor = KLine_Color;
    }
    return _lowLineView;
}

/** 滚动式图 */
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

/** 指示线 */
- (UIView *)indexLineView {
    if (_indexLineView == nil) {
        _indexLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.height - 1, 0, 1)];
        _indexLineView.backgroundColor = kBlue100;
    }
    return _indexLineView;
}

@end
