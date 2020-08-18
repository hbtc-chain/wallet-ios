//
//  XXEntrustmentOrderCell.h
//  Bhex
//
//  Created by BHEX on 2018/6/14.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXDepthOrderModel.h"

@interface XXDepthCell : UITableViewCell

/** 0. 数量  1. 累计数量 */
@property (assign, nonatomic) NSInteger amounntIndex;

/** 平均值 */
@property (assign, nonatomic) CGFloat ordersAverage;

/** 单挡最大订单量 */
@property (assign, nonatomic) double maxAmount;

/** 数据模型 */
@property (strong, nonatomic, nullable) XXDepthOrderModel *model;

- (void)reloadData;
@end
