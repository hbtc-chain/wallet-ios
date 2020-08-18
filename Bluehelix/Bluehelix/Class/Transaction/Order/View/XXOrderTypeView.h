//
//  XXOrderTypeView.h
//  Bhex
//
//  Created by Bhex on 2018/10/21.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXOrderTypeView : UIView

/** 改变到某种类型 0. 当前委托  1. 历史委托  */
@property (assign, nonatomic) NSInteger changeIndex;

/** 索引选中类型 0. 当前委托  1. 历史委托 */
@property (assign, nonatomic) NSInteger indexType;

/** 选中回调 index : 0. 当前委托  1. 历史委托 */
@property (strong, nonatomic) void(^selectOrderTypeBlock)(NSInteger index);

/** 全部取消订单回调 */
@property (strong, nonatomic) void(^allOrdersCancelBlock)(void);
@end

NS_ASSUME_NONNULL_END
