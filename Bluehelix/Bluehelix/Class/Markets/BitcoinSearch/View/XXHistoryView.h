//
//  XXHistoryView.h
//  Bhex
//
//  Created by Bhex on 2018/9/10.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXHistoryView : UIView

/** 模型数组 */
@property (strong, nonatomic) NSMutableArray *modelsArray;

/** 点击回调 */
@property (strong, nonatomic) void(^historyBlock)(XXSymbolModel *model);

/** 清除历史记录回调 */
@property (strong, nonatomic) void(^clearBlock)(void);

@end
