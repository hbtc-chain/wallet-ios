//
//  XXTradeCoinData.m
//  Bhex
//
//  Created by Bhex on 2019/3/4.
//  Copyright © 2019年 Bhex. All rights reserved.
//

#import "XXTradeCoinData.h"

@interface XXTradeCoinData ()

/** 页加载数量 */
@property (assign, nonatomic) NSInteger limit;

/** 资产回调 */
@property (strong, nonatomic) void(^assetsBlock)(void);

/** 当前委托回调 */
@property (strong, nonatomic) void(^currentOrderBlock)(void);

/** 历史委托回调 */
@property (strong, nonatomic) void(^historyOrderBlock)(BOOL canNextPaper);

@end

@implementation XXTradeCoinData

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.limit = 20;
    }
    return self;
}

#pragma mark - 1. 加载资产 */
- (void)loadAssetsDataBlock:(void(^)(void))success {
    
}

#pragma mark - 2.1 加载当前委托 */
- (void)loadCurrentOrderBlock:(void(^)(void))success {
    self.currentOrderBlock = success;
    
//    if (!KUser.isLogin) {
//        self.currentModelsArray = [NSMutableArray array];
//        self.currentOrderBlock();
//        return;
//    }
    
    if (self.reqModel) {
        [KUserSocket deleteReqWebModel:self.reqModel];
    }
    
    self.reqModel = [[XXReqWebModel alloc] init];
    self.reqModel.reqParams = [NSMutableDictionary dictionary];
    self.reqModel.reqParams[@"topic"] = @"order";
    self.reqModel.reqParams[@"event"] = @"req";
    NSMutableDictionary *extData = [NSMutableDictionary dictionary];
    extData[@"dataType"] = @"current_order";
//    extData[@"accountId"] = KUser.defaultAccountId;
    extData[@"symbolId"] = KTrade.coinTradeModel.symbolId;
    extData[@"fromId"] = @"0";
    extData[@"limit"] = @(50);
    self.reqModel.reqParams[@"extData"] = extData;
    
    self.reqModel.index = 2;
    self.reqModel.httpUrl = @"order/open_orders";
    self.reqModel.httpParams = [NSMutableDictionary dictionary];
//    self.reqModel.httpParams[@"account_id"] = KUser.defaultAccountId;
    self.reqModel.httpParams[@"symbol_id"] = KTrade.coinTradeModel.symbolId;
    self.reqModel.httpParams[@"limit"] = @(50);
    
    MJWeakSelf
    KUserSocket.currentOrderTradeBlock = ^(NSDictionary *data) {
        [weakSelf receiveData:data];
    };
    
    self.reqModel.successBlock = ^(id data) {
        weakSelf.currentModelsArray = [XXOrderModel mj_objectArrayWithKeyValuesArray:data];
        if (weakSelf.currentOrderBlock) {
            weakSelf.currentOrderBlock();
        }
    };
    
    self.reqModel.failureBlock = ^{
        
    };
    [KUserSocket sendRequestWithXXReqWebModel:self.reqModel];
}

#pragma mark - 2.2 接收到socket数据
- (void)receiveData:(NSDictionary *)data {
    
    if (![data[@"symbolId"] isEqualToString:KTrade.coinTradeModel.symbolId]) {
        return;
    }
    
    // 插入
    if ([data[@"status"] isEqualToString:@"NEW"]) { // 新增
        XXOrderModel *model = [XXOrderModel mj_objectWithKeyValues:data];
        if (self.currentModelsArray && ![self isHaveReceiveOrder:model]) {
            [self.currentModelsArray insertObject:model atIndex:0];
        }
    } else if ([data[@"status"] isEqualToString:@"CANCELED"] || [data[@"status"] isEqualToString:@"FILLED"]) { // 删除
        NSString *orderId = data[@"orderId"];
        NSInteger index = -1;
        for (NSInteger i=0; i < self.currentModelsArray.count; i ++) {
            XXOrderModel *model = self.currentModelsArray[i];
            if ([model.orderId isEqualToString:orderId]) {
                index = i;
                break;
            }
        }
        if (index > -1) {
            [self.currentModelsArray removeObjectAtIndex:index];
        }
        
    } else { // 更新
        NSString *orderId = data[@"orderId"];
        NSInteger index = -1;
        for (NSInteger i=0; i < self.currentModelsArray.count; i ++) {
            XXOrderModel *model = self.currentModelsArray[i];
            if ([model.orderId isEqualToString:orderId]) {
                index = i;
                break;
            }
        }
        
        if (index > -1) {
            self.currentModelsArray[index] = [XXOrderModel mj_objectWithKeyValues:data];
        } else {
            if (self.currentModelsArray) {
                [self.currentModelsArray insertObject:[XXOrderModel mj_objectWithKeyValues:data] atIndex:0];
            }
        }
    }
    
    if (self.currentOrderBlock) {
        self.currentOrderBlock();
    }
}

