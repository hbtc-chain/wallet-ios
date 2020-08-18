//
//  XXUserSocket.m
//  Bhex
//
//  Created by Bhex on 2018/9/17.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXUserSocket.h"
@interface XXUserSocket () <SRWebSocketDelegate>

/** 资产列表数组 */
@property (strong, nonatomic) NSMutableArray *balanceArray;

/** 期权资产列表数组 */
@property (strong, nonatomic) NSMutableArray *optionBalanceArray;

/** 期权持仓列表数组 */
@property (strong, nonatomic) NSMutableArray *optionPositionArray;

/** 索引id */
@property (assign, nonatomic) NSInteger indexId;

/** 所有请求模型 */
@property (strong, nonatomic) NSMutableDictionary *reqDict;

/** webSocket */
@property (strong, nonatomic) XXWebSocket *webSocket;

@end

@implementation XXUserSocket
singleton_implementation(XXUserSocket)

- (instancetype)init
{
    self = [super init];
    if (self) {

        // 1. 退出登录通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutNotification) name:Login_Out_NotificationName object:nil];
        
        // 2. 登录通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotification) name:Login_In_NotificationName object:nil];
        
        // 3. 来网通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveComeNetNotificationName) name:ComeNet_NotificationName object:nil];
        
        // 4. 切换域名通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveChangeDomain) name:ChangeDomain_NotificationName object:nil];
        
    }
    return self;
}

#pragma mark - 0.1 接收到退出通知
- (void)loginOutNotification {
    
    self.reqModel = nil;
    
    // 1. 关闭通道
    [self closeWebSocket];
    
    // 币币
    [self.balanceArray removeAllObjects];
    [self.balanceDic removeAllObjects];
}

#pragma mark - 1.2 接收到登录成功通知
- (void)loginNotification {
    
    // 开启长连接通道
    [self openWebSocket];
}

#pragma mark - 1.3 接收到来网通知
- (void)didReceiveComeNetNotificationName {
    [self openWebSocket];
}

#pragma mark - 1.4 切换域名通知
- (void)didReceiveChangeDomain {
    [self openWebSocket];
}

#pragma mark - 2.1 建立长连接
- (void)openWebSocket {

    [self.webSocket cancelSendHeartbeat];
    self.webSocket.delegate = nil;
    [self.webSocket close];
    self.webSocket = nil;
//    if ([KUser.netWorkStatus isEqualToString:@"notReachable"] || !KSystem.isActive) {
//        return;
//    }
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kSocketUserUrl]];
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
//    [request setAllHTTPHeaderFields:headers];
//    [request setValue:[[LocalizeHelper sharedLocalSystem] getRequestHeaderLanguageCode] forHTTPHeaderField:@"Accept-Language"];
//    self.webSocket = [[XXWebSocket alloc] initWithURLRequest:request];
//    self.webSocket.delegate = self;
//    [self.webSocket open];
}

#pragma mark - 2.2 关闭长连接
- (void)closeWebSocket {
    
    [self.webSocket cancelSendHeartbeat];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(openWebSocket) object:nil];
    self.webSocket.delegate = nil;
    [self.webSocket close];
    self.webSocket = nil;
}

#pragma mark - 3.1 长连接成功
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    
    [self.webSocket sendHeartbeat];
    
    [self loadDataBalanceAndOrder];
}

#pragma mark - 3.2 长连接失败
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    
    
//    [XYHAlertView showAlertViewWithTitle:@"userSocket异常失败" message:nil titlesArray:@[@"确定"] andBlock:^(NSInteger index) {
//
//    }];
    
    NSArray *keysArray = [self.reqDict allKeys];
    for (NSInteger i=0; i < keysArray.count; i ++) {
        XXReqWebModel *model = self.reqDict[keysArray[i]];
    
        if (model.httpBlock) {
            model.httpBlock();
        }
    }
    
//    if (!_reqModel && KUser.isLogin) {
//        [self loadDataBalanceAndOrder];
//    }
//
//    if (self.contractFailureBlock) {
//        self.contractFailureBlock();
//    }
    
    // 断开连接后每过1s重新建立一次连接
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(openWebSocket) withObject:nil afterDelay:3.0f];
    });
}

