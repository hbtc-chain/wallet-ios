//
//  XXTradeData.h
//  Bhex
//
//  Created by Bhex on 2019/1/8.
//  Copyright © 2019年 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XXTradeDataDelegate <NSObject>

@optional

/** 行情数据 */
- (void)tradeQuoteData:(NSDictionary *)quoteDta;

/** 盘口20条列表 */
- (void)tradeDepthListData:(NSDictionary *)listData;

/** 清理数据 */
- (void)cleanData;

@end

@interface XXTradeData : NSObject
singleton_interface(XXTradeData)

/** 索引 0.币币交易 1. OTC  */
@property (assign, nonatomic) NSInteger indexTrade;

/** 索引 0.合约  1. 期权 */
@property (assign, nonatomic) NSInteger indexContract;

#pragma mark - ====================币币交易====================
/** 交易模块 显示的币对 */
@property (strong, nonatomic) XXSymbolModel *coinTradeModel;

/** 交易模块儿的币对 */
@property (strong, nonatomic) NSString *coinTradeSymbol;

/** 交易模块 是否卖出 */
@property (assign, nonatomic) BOOL coinIsSell;

/** 币币盘口订单数量： 0. 数量 1. 累计数量 */
@property (assign, nonatomic) NSInteger coinDepthAmount;

#pragma mark - 3. 公共
/** 订阅的币对 */
@property (strong, nonatomic) NSString *webSymbolId;

/** 当前交易币对 */
@property (strong, nonatomic) XXSymbolModel *currentModel;

/** 价格位数 */
@property (assign, nonatomic) NSInteger priceDigit;

/** 数量位数 */
@property (assign, nonatomic) NSInteger numberDigit;

/** 币币代理 */
@property (weak, nonatomic) id <XXTradeDataDelegate> delegate;

/** 收到深度数据 */
- (void)receiveDeptchData:(id)data;

/** 打开Socket */
- (void)openSocketWithSymbolModel:(XXSymbolModel *)symbolModel;

/** 关闭Socket */
- (void)closeSocket;
@end

NS_ASSUME_NONNULL_END