- (BOOL)isHaveReceiveOrder:(XXOrderModel *)model {
    for (NSInteger i=0; i < self.currentModelsArray.count; i ++) {
        XXOrderModel *orderModel = self.currentModelsArray[i];
        if ([model.orderId isEqualToString:orderModel.orderId]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 3.1 加载历史委托 是否存在下一页数据 */
- (void)loadHistoryOrderIsUserAction:(BOOL)isUserAction Block:(void(^)(BOOL canNextPaper))success failure:(void (^)(NSString *msg))failure {
    
    self.historyOrderBlock = success;
    
//    if (!KUser.isLogin) {
//        self.historyModelsArray = [NSMutableArray array];
//        self.historyOrderBlock(NO);
//        return;
//    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"account_id"] = KUser.defaultAccountId;
    params[@"base_token_id"] = KTrade.coinTradeModel.baseTokenId;
    params[@"limit"] = @(self.limit);
    MJWeakSelf
//    [HttpManager order_GetWithPath:@"order/trade_orders" params:params andBlock:^(id data, NSString *msg, NSInteger code) {
//        if (code == 0) {
//            weakSelf.isHistoryFailure = NO;
//            NSMutableArray *dataArray = [XXOrderModel mj_objectArrayWithKeyValuesArray:data];
//            weakSelf.historyModelsArray = dataArray;
//            if (weakSelf.historyOrderBlock) {
//                weakSelf.historyOrderBlock(dataArray.count >= weakSelf.limit);
//            }
//        } else {
//            if (isUserAction) {
//                if (!weakSelf.historyModelsArray ) {
//                    if (failure) {
//                        weakSelf.isHistoryFailure = YES;
//                        failure(KString(msg));
//                    }
//                } else {
//                    [MBProgressHUD showErrorMessage:KString(msg)];
//                }
//            }
//        }
//    }];
}

#pragma mark - 3.2 加载下一页
- (void)loadNextPageHistoryOrder {
    
    NSString *fromId = @"";
    if (self.historyModelsArray.count > 0) {
        XXOrderModel *model = [self.historyModelsArray lastObject];
        fromId = model.orderId;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"account_id"] = KUser.defaultAccountId;
    if (fromId.length > 0) {
        params[@"from_order_id"] = fromId;
    }
    params[@"base_token_id"] = KTrade.coinTradeModel.baseTokenId;
    params[@"limit"] = @(self.limit);
    MJWeakSelf
//    [HttpManager order_GetWithPath:@"order/trade_orders" params:params andBlock:^(id data, NSString *msg, NSInteger code) {
//        if (code == 0) {
//            NSMutableArray *dataArray = [XXOrderModel mj_objectArrayWithKeyValuesArray:data];
//            [weakSelf.historyModelsArray addObjectsFromArray:dataArray];
//            if (weakSelf.historyOrderBlock) {
//                weakSelf.historyOrderBlock(dataArray.count >= self.limit);
//            }
//        } else {
//            [MBProgressHUD showErrorMessage:msg];
//        }
//    }];
}

#pragma mark - 4. 消失
- (void)dismiss {
    
    if (self.reqModel) {
        [KUserSocket deleteReqWebModel:self.reqModel];
    }
    
}
@end
