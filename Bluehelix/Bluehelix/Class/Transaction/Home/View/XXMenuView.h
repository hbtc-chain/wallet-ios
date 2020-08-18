//
//  XXMenuView.h
//  Bhex
//
//  Created by Bhex on 2019/1/22.
//  Copyright © 2019年 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XXMenuViewDelegate <NSObject>

@optional

- (void)menuViewItemDidselctIndex:(NSInteger)index name:(NSString *_Nullable)name;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XXMenuView : UIView

/** 0. 索引按钮值 */
@property (assign, nonatomic) NSInteger indexClass;

/** 1. 用户改变索引 */
@property (assign, nonatomic) CGFloat changeToIndex;

/** 2. 设置索引 */
@property (assign, nonatomic) NSInteger selectIndex;

/** 整体是否居中显示 */
@property (assign, nonatomic) NSTextAlignment alignment;

/** 3. 模型数组 */
@property (strong, nonatomic) NSMutableArray *namesArray;

/** 4. 代理 */
@property (weak, nonatomic) id <XXMenuViewDelegate>delegate;

/** 线条 */
@property (strong, nonatomic) UIView *lineView;

/** 底线 */
@property (strong, nonatomic) UIView *lowLine;

/** 最大字体 */
@property (strong, nonatomic) UIFont *maxFont;

/** 小字体 */
@property (strong, nonatomic) UIFont *minFont;

/** 选中的字体颜色 */
@property (strong, nonatomic, nullable) UIColor *selectColor;

/** 未选中的字体颜色 */
@property (strong, nonatomic, nullable) UIColor *normalColor;

@end

NS_ASSUME_NONNULL_END