#pragma mark - 3.3 长连接收到消息
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    
    NSDictionary *messData = [message mj_JSONObject];
    if (![messData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[message mj_JSONObject]];
    NSString *eventKey = dataDict[@"event"];
    NSString *topicKey = dataDict[@"topic"];
    NSString *ping = dataDict[@"ping"];
    
    if ([eventKey isEqualToString:@"subbed"]) {
        return;
    }

    if (ping) {
        NSDictionary *pong = @{@"pong":[NSString stringWithFormat:@"%@", ping]};
        [self.webSocket send:[pong mj_JSONString]];
    } else {
        if ([eventKey isEqualToString:@"req"]) { // 请求
            NSString *keyId = dataDict[@"id"];
            XXReqWebModel *model = self.reqDict[keyId];
            [self.reqDict removeObjectForKey:keyId];
            if (model.successBlock) {
                model.successBlock(dataDict[@"data"]);
            }
        } else { // 订阅 @"order";@"option_order";
//            if ([topicKey isEqualToString:@"balance"]) {
//                [self didReceiveBalanceWithData:dataDict[@"data"]];
//            } else if ([topicKey isEqualToString:@"order"]) {
//                [self didReceiveCurrentOrderWithData:dataDict[@"data"]];
//            } else if ([topicKey isEqualToString:@"option_balance"]) {
//                [self didReceiveOptionBalanceWithData:dataDict[@"data"]];
//            } else if ([topicKey isEqualToString:@"option_position"]) {
//                [self didReceiveOptionPositionWithData:dataDict[@"data"]];
//            } else if ([topicKey isEqualToString:@"option_order"]) {
//                [self didReceiveOptionOrderWithData:dataDict[@"data"]];
//            } else if ([topicKey isEqualToString:@"futures_balanc"]) {
//                [self didReceiveContractBalanceWithData:dataDict[@"data"]];
//            } else if ([topicKey isEqualToString:@"futures_position"]) {
//                [self didReceiveContractPositionWithData:dataDict[@"data"]];
//            } else if ([topicKey isEqualToString:@"futures_order"]) {
//                [self didReceiveContractOrderWithData:dataDict[@"data"]];
//            } else if ([topicKey isEqualToString:@"futures_tradeable"]) {
//                [self didReceiveContractTradeableWithData:dataDict[@"data"]];
//            }

        }
    }
}

#pragma mark - 3.4 长连接正常关闭
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
//    [XYHAlertView showAlertViewWithTitle:@"userSocket正常失败" message:nil titlesArray:@[@"确定"] andBlock:^(NSInteger index) {
//                
//    }];

    
//    if (!_reqModel && KUser.isLogin) {
//        [self loadDataBalanceAndOrder];
//    }
//
//    if (self.contractFailureBlock) {
//        self.contractFailureBlock();
//    }
    
    // 断开连接后每过1s重新建立一次连接
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(openWebSocket) withObject:nil afterDelay:2.0f];
    });
}

#pragma mark - 4. red请求
- (void)sendRequestWithXXReqWebModel:(XXReqWebModel *)model {
    self.indexId ++;
    NSString *keyId = [NSString stringWithFormat:@"%zd", self.indexId];
    model.reqParams[@"id"] = keyId;
    self.reqDict[keyId] = model;
    
    NSLog(@"订阅=%@", [model.reqParams mj_JSONString]);
    if (self.webSocket.readyState == SR_OPEN) {
        [self.webSocket send:[model.reqParams mj_JSONString]];
    } else if (model.httpBlock) {
        model.httpBlock();
    }
}

- (void)deleteReqWebModel:(XXReqWebModel *)model {
    NSString *keyId = model.reqParams[@"id"];
    if (self.reqDict[keyId]) {
        [self.reqDict removeObjectForKey:keyId];
    }
}

#pragma mark - 5. 订阅资产 订单消息
- (void)loadDataBalanceAndOrder {
    
    // ====================== 币币
    // 1. 币币资产-订阅消息
    NSMutableDictionary *balanceParams = [NSMutableDictionary dictionary];
    balanceParams[@"topic"] = @"balance";
    balanceParams[@"event"] = @"sub";
    if (self.webSocket.readyState == SR_OPEN) {
        [self.webSocket send:[balanceParams mj_JSONString]];
    }
    
    // 2. 币币当前委托订单订阅
    NSMutableDictionary *orderParams = [NSMutableDictionary dictionary];
    orderParams[@"topic"] = @"order";
    orderParams[@"event"] = @"sub";
    if (self.webSocket.readyState == SR_OPEN) {
        [self.webSocket send:[orderParams mj_JSONString]];
    }
    
    // 3. 发送资产列表请求
    if (self.webSocket.readyState == SR_OPEN) {
        [self sendRequestWithXXReqWebModel:self.reqModel];
    } else {
        self.reqModel.httpBlock();
    }
}

#pragma mark - 6.1 收到【币币资产】变化的
- (void)didReceiveBalanceWithData:(NSArray *)data {
    
    for (NSInteger i=0; i < data.count; i ++) {
        [self updataCoinBalanceData:data[i]];
    }
    
    if (self.meBalanceListReloadBlock) {
        self.meBalanceListReloadBlock();
    }
}

