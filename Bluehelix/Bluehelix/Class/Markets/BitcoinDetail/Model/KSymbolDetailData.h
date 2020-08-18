//
//  KSymbolDetailData.h
//  Bhex
//
//  Created by YiHeng on 2020/2/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

#define KlinCount 300

@interface KSymbolDetailData : NSObject
singleton_interface(KSymbolDetailData)

#pragma mark - 5. 币对详情模型
/** 币对详情模型 */
@property (strong, nonatomic) XXSymbolModel *symbolModel;

/** 价格精度位数 */
@property (assign, nonatomic) NSInteger priceDigit;

/** 数量精度位数 */
@property (assign, nonatomic) NSInteger numberDigit;

/** 是否可以刷新k线图 */
@property (assign, nonatomic) BOOL isReloadKlineUI;

/** 索引k线类型 */
@property (strong, nonatomic) NSString *klineIndex;

/** 主图索引 */
@property (strong, nonatomic, nullable) NSString *klineMainIndex;

/** 副图索引 */
@property (strong, nonatomic, nullable) NSString *klineAccessoryIndex;

/** 回调深度列表 */
@property (strong, nonatomic, nullable) void(^blockList)(NSMutableArray *modelsArray, double ordersAverage, double maxValue);

/** 是否有下一页 */
@property (assign, nonatomic) BOOL isNext;

/** 是否处于加载中 */
@property (assign, nonatomic) BOOL isLoading;

/** 回调加载下一页数据 */
@property (strong, nonatomic, nullable) void(^blockLoadNext)(void);
@end

