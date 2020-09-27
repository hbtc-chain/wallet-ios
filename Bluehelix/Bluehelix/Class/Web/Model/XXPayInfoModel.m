//
//  XXPayInfoModel.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/27.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXMsgAddLiquidityModel.h"
#import "XXPayInfoModel.h"
#import "XXTokenModel.h"
#import "XXMsgSwapExact.h"

@implementation XXPayInfoModel

- (id)initWithData:(id)data {
    self = [super init];
    if (self) {
        NSString *type = data[@"type"];
        NSDictionary *value = data[@"value"];
        if ([type isEqualToString:kMsgAddLiquidity]) { //添加流动性
            XXMsgAddLiquidityModel *model = [XXMsgAddLiquidityModel mj_objectWithKeyValues:value];
            self.titleArr = @[LocalizedString(@"PayInfo"),LocalizedString(@"PayToken"),LocalizedString(@"PayToken"),LocalizedString(@"PayAddress"),LocalizedString(@"Gas")];
            
            NSString *aTokenAmount = [self amountWithToken:model.token_a amount:model.min_token_a_amount];
            NSString *bTokenAmount = [self amountWithToken:model.token_b amount:model.min_token_b_amount];
            [self.valueArr addObject:LocalizedString(@"MsgAddLiquidity")];
            [self.valueArr addObject:aTokenAmount];
            [self.valueArr addObject:bTokenAmount];
            [self.valueArr addObject:model.from];
            [self.valueArr addObject:[NSString stringWithFormat:@"%@ %@",kMinFee,[kMainToken uppercaseString]]];
        } else if ([type isEqualToString:kMsgRemoveLiquidity]) { //移除流动性
            XXMsgAddLiquidityModel *model = [XXMsgAddLiquidityModel mj_objectWithKeyValues:value];
            self.titleArr = @[LocalizedString(@"PayInfo"),LocalizedString(@"PayAddress"),LocalizedString(@"Gas")];
            [self.valueArr addObject:LocalizedString(@"MsgRemoveLiquidity")];
            [self.valueArr addObject:model.from];
            [self.valueArr addObject:[NSString stringWithFormat:@"%@ %@",kMinFee,[kMainToken uppercaseString]]];
        } else if ([type isEqualToString:kMsgSwapExactOut]) { //兑换（输出确定）
            XXMsgSwapExact *model = [XXMsgSwapExact mj_objectWithKeyValues:value];
            self.titleArr = @[LocalizedString(@"PayInfo"),LocalizedString(@"PayToken"),LocalizedString(@"PayAddress"),LocalizedString(@"Gas")];
            NSString *aTokenAmount = [self amountWithToken:[model.swap_path firstObject] amount:model.amount_in];
            [self.valueArr addObject:LocalizedString(@"MsgSwapExactOut")];
            [self.valueArr addObject:aTokenAmount];
            [self.valueArr addObject:model.from];
            [self.valueArr addObject:[NSString stringWithFormat:@"%@ %@",kMinFee,[kMainToken uppercaseString]]];
        } else if ([type isEqualToString:kMsgSwapExactIn]) { //兑换（输入确定）
            XXMsgSwapExact *model = [XXMsgSwapExact mj_objectWithKeyValues:value];
            self.titleArr = @[LocalizedString(@"PayInfo"),LocalizedString(@"PayToken"),LocalizedString(@"PayAddress"),LocalizedString(@"Gas")];
            NSString *aTokenAmount = [self amountWithToken:[model.swap_path firstObject] amount:model.amount_in];
            [self.valueArr addObject:LocalizedString(@"MsgSwapExactIn")];
            [self.valueArr addObject:aTokenAmount];
            [self.valueArr addObject:model.from];
            [self.valueArr addObject:[NSString stringWithFormat:@"%@ %@",kMinFee,[kMainToken uppercaseString]]];
        } else {
            
        }
    }
    return self;
}

// 除以精度 返回原始数量
- (NSString *)amountWithToken:(NSString *)token amount:(NSString *)amount {
    XXTokenModel *token_a = [[XXSqliteManager sharedSqlite] tokenBySymbol:token];
    NSDecimalNumber *aTokenAmountDecimal = [NSDecimalNumber decimalNumberWithString:amount];
    NSString *aTokenAmountString = [[aTokenAmountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token_a.decimals)] stringValue];
    return [NSString stringWithFormat:@"%@ %@",aTokenAmountString, [token uppercaseString]];
}

- (NSMutableArray *)valueArr {
    if (!_valueArr) {
        _valueArr = [[NSMutableArray alloc] init];
    }
    return _valueArr;
}

@end
