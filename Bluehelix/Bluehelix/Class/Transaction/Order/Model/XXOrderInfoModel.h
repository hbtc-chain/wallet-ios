//
//  XXOrderInfoModel.h
//  Bhex
//
//  Created by BHEX on 2018/7/25.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXOrderInfoModel : NSObject

@property (assign, nonatomic) SymbolType indexType;

/** 成交时间 */
@property (strong, nonatomic) NSString *time;

/** 成交记录id */
@property (strong, nonatomic) NSString *tradeId;

/** 订单id */
@property (strong, nonatomic) NSString *orderId;

/** 账户id */
@property (strong, nonatomic) NSString *accountId;

/** 交易对 id */
@property (strong, nonatomic) NSString *symbolId;

/** 交易对 名称 */
@property (strong, nonatomic) NSString *symbolName;

/** 基础token id */
@property (strong, nonatomic) NSString *baseTokenId;

/** 基础token name */
@property (strong, nonatomic) NSString *baseTokenName;

/** 交易token id */
@property (strong, nonatomic) NSString *quoteTokenId;

/** 交易token name */
@property (strong, nonatomic) NSString *quoteTokenName;

/** 成交均价 */
@property (strong, nonatomic) NSString *price;

/** 成交数量 */
@property (strong, nonatomic) NSString *quantity;

/** 手续费token id */
@property (strong, nonatomic) NSString *feeTokenId;

/** 手续费token name */
@property (strong, nonatomic) NSString *feeTokenName;

/** 手续费 */
@property (strong, nonatomic) NSString *fee;

/** 手续费token */
@property (strong, nonatomic) NSString *feeToken;

/** 订单类型 "LIMIT" */
@property (strong, nonatomic) NSString *type;

/** 买卖方向 SELL */
@property (strong, nonatomic) NSString *side;

/** 成交额 */
@property (strong, nonatomic) NSString *executedAmount;

/** 盈亏 */
@property (strong, nonatomic, nullable) NSString *pnl;
@end
