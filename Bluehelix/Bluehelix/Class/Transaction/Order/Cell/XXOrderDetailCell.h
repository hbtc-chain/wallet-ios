//
//  XXOrderDetailCell.h
//  Bhex
//
//  Created by BHEX on 2018/7/24.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXOrderInfoModel.h"

@interface XXOrderDetailCell : UITableViewCell

/** 数据模型 */
@property (strong, nonatomic) XXOrderInfoModel *model;

@end
