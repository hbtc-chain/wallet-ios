//
//  XXValidatorToolBar.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/14.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXValidatorToolBar.h"

#define kButtonWidth 40
@interface XXValidatorToolBar ()
@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) UIButton *selectedButton;//选中的item
/**更改指示下标 约束*/
@property (nonatomic, assign) CGFloat priorityValue;
/** 指示线 */
@property (nonatomic, strong) UIImageView *indexLine;


@end
@implementation XXValidatorToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.indexLine];
        
        self.priorityValue = 50.0;
 
    }
    return self;
}
- (void)setItemsArray:(NSMutableArray *)itemsArray {
    _itemsArray = itemsArray;
    if (_itemsArray.count == 0) {
        return;
    }
    for (NSInteger i=0; i < _itemsArray.count; i ++) {
        //button 实例
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setTitle:_itemsArray[i] forState:UIControlStateNormal];
        [itemButton setTitleColor:kDark50 forState:UIControlStateNormal];
        [itemButton setTitleColor:kDark100 forState:UIControlStateSelected];
        [itemButton.layer setCornerRadius:2];
        //[itemButton setBackgroundImage:[UIImage createImageWithColor:kDark50] forState:UIControlStateNormal];
        //[itemButton setBackgroundImage:[UIImage createImageWithColor:KRGBA(44, 69, 241, 12)] forState:UIControlStateSelected];
        itemButton.tag = i;
        [itemButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        itemButton.adjustsImageWhenHighlighted = NO;
        itemButton.titleLabel.font = kFont15;
        if (self.indexBtn == i) {
            self.selectedButton = itemButton;
            itemButton.selected = YES;
        }
        [self.buttonArray addObject:itemButton];
        [self addSubview:itemButton];
    }

}

#pragma mark layout

- (void)layoutSubviews{

    [self.indexLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-4);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(3);
        make.centerX.mas_equalTo(self.selectedButton.mas_centerX).priorityLow(50);
    }];
//    if (self.buttonArray.count >0) {
//        [self.buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:32 leadSpacing:24 tailSpacing:24];
//        [self.buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.centerY.mas_equalTo(self.mas_centerY);
//            make.height.mas_equalTo(16);
//        }];
//    }
        
    UIButton *preButton ;
    for (int i =0; i<self.buttonArray.count; i++) {
        UIButton *v = self.buttonArray[i];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            if (preButton) {
                make.width.height.centerY.equalTo(preButton);
                make.left.equalTo(preButton.mas_right).offset(16);

            }
            else {//first one
                make.left.equalTo(self).offset(K375(24));
                make.width.mas_equalTo(kButtonWidth);
                make.top.mas_equalTo(12);
                make.height.mas_equalTo(16);
            }
            
        }];
        preButton = v;
    }
}
#pragma mark action

- (void)buttonAction:(UIButton*)sender{
    if (sender == self.selectedButton) {
        [self cancelSelected];//取消选中状态
        return;
    }
    self.priorityValue  = self.priorityValue +10;//约束优先级
    self.selectedButton = sender;
    [self cancelSelected];//取消选中状态
    [UIView animateWithDuration:2 animations:^{
         [self.indexLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(2);
            make.centerX.mas_equalTo(self.selectedButton.mas_centerX).priorityHigh(self.priorityValue);
            
           }];
    }];

    //选中回调
    if (self.ToolbarSelectCallBack) {
        self.ToolbarSelectCallBack(sender.tag);
    }

}

- (void)cancelSelected{
    for (int i = 0; i<self.buttonArray.count; i++) {
        UIButton *button = self.buttonArray[i];
        if ([self.selectedButton isEqual:button]) {
            button.selected= YES;
        }else{
            button.selected = NO;
        }
    }
}

#pragma mark lazy load

- (void)setIndexBtn:(NSInteger)indexBtn{
    _indexBtn = indexBtn;
    self.selectedButton = self.buttonArray[indexBtn];
    [self buttonAction:self.selectedButton];
}
- (UIImageView *)indexLine {
    if (_indexLine == nil) {
        _indexLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        _indexLine.image = [UIImage imageNamed:@"indexLine_background"];
    }
    return _indexLine;
}
- (NSMutableArray*)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)setIsHaveIndexLine:(BOOL)isHaveIndexLine{
    self.indexLine.hidden = !isHaveIndexLine;
}
@end
