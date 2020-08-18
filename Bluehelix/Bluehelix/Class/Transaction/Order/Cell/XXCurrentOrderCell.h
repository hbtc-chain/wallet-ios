//
//  XXCurrentOrderCell.h
//  Bhex
//
//  Created by BHEX on 2018/7/22.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXOrderModel.h"

@interface XXCurrentOrderCell : UITableViewCell

/**撤单需要订单类型*/
@property (nonatomic, assign) SymbolType type;

/** 分割线 */
@property (strong, nonatomic) UIView *lineView;

/** 数据模型 */
@property (strong, nonatomic) XXOrderModel *model;

/** 撤销回调 */
@property (strong, nonatomic) void(^deleteBlock)(XXOrderModel *model);

@end
