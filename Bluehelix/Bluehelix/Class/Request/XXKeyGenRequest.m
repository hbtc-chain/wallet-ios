//
//  XXKeyGenRequest.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXKeyGenRequest.h"
#import "Account.h"
#import "SecureData.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "AFNetworking.h"
#import "XXAssetModel.h"
#import "JSONKit.h"
#import "AppDelegate+Category.h"
#import "FCUUID.h"

@interface XXKeyGenRequest ()

@property (nonatomic, strong) XXAssetModel *assetModel; // 账户信息
@property (nonatomic, strong) XXTransactionModel *transactionModel; //交易信息
@property (nonatomic, strong) NSString *uuid;

@end

@implementation XXKeyGenRequest

- (void)sendMsg:(XXTransactionModel *)model {
    self.transactionModel = model;
    self.uuid = [FCUUID uuid];
    [self requestAsset];
}

- (void)createSignString {
    //msgs
    NSMutableDictionary *value = [NSMutableDictionary dictionary];
    value[@"From"] = KUser.address;
    value[@"To"] = KUser.address;
    value[@"OrderId"] = self.uuid;
    value[@"Symbol"] = self.transactionModel.denom;

    NSMutableDictionary *msg = [NSMutableDictionary dictionary];
    msg[@"type"] = kMsgKeyGen;
    msg[@"value"] = value;
    NSMutableArray *msgs = [NSMutableArray array];
    [msgs addObject:msg];

    //fee
    NSMutableDictionary *feeAmount = [NSMutableDictionary dictionary];
    feeAmount[@"amount"] = self.transactionModel.feeAmount;
    feeAmount[@"denom"] = kMainToken;
    NSMutableArray *feeAmounts = [NSMutableArray array];
    [feeAmounts addObject:feeAmount];
    NSMutableDictionary *fee = [NSMutableDictionary dictionary];
    fee[@"amount"] = feeAmounts;
    fee[@"gas"] = self.transactionModel.feeGas;

    //TX
    NSMutableDictionary *tx = [NSMutableDictionary dictionary];
    tx[@"chain_id"] = kChainId;
    tx[@"cu_number"] = kCu_number;
    tx[@"fee"] = fee;
    tx[@"memo"] = self.transactionModel.memo;
    tx[@"msgs"] = msgs;
    tx[@"sequence"] = self.assetModel.sequence; //交易笔数

    if (@available(iOS 11.0, *)) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tx options:NSJSONWritingSortedKeys error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *jsonB = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSData *jsonD = [jsonB dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"========= jsonB%@",jsonB);

        NSData *sec256Data = [SecureData SHA256:jsonD];
        NSData *privateKey = KUser.currentAccount.privateKey;
        Account *account = [Account accountWithPrivateKey:privateKey];
        SecureData *signData = [account signData:sec256Data];
        NSString *signString = [NSString base64StringFromData:signData.data length:0];
        NSLog(@"%@",signString);

        [self sendTxRequest:signString];
    }
}

/// 请求资产信息
- (void)requestAsset {
    MJWeakSelf
    NSString *path = [NSString stringWithFormat:@"/api/v1/cus/%@",KUser.address];
    [HttpManager getWithPath:path params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            NSLog(@"%@",data);
            weakSelf.assetModel = [XXAssetModel mj_objectWithKeyValues:data];
            [weakSelf createSignString];
        } else {
            Alert *alert = [[Alert alloc] initWithTitle:msg duration:kAlertDuration completion:^{
                       }];
            [alert showAlert];
        }
    }];
}

- (void)sendTxRequest:(NSString *)signString {
    //msgs
    NSMutableDictionary *value = [NSMutableDictionary dictionary];
    value[@"From"] = KUser.address;
    value[@"To"] = KUser.address;
    value[@"OrderId"] = self.uuid;
    value[@"Symbol"] = self.transactionModel.denom;

    NSMutableDictionary *msg = [NSMutableDictionary dictionary];
    msg[@"type"] = kMsgKeyGen;
    msg[@"value"] = value;
    NSMutableArray *msgs = [NSMutableArray array];
    [msgs addObject:msg];

    //fee
    NSMutableDictionary *feeAmount = [NSMutableDictionary dictionary];
    feeAmount[@"amount"] = self.transactionModel.feeAmount;
    feeAmount[@"denom"] = kMainToken;
    NSMutableArray *feeAmounts = [NSMutableArray array];
    [feeAmounts addObject:feeAmount];
    NSMutableDictionary *fee = [NSMutableDictionary dictionary];
    fee[@"amount"] = feeAmounts;
    fee[@"gas"] = self.transactionModel.feeGas;

    //signatures
    NSMutableDictionary *pubKey = [NSMutableDictionary dictionary];
    pubKey[@"type"] = kPubKeyType;
    NSData *publicKey = KUser.currentAccount.publicKey;
    pubKey[@"value"] = [NSString base64StringFromData:publicKey length:0];
    NSMutableDictionary *signature = [NSMutableDictionary dictionary];
    signature[@"pub_key"] = pubKey;
    signature[@"signature"] = signString;
    NSMutableArray *signatures = [NSMutableArray array];
    [signatures addObject:signature];

    //sendTxRequest
    NSMutableDictionary *TxReq = [NSMutableDictionary dictionary];
    TxReq[@"msg"] = msgs;
    TxReq[@"fee"] = fee;
    TxReq[@"signatures"] = signatures;
    TxReq[@"memo"] = self.transactionModel.memo;

    NSMutableDictionary *rpc = [NSMutableDictionary dictionary];
    rpc[@"mode"] = @"sync";
    rpc[@"tx"] = TxReq;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.operationQueue.maxConcurrentOperationCount = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];

    [manager POST:[NSString stringWithFormat:@"%@%@",kServerChainUrl,@"/txs"] parameters:rpc headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if (!IsEmpty(responseObject[@"txhash"])) {
            [[AppDelegate appDelegate].TopVC.navigationController popViewControllerAnimated:YES];
        } else {
            Alert *alert = [[Alert alloc] initWithTitle:@"跨链地址生成失败" duration:kAlertDuration completion:^{
                                 }];
            [alert showAlert];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@ %@",task,error);
        NSDictionary *dataDic = [error.userInfo[@"com.alamofire.serialization.response.error.data"] mj_JSONObject];
        NSLog(@"错误信息=%@", [dataDic mj_JSONString]);
        Alert *alert = [[Alert alloc] initWithTitle:dataDic[@"error"] duration:kAlertDuration completion:^{
                             }];
        [alert showAlert];
    }];
}

@end
