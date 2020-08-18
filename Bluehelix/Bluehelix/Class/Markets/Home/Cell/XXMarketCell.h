//
//  XXMarketCell.h
//  Bhex
//
//  Created by BHEX on 2018/7/1.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXSymbolModel.h"

@interface XXMarketCell : UITableViewCell

/** 分割线 */
@property (strong, nonatomic) UIView *lineView;

/** 数据模型 */
@property (strong, nonatomic) XXSymbolModel *model;

/** 收藏回调 */
@property (strong, nonatomic) void(^saveButtonBlock)(void);

- (void)cleanData;
@end
