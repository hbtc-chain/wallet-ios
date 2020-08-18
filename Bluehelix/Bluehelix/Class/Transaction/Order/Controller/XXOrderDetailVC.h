//
//  XXOrderDetailVC.h
//  Bhex
//
//  Created by BHEX on 2018/7/24.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "BaseViewController.h"
#import "XXOrderModel.h"

@interface XXOrderDetailVC : BaseViewController

/** mark */
@property (assign, nonatomic) SymbolType type;

/** 币币订单模型 */
@property (strong, nonatomic) XXOrderModel *coinModel;

/** 期权订单模型 */
@property (strong, nonatomic) XXOrderModel *optionModel;
@end
