//
//  XXTradeDepthCell.h
//  Bhex
//
//  Created by BHEX on 2018/7/16.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXDepthModel.h"

@interface XXTradeDepthCell : UITableViewCell

/** 0. 数量  1. 累计数量 */
@property (assign, nonatomic) NSInteger amounntIndex;

/** 平均值 */
@property (assign, nonatomic) CGFloat ordersAverage;

/** 单挡最大订单量 */
@property (assign, nonatomic) double maxAmount;

/** 价格标签 */
@property (strong, nonatomic) XXLabel *priceLabel;

/** 数量标签 */
@property (strong, nonatomic) XXLabel *numberLabel;

/** 数据模型 */
@property (strong, nonatomic) XXDepthModel *model;

- (void)reloadData;

@end
