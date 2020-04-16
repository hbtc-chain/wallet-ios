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
                        memo:(NSString *)memo
                        type:(NSString *)type
                        withdrawal_fee:(NSString *)withdrawal_fee {
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
    }
    return self;
}

@end
