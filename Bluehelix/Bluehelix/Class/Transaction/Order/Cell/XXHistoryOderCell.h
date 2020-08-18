//
//  XXHistoryOderCell.h
//  Bhex
//
//  Created by BHEX on 2018/7/22.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXOrderModel.h"

@interface XXHistoryOderCell : UITableViewCell

/** 分割线 */
@property (strong, nonatomic) UIView *lineView;

/** 数据模型 */
@property (strong, nonatomic) XXOrderModel *model;

@end
