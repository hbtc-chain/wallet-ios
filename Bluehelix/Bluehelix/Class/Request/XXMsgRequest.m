//
//  XXMsgRequest.m
//  Bluehelix
//
//  Created by BHEX on 2020/04/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXMsgRequest.h"
#import "Account.h"
#import "SecureData.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "AFNetworking.h"
#import "XXAssetModel.h"
#import "JSONKit.h"
#import "AppDelegate+Category.h"
#import "FCUUID.h"
#include "ecdsa.h"
#include "secp256k1.h"
#import "AESCrypt.h"

@interface XXMsgRequest ()

@property (nonatomic, strong) XXAssetModel *assetModel; // 账户信息
@property (nonatomic, strong) XXMsg *msgModel; //交易信息
@property (nonatomic, strong) NSString *uuid;

@end

@implementation XXMsgRequest

/// 发送交易
/// @param msg 交易对象
- (void)sendMsg:(XXMsg *)msg {
    self.msgModel = msg;
    [self requestAsset];
}

- (void)send {
    NSMutableDictionary *tx = [self buildData];
    NSData *serializeData = [self serializeData:tx];
    NSString *signString = [self signData:serializeData];
    NSMutableDictionary *rpc = [self buildRpc:signString];
    [self sendTxRequest:rpc];
}

/// 构造数据
- (NSMutableDictionary *)buildData {
    //fee
    NSMutableDictionary *feeAmount = [NSMutableDictionary dictionary];
    feeAmount[@"amount"] = self.msgModel.feeAmount;
    feeAmount[@"denom"] = self.msgModel.feeDenom;
    NSMutableArray *feeAmounts = [NSMutableArray array];
    [feeAmounts addObject:feeAmount];
    NSMutableDictionary *fee = [NSMutableDictionary dictionary];
    fee[@"amount"] = feeAmounts;
    fee[@"gas"] = [XXUserData sharedUserData].gas;
    
    //TX
    NSMutableDictionary *tx = [NSMutableDictionary dictionary];
    tx[@"chain_id"] = kChainId;
    tx[@"fee"] = fee;
    tx[@"memo"] = self.msgModel.memo;
    tx[@"msgs"] = self.msgModel.msgs;
    tx[@"sequence"] = self.assetModel.sequence; //交易笔数
    return tx;
}

/// 序列化数据
/// @param tx 需要序列化的数据
- (NSData *)serializeData:(NSMutableDictionary *)tx {
    if (@available(iOS 11.0, *)) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tx options:NSJSONWritingSortedKeys error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *jsonB = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSData *jsonD = [jsonB dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"========= jsonB%@",jsonB);
        return jsonD;
    } else {
        return nil;
    }
}

/// 签名数据
/// @param data 交易数据
- (NSString *)signData:(NSData *)data {
    NSData *sec256Data = [SecureData SHA256:data];
    
    NSString *privateKeyString = [AESCrypt decrypt:KUser.currentAccount.privateKey password:self.msgModel.text];
    NSData *privateKey = [[SecureData secureDataWithHexString:privateKeyString] data];
    if (sec256Data.length == 32) {
        SecureData *signatureData = [SecureData secureDataWithLength:64];;
        uint8_t pby;
        ecdsa_sign_digest(&secp256k1, [privateKey bytes], sec256Data.bytes, signatureData.mutableBytes, &pby, NULL);
        NSString *signString = [NSString base64StringFromData:signatureData.data length:0];
        return signString;
    } else {
        return nil;
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
            [weakSelf send];
        } else {
            Alert *alert = [[Alert alloc] initWithTitle:msg duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
        }
    }];
}

/// 构造交易对象
/// @param signString 签名后Tx
- (NSMutableDictionary *)buildRpc:(NSString *)signString {
    //fee
    NSMutableDictionary *feeAmount = [NSMutableDictionary dictionary];
    feeAmount[@"amount"] = self.msgModel.feeAmount;
    feeAmount[@"denom"] = self.msgModel.feeDenom;
    NSMutableArray *feeAmounts = [NSMutableArray array];
    [feeAmounts addObject:feeAmount];
    NSMutableDictionary *fee = [NSMutableDictionary dictionary];
    fee[@"amount"] = feeAmounts;
    fee[@"gas"] = [XXUserData sharedUserData].gas;
    
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
    TxReq[@"msg"] = self.msgModel.msgs;
    TxReq[@"fee"] = fee;
    TxReq[@"signatures"] = signatures;
    TxReq[@"memo"] = self.msgModel.memo;
    
    NSMutableDictionary *rpc = [NSMutableDictionary dictionary];
    rpc[@"mode"] = @"sync";
    rpc[@"tx"] = TxReq;
    return  rpc;
}

/// 发送交易请求
/// @param rpc 交易对象
- (void)sendTxRequest:(NSMutableDictionary *)rpc {
    [MBProgressHUD showActivityMessageInView:@""];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.operationQueue.maxConcurrentOperationCount = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [manager.requestSerializer setValue:[[LocalizeHelper sharedLocalSystem] getRequestHeaderLanguageCode] forHTTPHeaderField:@"local"];

    
    [manager POST:[NSString stringWithFormat:@"%@%@",kServerUrl,@"/api/v1/txs"] parameters:rpc headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:LocalizedString(@"MsgSuccess")];
        NSLog(@"%@",responseObject);
        if (!IsEmpty(responseObject[@"txhash"]) && IsEmpty(responseObject[@"code"])) {
            if (self.msgSendSuccessBlock) {
                self.msgSendSuccessBlock(responseObject);
            }
        } else {
            NSString *raw_log = [responseObject objectForKey:@"raw_log"];
            if (!IsEmpty(raw_log)) {
                NSData* jsonData = [raw_log dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [jsonData objectFromJSONData];
                Alert *alert = [[Alert alloc] initWithTitle:dic[@"message"] duration:kAlertDuration completion:^{
                }];
                [alert showAlert];
                if (self.msgSendFaildBlock) {
                    self.msgSendFaildBlock(dic[@"message"]);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@ %@",task,error);
        NSDictionary *dataDic = [error.userInfo[@"com.alamofire.serialization.response.error.data"] mj_JSONObject];
        NSLog(@"错误信息=%@", [dataDic mj_JSONString]);
        if (self.msgSendFaildBlock) {
            self.msgSendFaildBlock(dataDic[@"error"]);
        }
//        Alert *alert = [[Alert alloc] initWithTitle:dataDic[@"error"] duration:kAlertLongDuration completion:^{
//        }];
//        [alert showAlert];
//        NSString *errorString = dataDic[@"error"];
//        if (!IsEmpty(errorString) && errorString[@""]) {
//
//        }
        [MBProgressHUD showErrorMessage:dataDic[@"error"]];
    }];
}

@end
