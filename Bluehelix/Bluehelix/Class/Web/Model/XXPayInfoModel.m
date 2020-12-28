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
            
            NSString *aTokenAmount = [self amountWithToken:model.token_a amount:model.max_token_a_amount];
            NSString *bTokenAmount = [self amountWithToken:model.token_b amount:model.max_token_b_amount];
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
            NSString *aTokenAmount = [self amountWithToken:[model.swap_path firstObject] amount:model.max_amount_in];
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
    if (IsEmpty(amount)) {
        return @"0";
    } else {
        XXTokenModel *token_a = [[XXSqliteManager sharedSqlite] tokenBySymbol:token];
        if (!token_a) {
            return @"";
        }
        NSDecimalNumber *aTokenAmountDecimal = [NSDecimalNumber decimalNumberWithString:amount];
        NSString *aTokenAmountString = [[aTokenAmountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token_a.decimals)] stringValue];
        return [NSString stringWithFormat:@"%@ %@",aTokenAmountString, [token_a.name uppercaseString]];
    }
}

// 查看本地是否存在token信息 如果不存在返回symbol 
+ (NSString *)analysisSymbol:(id)data {
    NSString *type = data[@"type"];
    NSDictionary *value = data[@"value"];
    if ([type isEqualToString:kMsgAddLiquidity]) { //添加流动性
        XXMsgAddLiquidityModel *model = [XXMsgAddLiquidityModel mj_objectWithKeyValues:value];
        XXTokenModel *token_a = [[XXSqliteManager sharedSqlite] tokenBySymbol:model.token_a];
        XXTokenModel *token_b = [[XXSqliteManager sharedSqlite] tokenBySymbol:model.token_b];
        if (!token_a && !token_b) {
            return [NSString stringWithFormat:@"%@,%@",model.token_a,model.token_b];
        }
        if (!token_a) {
            return model.token_a;
        }
        if (!token_b) {
            return model.token_b;
        }
    } else if ([type isEqualToString:kMsgRemoveLiquidity]) { //移除流动性 不需要
        return @"";
    } else if ([type isEqualToString:kMsgSwapExactOut]) { //兑换（输出确定）
        XXMsgSwapExact *model = [XXMsgSwapExact mj_objectWithKeyValues:value];
        XXTokenModel *token_a = [[XXSqliteManager sharedSqlite] tokenBySymbol:[model.swap_path firstObject]];
        if (!token_a) {
            return [model.swap_path firstObject];
        }
    } else if ([type isEqualToString:kMsgSwapExactIn]) { //兑换（输入确定）
        XXMsgSwapExact *model = [XXMsgSwapExact mj_objectWithKeyValues:value];
        XXTokenModel *token_a = [[XXSqliteManager sharedSqlite] tokenBySymbol:[model.swap_path firstObject]];
        if (!token_a) {
            return [model.swap_path firstObject];
        }
    }
    return @"";
}

- (NSMutableArray *)valueArr {
    if (!_valueArr) {
        _valueArr = [[NSMutableArray alloc] init];
    }
    return _valueArr;
}

@end
