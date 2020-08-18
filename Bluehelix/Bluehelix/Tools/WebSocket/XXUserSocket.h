//
//  XXUserSocket.h
//  Bhex
//
//  Created by Bhex on 2018/9/17.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XXReqWebModel.h"
#import "XXAssetModel.h"
#import "XXTradeableModel.h"

@interface XXUserSocket : NSObject
singleton_interface(XXUserSocket)

#pragma mark - =============== 钱包余额资产 ============
/** 资产请求模型 */
@property (strong, nonatomic) XXReqWebModel *reqModel;

/** 资产字典 */
@property (strong, nonatomic) NSMutableDictionary *balanceDic;

/** 1. 资产【个人中心资产资产列表刷新】改动回调 */
@property (strong, nonatomic) void(^meBalanceListReloadBlock)(void);

/** 获取资产模型 */
- (XXAssetModel *)getBalanceModelWithTokenId:(NSString *)tokenId;

#pragma mark - =============== 币币订单回调 ============
/** 1. 当前订单【交易】回调 */
@property (strong, nonatomic) void(^currentOrderTradeBlock)(id data);

/** 2. 当前订单【订单管理】回调 */
@property (strong, nonatomic) void(^currentOrderOrderManagerBlock)(id data);

/** 3. 历史订单【订单管理】回调 */
@property (strong, nonatomic) void(^historyOderOrderManagerBlock)(id data);

#pragma mark - =============== 期权订单回调 ============
/** 1. 期权当前订单【交易】回调 */
@property (strong, nonatomic) void(^optionCurrentOrderTradeBlock)(id data);


/** 0. 建立长连接 */
- (void)openWebSocket;

/** 1. 关闭长连接 */
- (void)closeWebSocket;

/** 2. red请求 */
- (void)sendRequestWithXXReqWebModel:(XXReqWebModel *)model;

/** 3. 删除red请求 */
- (void)deleteReqWebModel:(XXReqWebModel *)model;
@end
