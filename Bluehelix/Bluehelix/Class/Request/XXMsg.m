//
//  XXMsg.m
//  Bluehelix
//
//  Created by BHEX on 2020/04/16.
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

- (instancetype)initProposalMessageWithfrom:(NSString *)from
                 to:(NSString *)to
             amount:(NSString *)amount
              denom:(NSString *)denom
          feeAmount:(NSString *)feeAmount
             feeGas:(NSString *)feeGas
           feeDenom:(NSString *)feeDenom
               memo:(NSString *)memo
               type:(NSString *)type
       proposalType:(NSString *)proposalType
      proposalTitle:(NSString *)proposalTitle
proposalDescription:(NSString *)proposalDescription
         proposalId:(NSString*)proposalId
    proposalOption:(NSString*)proposalOption
     withdrawal_fee:(NSString *)withdrawal_fee
              text:(NSString *)text{
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
        _proposalType = proposalType;
        _proposalTitle = proposalTitle;
        _proposalDescription= proposalDescription;
        _proposalId = proposalId;
        _proposalOption = proposalOption;
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
        value[@"from"] = KUser.address;
        value[@"to"] = KUser.address;
        value[@"order_id"] = _uuid;
        value[@"symbol"] = _denom;
        
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
    } else if ([_type isEqualToString:kMsgDelegate] || [_type isEqualToString:kMsgUndelegate]){
        NSMutableDictionary *amount = [NSMutableDictionary dictionary];
        amount[@"amount"] = _amount;
        amount[@"denom"] = _denom;
//        NSMutableArray *amounts = [NSMutableArray array];
//        [amounts addObject:amount];
        
        NSMutableDictionary *value = [NSMutableDictionary dictionary];
        value[@"amount"] = amount;
        value[@"delegator_address"] = _fromAddress;
        value[@"validator_address"] = _toAddress;
        
        NSMutableDictionary *msg = [NSMutableDictionary dictionary];
        msg[@"type"] = _type;
        msg[@"value"] = value;
        [msgs addObject:msg];
    }else if ([_type isEqualToString:kMsgCreateProposal]){
        NSMutableDictionary *amount = [NSMutableDictionary dictionary];
        amount[@"amount"] = _amount;
        amount[@"denom"] = _denom;
        NSMutableArray *amounts = [NSMutableArray array];
        [amounts addObject:amount];
        
        NSMutableDictionary *contentValue = [NSMutableDictionary dictionary];
        contentValue[@"title"] = _proposalTitle;
        contentValue[@"description"] = _proposalDescription;
        
        NSMutableDictionary *content = [NSMutableDictionary dictionary];
        content[@"type"]  = _proposalType;
        content[@"value"] = contentValue;
    
        NSMutableDictionary *value = [NSMutableDictionary dictionary];
        value[@"content"] = content;
        value[@"proposer"] = _fromAddress;
        value[@"initial_deposit"] = amounts;
        
        NSMutableDictionary *msg = [NSMutableDictionary dictionary];
        msg[@"type"] = _type;
        msg[@"value"] = value;
        [msgs addObject:msg];
    }else if ([_type isEqualToString:kMsgPledge]){
        NSMutableDictionary *amount = [NSMutableDictionary dictionary];
        amount[@"amount"] = _amount;
        amount[@"denom"] = _denom;
        NSMutableArray *amounts = [NSMutableArray array];
        [amounts addObject:amount];

        NSMutableDictionary *value = [NSMutableDictionary dictionary];
        value[@"amount"] = amounts;
        value[@"depositor"] = _fromAddress;
        value[@"proposal_id"] = _proposalId;
                
        NSMutableDictionary *msg = [NSMutableDictionary dictionary];
        msg[@"type"] = _type;
        msg[@"value"] = value;
        [msgs addObject:msg];
    }else if([_type isEqualToString:kMsgVote]){
        NSMutableDictionary *value = [NSMutableDictionary dictionary];
        value[@"option"] = _proposalOption;
        value[@"voter"] = _fromAddress;
        value[@"proposal_id"] = _proposalId;
                
        NSMutableDictionary *msg = [NSMutableDictionary dictionary];
        msg[@"type"] = _type;
        msg[@"value"] = value;
        [msgs addObject:msg];
    } else if ([_type isEqualToString:kMsgNewToken]) {
        NSMutableDictionary *value = [NSMutableDictionary dictionary];
        value[@"from"] = KUser.address;
        value[@"to"] = _toAddress;
        value[@"name"] = _denom;
        value[@"decimals"] = _decimals;
        value[@"total_supply"] = _amount;
        
        NSMutableDictionary *msg = [NSMutableDictionary dictionary];
        msg[@"type"] = kMsgNewToken;
        msg[@"value"] = value;
        [msgs addObject:msg];
    } else if ([_type isEqualToString:kMsgMappingSwap]) {
        NSMutableDictionary *amount = [NSMutableDictionary dictionary];
        amount[@"amount"] = _amount;
        amount[@"denom"] = _denom;
        NSMutableArray *amounts = [NSMutableArray array];
        [amounts addObject:amount];
        
        NSMutableDictionary *value = [NSMutableDictionary dictionary];
        value[@"coins"] = amounts;
        value[@"from"] = _fromAddress;
        value[@"issue_symbol"] = _toAddress;
        
        NSMutableDictionary *msg = [NSMutableDictionary dictionary];
        msg[@"type"] = _type;
        msg[@"value"] = value;
        [msgs addObject:msg];
    } else if([_type isEqualToString:kMsgAddLiquidity]) {
        NSMutableDictionary *value = [NSMutableDictionary dictionary];
        value[@"from"] = _fromAddress;
        value[@"token_a"] = _token_a;
        value[@"token_b"] = _token_b;
        value[@"min_token_a_amount"] = _min_token_a_amount;
        value[@"min_token_b_amount"] = _min_token_b_amount;
        value[@"expired_at"] = _expired_at;
        
        NSMutableDictionary *msg = [NSMutableDictionary dictionary];
        msg[@"type"] = kMsgAddLiquidity;
        msg[@"value"] = value;
        [msgs addObject:msg];
    }
    _msgs = msgs;
}

/// 构造msgs 外部传入msg
- (instancetype)initWithFeeAmount:(NSString *)feeAmount
                    feeDenom:(NSString *)feeDenom
                              msg:(id)msg
                        memo:(NSString *)memo
                        text:(NSString *)text {
    self = [super init];
    if (self) {
        _feeAmount = feeAmount;
        _feeDenom = feeDenom;
        _memo = memo;
        _text = text;
        _uuid  = [FCUUID uuid];
        _msgs = [NSMutableArray array];
        [_msgs addObject:msg];
    }
    return self;
}
@end
