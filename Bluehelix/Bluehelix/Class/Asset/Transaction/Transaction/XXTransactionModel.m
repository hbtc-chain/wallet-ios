//
//  XXTransactionModel.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/08.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTransactionModel.h"

@implementation XXTransactionModel

- (instancetype)initWithfrom:(NSString *)from
                          to:(NSString *)to
                      amount:(NSString *)amount
                       denom:(NSString *)denom
                   feeAmount:(NSString *)feeAmount
                      feeGas:(NSString *)feeGas
                    feeDenom:(NSString *)feeDenom
                        memo:(NSString *)memo {
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
    }
    return self;
}

- (instancetype)initwithActivity:(NSDictionary *)dic {
    XXTransactionModel *model = [[XXTransactionModel alloc] init];
    NSString *type = dic[@"type"];
    if ([type isEqualToString:kMsgSend]) {
        model.type = LocalizedString(@"Transfer");
    } else if ([type isEqualToString:kMsgDelegate]) {
        model.type = LocalizedString(@"Delegate");
    } else if ([type isEqualToString:kMsgUndelegate]) {
        model.type = LocalizedString(@"TransferDelegate");
    } else if ([type isEqualToString:kMsgKeyGen]) {
        model.type = LocalizedString(@"ChainAddress");
    } else if ([type isEqualToString:kMsgDeposit]) {
        model.type = LocalizedString(@"ChainDeposit");
    } else if ([type isEqualToString:kMsgWithdrawal]) {
        model.type = LocalizedString(@"ChainWithdrawal");
    } else {
        model.type = @"";
    }
    NSDictionary *value = dic[@"value"];
    model.fromAddress = value[@"from_address"];
    model.toAddress = value[@"to_address"];
    NSString *amountString;
    if ([value[@"amount"] isKindOfClass:[NSArray class]]) {
        NSArray *amounts = value[@"amount"];
        NSDictionary *amount = [amounts firstObject];
        amountString = amount[@"amount"];
    }
    if ([value[@"amount"] isKindOfClass:[NSString class]]) {
        amountString = value[@"amount"];
    }
    if ([value[@"amount"] isKindOfClass:[NSNumber class]]) {
        amountString = [value[@"amount"] stringValue];
    }
    if (IsEmpty(amountString)) {
        model.amount = @"";
        return model;
    }
    double num = amountString.doubleValue/kPrecision;
    if ([model.fromAddress isEqualToString:KUser.address]) {
        model.amount = [NSString stringWithFormat:@"-%f",num];
    } else {
        model.amount = [NSString stringWithFormat:@"+%f",num];
    }
    return model;
}

@end
