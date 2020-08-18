//
//  XXTradeableModel.h
//  Bhex
//
//  Created by Bhex on 2019/3/1.
//  Copyright © 2019年 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXTradeableModel : NSObject

/** 期权 token id */
@property (strong, nonatomic) NSString *tokenId;

/** 期权 token name */
@property (strong, nonatomic) NSString *tokenName;

/** 期权 full name */
@property (strong, nonatomic) NSString *tokenFullName;

/** 可卖期权 */
@property (strong, nonatomic) NSString *sellable;

/** 当前资产余额（币) 可用. (USDT, BTC...) */
@property (strong, nonatomic) NSString *available;

/** 当前资产余额（币) 锁定. (USDT, BTC...) */
@property (strong, nonatomic) NSString *locked;

@property (strong, nonatomic) void(^tradeableChangeBlock)(void);

@end

NS_ASSUME_NONNULL_END
