//
//  XXOrderModel.h
//  Bhex
//
//  Created by BHEX on 2018/7/22.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXOrderModel : NSObject

/** 索引 0.币币 1. 合约 2. 期权 */
@property (assign, nonatomic) NSInteger index;

/** 时间 */
@property (strong, nonatomic) NSString *time;

/** 订单id */
@property (strong, nonatomic) NSString *orderId;

/** 账户id */
@property (strong, nonatomic) NSString *accountId;

/** 币对 id */
@property (strong, nonatomic) NSString *symbolId;

/** 币对名称 */
@property (strong, nonatomic) NSString *symbolName;

/** 基础token id */
@property (strong, nonatomic) NSString *baseTokenId;

/** 基础token name */
@property (strong, nonatomic) NSString *baseTokenName;

/** 报价token id */
@property (strong, nonatomic) NSString *quoteTokenId;

/** 报价token name */
@property (strong, nonatomic) NSString *quoteTokenName;

/** 价格 */
@property (strong, nonatomic) NSString *price;

/** 原始下单数量 */
@property (strong, nonatomic) NSString *origQty;

/** 成交数量 */
@property (strong, nonatomic) NSString *executedQty;

/** 成交金额 */
@property (strong, nonatomic) NSString *executedAmount;

/** 成交均价 */
@property (strong, nonatomic) NSString *avgPrice;

/** 手续费数组 */
@property (strong, nonatomic) NSMutableArray *fees;

/** LIMIT 限价  MARKET  市价 */
@property (strong, nonatomic) NSString *type;

/** BUY 买  SELL  卖 */
@property (strong, nonatomic) NSString *side;

/** 订单状态 */
@property (strong, nonatomic) NSString *status;

/** 创建成功 */
@property (strong, nonatomic) NSString *statusDesc;

/** 期权类型：CALL=看涨，PUT=看跌 */
@property (strong, nonatomic) NSString *optionType;
@end
