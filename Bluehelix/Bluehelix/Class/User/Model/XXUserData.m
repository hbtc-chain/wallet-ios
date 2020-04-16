//
//  XXUserData.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXUserData.h"


@implementation XXUserData

static XXUserData *_sharedUserData = nil;
+ (XXUserData *)sharedUserData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUserData = [[XXUserData alloc] init];
    });
    return _sharedUserData;
}

// 夜间模式
- (void)setIsNightType:(BOOL)isNightType {
    [self saveValeu:@(isNightType) forKey:@"isNightType"];
}

- (BOOL)isNightType {
    return [[self getValueForKey:@"isNightType"] boolValue];
}

// 手动设置夜间模式 非系统默认
- (void)setIsSettedNightType:(BOOL)isSettedNightType {
    [self saveValeu:@(isSettedNightType) forKey:@"isSettedNightTypeKey"];
}

- (BOOL)isSettedNightType {
    return [[self getValueForKey:@"isSettedNightTypeKey"] integerValue];
}

// 隐藏小额币种
- (void)setIsHideSmallCoin:(BOOL)isHideSmallCoin {
    [self saveValeu:@(isHideSmallCoin) forKey:@"isHideSmallCoin"];
}

- (BOOL)isHideSmallCoin {
    return [[self getValueForKey:@"isHideSmallCoin"] integerValue];
}

// 是否隐藏资产
- (void)setIsHideAsset:(BOOL)isHideAsset {
    [self saveValeu:@(isHideAsset) forKey:@"isHideAsset"];
}

- (BOOL)isHideAsset {
    return [[self getValueForKey:@"isHideAsset"] integerValue];
}

// 临时用户名
- (void)setLocalUserName:(NSString *)localUserName {
    [self saveValeu:localUserName forKey:@"localUserName"];
}

- (NSString *)localUserName {
    return [self getValueForKey:@"localUserName"];
}

- (void)setRatesKey:(NSString *)ratesKey {
    [self saveValeu:ratesKey forKey:@"ratesKey"];
}

- (NSString *)ratesKey {
    return [self getValueForKey:@"ratesKey"];
}
//// pubkey
//- (void)setPubKey:(NSString *)pubKey {
//    [self saveValeu:pubKey forKey:@"pubKey"];
//}
//
//- (NSString *)pubKey {
//    return [self getValueForKey:@"pubKey"];
//}

// 临时密码
- (void)setLocalPassword:(NSString *)localPassword {
    [self saveValeu:localPassword forKey:@"localPassword"];
}

- (NSString *)localPassword {
    return [self getValueForKey:@"localPassword"];
}

// 临时助记词
- (void)setLocalPhraseString:(NSString *)localPhraseString {
    [self saveValeu:localPhraseString forKey:@"localPhraseString"];
}

- (NSString *)localPhraseString {
    return [self getValueForKey:@"localPhraseString"];
}

// 临时私钥
- (void)setLocalPrivateKey:(NSString *)localPrivateKey {
    [self saveValeu:localPrivateKey forKey:@"localPrivateKey"];
}

- (NSString *)localPrivateKey {
    return [self getValueForKey:@"localPrivateKey"];
}

// 当前账户
- (XXAccountModel *)currentAccount {
   return [[XXSqliteManager sharedSqlite] accountByAddress:KUser.address];
}

// 当前账户地址
- (void)setAddress:(NSString *)address {
    [self saveValeu:address forKey:@"address"];
}

- (NSString *)address {
    return [self getValueForKey:@"address"];
}

//// 账户数组
- (NSArray *)accounts {
    return [[XXSqliteManager sharedSqlite] accounts];
}

-(id)getValueForKey:(NSString*)key{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value;
}

-(void)saveValeu:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//- (void)addAccount:(NSDictionary *)account {
//    NSArray *oldArray = [self getValueForKey:@"accounts"];
//    if (!oldArray) {
//        oldArray = [NSMutableArray array];
//    }
//    NSMutableArray *array = [NSMutableArray arrayWithArray:oldArray];
//    [array addObject:account];
//    [self saveValeu:array forKey:@"accounts"];
//}

//- (NSString *)increaseID {
//   NSString *increaseID = [self getValueForKey:@"increaseID"];
//    if (increaseID) {
//        int num = increaseID.intValue +1;
//        [self saveValeu:[NSString stringWithFormat:@"%d",num] forKey:@"increaseID"];
//        return [NSString stringWithFormat:@"%d",num];
//    } else {
//        [self saveValeu:@"0" forKey:@"increaseID"];
//        return @"0";
//    }
//}

@end
