//
//  XXTransactionModel.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/08.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXTransactionModel : NSObject

- (instancetype)initWithfrom:(NSString *)from
                          to:(NSString *)to
                      amount:(NSString *)amount
                       denom:(NSString *)denom
                   feeAmount:(NSString *)feeAmount
                      feeGas:(NSString *)feeGas
                    feeDenom:(NSString *)feeDenom
                        memo:(NSString *)memo;

@property (nonatomic, strong) NSString *fromAddress; // 转出地址
@property (nonatomic, strong) NSString *toAddress; // 交易对方账户
@property (nonatomic, strong) NSString *amount; // 交易数
@property (nonatomic, strong) NSString *denom; // 交易币种
@property (nonatomic, strong) NSString *feeAmount; // 手续费最大值
@property (nonatomic, strong) NSString *feeGas; // 手续费 gas
@property (nonatomic, strong) NSString *feeDenom; // 手续费币种
@property (nonatomic, strong) NSString *memo; //备注 暂无
@property (nonatomic, strong) NSString *type; //交易类型
@property (nonatomic, strong) NSString *withdrawal_fee; //跨链手续费

- (instancetype)initwithActivity:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END


//
//+ (void)sendMsg {
//    //msgs
//    NSMutableDictionary *amount = [NSMutableDictionary dictionary];
//    amount[@"amount"] = @"60000000000000000000";
//    amount[@"denom"] = @"bht";
//    NSMutableArray *amounts = [NSMutableArray array];
//    [amounts addObject:amount];
//
//    NSMutableDictionary *value = [NSMutableDictionary dictionary];
//    value[@"amount"] = amounts;
//    value[@"from_address"] = @"BHgE934R84XUxETVFoVav46NKs6aakgoq8b";
//    value[@"to_address"] = @"BHV1EuSkWMYHWNa5bAUAm6DTbLzT4QPNoGn";
//
//    NSMutableDictionary *msg = [NSMutableDictionary dictionary];
//    msg[@"type"] = @"cosmos-sdk/MsgSend";
//    msg[@"value"] = value;
//    NSMutableArray *msgs = [NSMutableArray array];
//    [msgs addObject:msg];
//
//    //fee
//    NSMutableDictionary *feeAmount = [NSMutableDictionary dictionary];
//    feeAmount[@"amount"] = @"3000000000000000000";
//    feeAmount[@"denom"] = @"bht";
//    NSMutableArray *feeAmounts = [NSMutableArray array];
//    [feeAmounts addObject:feeAmount];
//    NSMutableDictionary *fee = [NSMutableDictionary dictionary];
//    fee[@"amount"] = feeAmounts;
//    fee[@"gas"] = @"3000000";
//
//    //TX
//    NSMutableDictionary *tx = [NSMutableDictionary dictionary];
//    tx[@"chain_id"] = kChainId;
//    tx[@"cu_number"] = @"0"; //接口获取
//    tx[@"fee"] = fee;
//    tx[@"memo"] = @"test memo";
//    tx[@"msgs"] = msgs;
//    tx[@"sequence"] = @"1"; //交易笔数 接口查询
//
//    if (@available(iOS 11.0, *)) {
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tx options:NSJSONWritingSortedKeys error:nil];
//        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSString *jsonB = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//        NSData *jsonD = [jsonB dataUsingEncoding:NSUTF8StringEncoding];
//        NSLog(@"%@",jsonB);
//
//        NSData *sec256Data = [SecureData SHA256:jsonD];
//        NSData *privateKey = KUser.rootAccount[@"privateKey"];
//        Account *account = [Account accountWithPrivateKey:privateKey];
//        SecureData *signData = [account signData:sec256Data];
//        NSString *signString = [NSString base64StringFromData:signData.data length:0];
//        NSLog(@"%@",signString);
//
//        [self sendTxRequest:signString];
//    }
//}
//
//+ (void)sendTxRequest:(NSString *)signString {
//    //msgs
//    NSMutableDictionary *amount = [NSMutableDictionary dictionary];
//    amount[@"amount"] = @"60000000000000000000";
//    amount[@"denom"] = @"bht";
//    NSMutableArray *amounts = [NSMutableArray array];
//    [amounts addObject:amount];
//
//    NSMutableDictionary *msgValue = [NSMutableDictionary dictionary];
//    msgValue[@"amount"] = amounts;
//    msgValue[@"from_address"] = @"BHgE934R84XUxETVFoVav46NKs6aakgoq8b";
//    msgValue[@"to_address"] = @"BHV1EuSkWMYHWNa5bAUAm6DTbLzT4QPNoGn";
//
//    NSMutableDictionary *msg = [NSMutableDictionary dictionary];
//    msg[@"type"] = @"cosmos-sdk/MsgSend";
//    msg[@"value"] = msgValue;
//    NSMutableArray *msgs = [NSMutableArray array];
//    [msgs addObject:msg];
//
//    //fee
//    NSMutableDictionary *feeAmount = [NSMutableDictionary dictionary];
//    feeAmount[@"amount"] = @"3000000000000000000";
//    feeAmount[@"denom"] = @"bht";
//    NSMutableArray *feeAmounts = [NSMutableArray array];
//    [feeAmounts addObject:feeAmount];
//    NSMutableDictionary *fee = [NSMutableDictionary dictionary];
//    fee[@"amount"] = feeAmounts;
//    fee[@"gas"] = @"3000000";
//
//    //signatures
//    NSMutableDictionary *pubKey = [NSMutableDictionary dictionary];
//    pubKey[@"type"] = kPubKeyType;
//    NSData *publicKey = KUser.rootAccount[@"publicKey"];
//    pubKey[@"value"] = [NSString base64StringFromData:publicKey length:0];
//    NSMutableDictionary *signature = [NSMutableDictionary dictionary];
//    signature[@"pub_key"] = pubKey;
//    signature[@"signature"] = signString;
//    NSMutableArray *signatures = [NSMutableArray array];
//    [signatures addObject:signature];
//
//    //sendTxRequest
//    NSMutableDictionary *TxReq = [NSMutableDictionary dictionary];
//    TxReq[@"msg"] = msgs;
//    TxReq[@"fee"] = fee;
//    TxReq[@"signatures"] = signatures;
//    TxReq[@"memo"] = @"test memo";
//
//    NSMutableDictionary *rpc = [NSMutableDictionary dictionary];
//    rpc[@"mode"] = @"sync";
//    rpc[@"tx"] = TxReq;
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.operationQueue.maxConcurrentOperationCount = 5;
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
//
//    [manager POST:@"http://bhchain-testnet-node1-751700059.ap-northeast-1.elb.amazonaws.com:1317/txs" parameters:rpc headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@ %@",task,error);
//        NSDictionary *dataDic = [error.userInfo[@"com.alamofire.serialization.response.error.data"] mj_JSONObject];
//        NSLog(@"错误信息=%@", [dataDic mj_JSONString]);
//    }];
//
//}
