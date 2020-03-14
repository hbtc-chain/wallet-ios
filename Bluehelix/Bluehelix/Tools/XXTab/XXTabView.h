//
//  XXTabView.h
//  Bhex
//
//  Created by Bhex on 2018/9/17.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XXTabViewDelegate <NSObject>

@optional

- (void)tabViewDidSelectItemIndex:(NSInteger)index name:(NSString *)name;

@end

@interface XXTabView : UIView

/** 按钮标题数组 */
@property (strong, nonatomic) NSMutableArray *buttonTitlesArray;

/** 设置索引 */
@property (assign, nonatomic) NSInteger indexButton;

/** 左侧内边距 */
@property (assign, nonatomic) CGFloat leftPadding;

/** 按钮间内边距 */
@property (assign, nonatomic) CGFloat buttonPadding;

/** 代理 */
@property (weak, nonatomic) id <XXTabViewDelegate>delegate;

@end
