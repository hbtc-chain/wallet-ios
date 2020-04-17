//
//  XXMsg.m
//  Bluehelix
//
//  Created by 袁振 on 2020/04/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXMsg.h"
#import "FCUUID.h"
@interface XXMsg()

@property (nonatomic, strong) NSString *uuid;

@end

@implementation XXMsg

- (instancetype)initWithfrom:(NSString *)from
                          to:(NSString *)to
                      amount:(NSString *)amount
                       denom:(NSString *)denom
                   feeAmount:(NSString *)feeAmount
                      feeGas:(NSString *)feeGas
                    feeDenom:(NSString *)feeDenom
                        memo:(NSString *)memo
                        type:(NSString *)type
              withdrawal_fee:(NSString *)withdrawal_fee
                        text:(NSString *)text {
    self = [super init];
    if (self) {
        _fromAddress = from;
        _toAddress = to;
        _amount = amount;
        _denom = denom;
        _feeAmount = feeAmount;
        _feeGas = feeGas;
        _feeDenom = feeDenom;
        _memo = memo;
        _type = type;
        _withdrawal_fee = withdrawal_fee;
        _text = text;
        [self buildMsgs];
    }
    return self;
}

/// 构造msgs
- (void)buildMsgs {
    _uuid  = [FCUUID uuid];
    NSMutableArray *msgs = [NSMutableArray array];
    if ([_type isEqualToString:kMsgSend]) {
        NSMutableDictionary *amount = [NSMutableDictionary dictionary];
        amount[@"amount"] = _amount;
        amount[@"denom"] = _denom;
        NSMutableArray *amounts = [NSMutableArray array];
        [amounts addObject:amount];
        
        NSMutableDictionary *value = [NSMutableDictionary dictionary];
        value[@"amount"] = amounts;
        value[@"from_address"] = _fromAddress;
        value[@"to_address"] = _toAddress;
        
        NSMutableDictionary *msg = [NSMutableDictionary dictionary];
        msg[@"type"] = _type;
        msg[@"value"] = value;
        [msgs addObject:msg];
    } else if([_type isEqualToString:kMsgKeyGen]) {
        NSMutableDictionary *value = [NSMutableDictionary dictionary];
        value[@"From"] = KUser.address;
        value[@"To"] = KUser.address;
        value[@"OrderId"] = _uuid;
        value[@"Symbol"] = _denom;
        
        NSMutableDictionary *msg = [NSMutableDictionary dictionary];
        msg[@"type"] = kMsgKeyGen;
        msg[@"value"] = value;
        [msgs addObject:msg];
    } else if ([_type isEqualToString:kMsgWithdrawal]) {
           NSMutableDictionary *value = [NSMutableDictionary dictionary];
           value[@"from_cu"] = _fromAddress;
           value[@"to_multi_sign_address"] = _toAddress;
           value[@"order_id"] = self.uuid;
           value[@"symbol"] = _denom;
           value[@"amount"] = _amount;
           value[@"gas_fee"] = _withdrawal_fee;

           NSMutableDictionary *msg = [NSMutableDictionary dictionary];
           msg[@"type"] = kMsgWithdrawal;
           msg[@"value"] = value;
           [msgs addObject:msg];
    }
    _msgs = msgs;
}

@end