#pragma mark - 6.2 收到【币币当前委托订单】变化的
- (void)didReceiveCurrentOrderWithData:(NSArray *)data {
    
    for (NSInteger i=0; i < data.count; i ++) {
        NSDictionary *dict = data[i];
        if (self.currentOrderTradeBlock) {
            self.currentOrderTradeBlock(dict);
        }
        if (self.currentOrderOrderManagerBlock) {
            self.currentOrderOrderManagerBlock(dict);
        }
        if (self.historyOderOrderManagerBlock && [dict[@"status"] isEqualToString:@"finish"]) {
            self.historyOderOrderManagerBlock(dict);
        }
    }
}

#pragma mark - 7.1 更新【币币资产】数据
- (void)updataCoinBalanceData:(NSDictionary *)dict {
    
    NSString *tokenId = dict[@"tokenId"];
    XXAssetModel *model = [self getBalanceModelWithTokenId:tokenId];
    model.tokenId = dict[@"tokenId"];
    model.tokenName = KString(dict[@"tokenName"]);
    model.free = dict[@"free"];
    model.total = dict[@"total"];
    model.locked = dict[@"locked"];
    model.btcValue = dict[@"btcValue"];
    if (model.assetsChange) {
        model.assetsChange();
    }
}

#pragma mark - 8.1 获取【钱包】资产模型
- (XXAssetModel *)getBalanceModelWithTokenId:(NSString *)tokenId {
    if (!tokenId) {
        return nil;
    }
    XXAssetModel *model = self.balanceDic[tokenId];
    if (model) {
        return model;
    } else {
        model = [[XXAssetModel alloc] init];
        model.tokenId = tokenId;
        model.tokenName = @"";
        model.tokenFullName = @"";
        model.free = @"0";
        model.total = @"0";
        model.locked = @"0";
        model.btcValue = @"0";
        self.balanceDic[tokenId] = model;
        
        NSArray *data = [KMarket.tokenString mj_JSONObject];
        for (NSInteger i=0; i < data.count; i ++) {
            NSDictionary *dict = data[i];
            if ([tokenId isEqualToString:dict[@"tokenId"]]) {
                model.tokenName = dict[@"tokenName"];
                model.tokenFullName = dict[@"tokenFullName"];
                model.iconUrl = dict[@"iconUrl"];
                model.allowDeposit = [dict[@"allowDeposit"] boolValue];
                model.allowWithdraw = [dict[@"allowWithdraw"] boolValue];
                model.minDepositQuantity = dict[@"minDepositQuantity"];
                model.needAddressTag = [dict[@"needAddressTag"] boolValue];
            }
        }
        return model;
    }
}

#pragma mark - || 懒加载
- (NSMutableDictionary *)reqDict {
    if (_reqDict == nil) {
        _reqDict = [NSMutableDictionary dictionary];
    }
    return _reqDict;
}

- (NSMutableDictionary *)balanceDic {
    if (_balanceDic == nil) {
        _balanceDic = [NSMutableDictionary dictionary];
    }
    return _balanceDic;
}

// http 资产回来的时候 先清空本地资产数据
- (void)clearBalance {
    NSArray *balanceKeys = self.balanceDic.allKeys;
    for (NSString *key in balanceKeys) {
        XXAssetModel *assetModel = [self.balanceDic objectForKey:key];
        assetModel.free = @"0";
        assetModel.total = @"0";
        assetModel.locked = @"0";
        assetModel.btcValue = @"0";
    }
}

// 请求币币资产列表
- (XXReqWebModel *)reqModel {
    if (_reqModel == nil) {
   
        _reqModel = [[XXReqWebModel alloc] init];
        _reqModel.reqParams = [NSMutableDictionary dictionary];
        _reqModel.reqParams[@"topic"] = @"balance";
        _reqModel.reqParams[@"event"] = @"req";
        NSMutableDictionary *extData = [NSMutableDictionary dictionary];
        extData[@"dataType"] = @"current_balance";
//        extData[@"accountId"] = KUser.defaultAccountId;
        _reqModel.reqParams[@"extData"] = extData;
        
        _reqModel.index = 1;
        _reqModel.httpUrl = @"asset/get";
        _reqModel.httpParams = [NSMutableDictionary dictionary];
//        _reqModel.httpParams[@"account_id"] = KUser.defaultAccountId;
        
        MJWeakSelf
        _reqModel.successBlock = ^(id data) {
            [weakSelf clearBalance]; //清空本地资产
            weakSelf.balanceArray = [NSMutableArray arrayWithArray:data];
            for (NSInteger i=0; i < weakSelf.balanceArray.count; i ++) {
                NSDictionary *dict = weakSelf.balanceArray[i];
                [weakSelf updataCoinBalanceData:dict];
            }
            
            if (weakSelf.meBalanceListReloadBlock) {
                weakSelf.meBalanceListReloadBlock();
            }
        };
    }
    return _reqModel;
}

@end
