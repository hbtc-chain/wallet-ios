//
//  RatesManager.m
//  Bhex
//
//  Created by BHEX on 2018/7/11.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "RatesManager.h"

@interface RatesManager ()

/** tokenString */
@property (strong, nonatomic, nullable) NSString *arrayString;

/** tokenString */
@property (strong, nonatomic, nullable) NSString *tokenString;

@end

@implementation RatesManager
static RatesManager *_ratesManager;
+ (RatesManager *)shareRatesManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ratesManager = [[RatesManager alloc] init];
    });
    return _ratesManager;
}

#pragma mark - 1. 加载汇率数据
- (void)loadDataOfRates {
//    if (IsEmpty(self.tokenString)) {
        self.tokenString = [[XXSqliteManager sharedSqlite] tokensListString];
//    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"symbols"] = self.tokenString;
    MJWeakSelf
    [HttpManager postWithPath:@"/api/v1/tokenprices" params:params andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            if (IsEmpty(data)) {
                [weakSelf performSelector:@selector(loadDataOfRates) withObject:nil afterDelay:3];
            } else {
                NSArray *dataArray = data;
                if (dataArray > 0) {
                    weakSelf.ratesArray = [NSMutableArray arrayWithArray:dataArray];
                    [weakSelf updataDataDic];
                }
                [weakSelf performSelector:@selector(loadDataOfRates) withObject:nil afterDelay:60];
            }
        } else {
            [weakSelf performSelector:@selector(loadDataOfRates) withObject:nil afterDelay:3];
        }
    }];
}

- (void)cancelTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (NSString *_Nullable)getPriceFromToken:(NSString *_Nullable)token {
    double rates = 0.0;
    NSDictionary *dict = self.dataDic[token];
       if (dict) {
           rates = [dict[KUser.ratesKey] doubleValue];
           if (rates < 0) {
               return @"--";
           }
       } else {
           return @"--";
       }
    if ([KUser.ratesKey isEqualToString:@"cny"]) {
           return [NSString stringWithFormat:@"≈¥%.2f", rates];
       } else if ([KUser.ratesKey isEqualToString:@"usd"]) {
           return [NSString stringWithFormat:@"≈$%.2f", rates];
       } else if ([KUser.ratesKey isEqualToString:@"krw"]) {
           return [NSString stringWithFormat:@"≈₩%.2f", rates];
       } else if ([KUser.ratesKey isEqualToString:@"jpy"]) {
           return [NSString stringWithFormat:@"≈¥%.2f", rates];
       } else if ([KUser.ratesKey isEqualToString:@"vnd"]) {
           return [NSString stringWithFormat:@"≈₫%.2f", rates];
       } else {
           return @"--";
       }
}

#pragma mark - 2. 获取法币
- (NSString *)getRatesWithToken:(NSString *)tokenId priceValue:(double)priceValue {
    if (!self.ratesArray) {
        NSString *ratesString = [self getValueForKey:@"ratesArrayKey"];
        self.ratesArray = [ratesString mj_JSONObject];
        [self updataDataDic];
    }
    double rates = 0.0;
    NSDictionary *dict = self.dataDic[tokenId];
    if (dict) {
        rates = [dict[KUser.ratesKey] doubleValue];
        if (rates < 0) {
            return @"--";
        }
    } else {
        return @"--";
    }
    
    if ([KUser.ratesKey isEqualToString:@"cny"]) {
        return [NSString stringWithFormat:@"≈¥%.2f",rates*priceValue];
    } else if ([KUser.ratesKey isEqualToString:@"usd"]) {
        return [NSString stringWithFormat:@"≈$%.2f",rates*priceValue];
    } else if ([KUser.ratesKey isEqualToString:@"krw"]) {
        return [NSString stringWithFormat:@"≈₩%.2f",rates*priceValue];
    } else if ([KUser.ratesKey isEqualToString:@"jpy"]) {
        return [NSString stringWithFormat:@"≈¥%.2f",rates*priceValue];
    } else if ([KUser.ratesKey isEqualToString:@"vnd"]) {
        return [NSString stringWithFormat:@"≈₫%.2f",rates*priceValue];
    } else {
        return @"--";
    }
}

- (NSString *_Nullable)rateUnit {
    if ([KUser.ratesKey isEqualToString:@"cny"]) {
        return @"¥";
    } else if ([KUser.ratesKey isEqualToString:@"usd"]) {
        return @"$";
    } else if ([KUser.ratesKey isEqualToString:@"krw"]) {
        return @"₩";
    } else if ([KUser.ratesKey isEqualToString:@"jpy"]) {
        return @"¥";
    } else if ([KUser.ratesKey isEqualToString:@"vnd"]) {
        return @"₫";
    } else {
        return @"--";
    }
}

- (NSString *)getTwoRatesWithToken:(NSString *)tokenId priceValue:(double)priceValue {
    if (!self.ratesArray) {
        NSString *ratesString = [self getValueForKey:@"ratesArrayKey"];
        self.ratesArray = [ratesString mj_JSONObject];
        [self updataDataDic];
    }
    double rates = 0.0;
    NSDictionary *dict = self.dataDic[tokenId];
    if (dict) {
        rates = [dict[KUser.ratesKey] doubleValue];
        if (rates < 0) {
            return @"--";
        }
    } else {
        return @"--";
    }

    NSString *money = [NSString stringWithFormat:@"%.12f", rates*priceValue];
    return [KDecimal decimalNumber:money RoundingMode:NSRoundDown scale:2];
}


- (NSString *)getRatesFromToken:(NSString *)fromtokenId fromPrice:(double)fromPrice coinName:(NSString *)coinName {
    if (!self.ratesArray) {
        NSString *ratesString = [self getValueForKey:@"ratesArrayKey"];
        self.ratesArray = [ratesString mj_JSONObject];
        [self updataDataDic];
    }
    
    double rates = 0.0;
    NSDictionary *dict = self.dataDic[fromtokenId];
    if (dict) {
        rates = [dict[coinName] doubleValue];
        if (rates < 0) {
            return @"--";
        }
    } else {
        return @"--";
    }
    
    NSString *money = [NSString stringWithFormat:@"%.8f", rates*fromPrice];
    return money;
}

- (void)setRatesArray:(NSMutableArray *)ratesArray {
    _ratesArray = ratesArray;
    [self saveValue:[ratesArray mj_JSONString] forKey:@"ratesArrayKey"];
}

- (void)updataDataDic {
    for (NSInteger i=0; i < self.ratesArray.count; i ++) {
        NSDictionary *dict = self.ratesArray[i];
        NSString *token = dict[@"token"];
        if (token) {
            self.dataDic[token] = dict[@"rates"];
        }
    }
}

#pragma mark 存取方法
-(id)getValueForKey:(NSString*)key{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value;
}

-(void)saveValue:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableDictionary *)dataDic {
    if (_dataDic == nil) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
@end
