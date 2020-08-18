//
//  XXSwitchPairsOptionCell.h
//  Bhex
//
//  Created by Bhex on 2019/3/27.
//  Copyright © 2019年 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXSymbolModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXSwitchPairsOptionCell : UITableViewCell

/** 是否币对详情选择 */
@property (assign, nonatomic) BOOL isSymbolDetail;

/** 数据模型 */
@property (strong, nonatomic) XXSymbolModel *model;

@property (strong, nonatomic) UIView *lineView;
@end

NS_ASSUME_NONNULL_END
