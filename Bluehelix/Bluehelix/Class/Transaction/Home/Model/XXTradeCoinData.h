//
//  XXTradeCoinData.h
//  Bhex
//
//  Created by Bhex on 2019/3/4.
//  Copyright © 2019年 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXTradeCoinData : NSObject

/** 当前委托req请求实体 */
@property (strong, nonatomic) XXReqWebModel *reqModel;

/** 余额模型 */
@property (strong, nonatomic) XXAssetModel *assetsModel;

/** 当前委托数组 */
@property (strong, nonatomic, nullable) NSMutableArray *currentModelsArray;

/** 历史委托数组 */
@property (strong, nonatomic, nullable) NSMutableArray *historyModelsArray;

/** 当前币对id */
@property (strong, nonatomic, nullable) NSString *symbolId;

/** 历史委托加载失败 */
@property (assign, nonatomic) BOOL isHistoryFailure;

/** 1. 加载资产 */
- (void)loadAssetsDataBlock:(void(^)(void))success;

/** 2. 加载当前委托 */
- (void)loadCurrentOrderBlock:(void(^)(void))success;

/** 4. 加载历史委托 是否存在下一页数据 */
- (void)loadHistoryOrderIsUserAction:(BOOL)isUserAction Block:(void(^)(BOOL canNextPaper))success failure:(void (^)(NSString *msg))failure;

// 加载下一页
- (void)loadNextPageHistoryOrder;

- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
