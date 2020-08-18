//
//  XXOrderDetailHeaderView.h
//  Bhex
//
//  Created by BHEX on 2018/7/24.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXOrderModel.h"
@interface XXOrderDetailHeaderView : UIView

/** 币币订单模型 */
@property (strong, nonatomic) XXOrderModel *coinModel;

/** 合约订单模型 */
@property (strong, nonatomic) XXOrderModel *optionModel;

@end
