//
//  XXQuoteModel.h
//  Bhex
//
//  Created by BHEX on 2018/6/26.
//  Copyright © 2018年 BHEX. All rights reserved.
//
//行情model
#import <Foundation/Foundation.h>

@interface XXQuoteModel : NSObject

/** 行情时间 */
@property (strong) NSString *time;

/** 24h 收盘价 */
@property (strong) NSString *close;

/** 24h 最高价 */
@property (strong) NSString *high;

/** 24h 最低价 */
@property (strong) NSString *low;

/** 24h  开盘价 */
@property (strong) NSString *open;

/** 24h 成交量 */
@property (strong) NSString *volume;

/** 最新价 */
@property (assign, nonatomic) double sortClose;

/** 24h 成交量 */
@property (assign, nonatomic) double sortVolume;

/** 涨跌幅 */
@property (assign, nonatomic) double sortChangedRate;

- (void)initSortData;

@end
