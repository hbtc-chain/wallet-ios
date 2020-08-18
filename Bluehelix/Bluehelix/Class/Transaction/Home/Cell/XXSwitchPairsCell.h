//
//  XXSwitchPairsCell.h
//  Bhex
//
//  Created by Bhex on 2018/9/9.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXSymbolModel.h"

@interface XXSwitchPairsCell : UITableViewCell

/** 是否币对详情选择 */
@property (assign, nonatomic) BOOL isSymbolDetail;

/** 数据模型 */
@property (strong, nonatomic) XXSymbolModel *model;

@property (strong, nonatomic) UIView *lineView;

@end
