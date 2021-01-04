//
//  XXUserData.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXUserData.h"

static NSString *salt = @"XX";

@implementation XXUserData

static XXUserData *_sharedUserData = nil;
+ (XXUserData *)sharedUserData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUserData = [[XXUserData alloc] init];
    });
    return _sharedUserData;
}

// 清空数据
- (void)cleanAllData {
    NSUserDefaults *defatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dics = [defatluts dictionaryRepresentation];
    for(NSString *key in [dics allKeys]){
        [defatluts removeObjectForKey:key];
        [defatluts synchronize];
    }
}

//删除测试网数据 TODO 新版本可去掉
- (void)cleanTestData {
    if (!self.deleteFlag) {
        [self cleanAllData];
        self.deleteFlag = YES;
    }
}

- (void)setDeleteFlag:(BOOL)deleteFlag {
    [self saveValue:@(deleteFlag) forKey:@"deleteFlag"];
}

- (BOOL)deleteFlag {
    return [[self getValueForKey:@"deleteFlag"] boolValue];
}

// 夜间模式
- (void)setIsNightType:(BOOL)isNightType {
    [self saveValue:@(isNightType) forKey:@"isNightType"];
}

- (BOOL)isNightType {
    return [[self getValueForKey:@"isNightType"] boolValue];
}

// 手动设置夜间模式 非系统默认
- (void)setIsSettedNightType:(BOOL)isSettedNightType {
    [self saveValue:@(isSettedNightType) forKey:@"isSettedNightTypeKey"];
}

- (BOOL)isSettedNightType {
    return [[self getValueForKey:@"isSettedNightTypeKey"] integerValue];
}

// 隐藏小额币种
- (void)setIsHideSmallCoin:(BOOL)isHideSmallCoin {
    [self saveValue:@(isHideSmallCoin) forKey:@"isHideSmallCoin"];
}

- (BOOL)isHideSmallCoin {
    return [[self getValueForKey:@"isHideSmallCoin"] integerValue];
}

// 是否隐藏资产
- (void)setIsHideAsset:(BOOL)isHideAsset {
    [self saveValue:@(isHideAsset) forKey:@"isHideAsset"];
}

- (BOOL)isHideAsset {
    return [[self getValueForKey:@"isHideAsset"] integerValue];
}

// 币种排序 降序
- (void)setTokenSortDes:(BOOL)tokenSortDes {
    [self saveValue:@(tokenSortDes) forKey:@"tokenSortDes"];
}

- (BOOL)tokenSortDes {
    return [[self getValueForKey:@"tokenSortDes"] integerValue];
}

// 是否阅读协议
- (void)setAgreeService:(BOOL)agreeService {
    [self saveValue:@(agreeService) forKey:@"agreeService"];
}

- (BOOL)agreeService {
    return [[self getValueForKey:@"agreeService"] integerValue];
}

/// 是否开启免密码
- (void)setIsQuickTextOpen:(BOOL)isQuickTextOpen {
    [self saveValue:@(isQuickTextOpen) forKey:@"isQuickTextOpen"];
}

- (BOOL)isQuickTextOpen {
    return [[self getValueForKey:@"isQuickTextOpen"] integerValue];
}

/// 最近一次免密码时间
- (void)setLastPasswordTime:(NSString *)lastPasswordTime {
    [self saveValue:lastPasswordTime forKey:@"lastPasswordTime"];
}

- (NSString *)lastPasswordTime {
    return [self getValueForKey:@"lastPasswordTime"];
}

/// 是否需要弹出密码框输入密码
- (BOOL)showPassword {
    if (!self.isQuickTextOpen) { //没有打开免密码
        return YES;
    }
    if (IsEmpty(self.passwordText)) { //没有保存密码
        return YES;
    }
    if (self.lastPasswordTime) {
        // 判断当前时间 - 记录时间 > 30分钟
        long long lastTime = [self.lastPasswordTime longLongValue];
        long long currentTime = [[NSDate date] timeIntervalSince1970];
        if (currentTime - lastTime > 1800) {
            self.isQuickTextOpen = NO;
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
    return YES;
}

- (void)setRatesKey:(NSString *)ratesKey {
    [self saveValue:ratesKey forKey:@"ratesKey"];
}

- (NSString *)ratesKey {
    
    if ([self getValueForKey:@"ratesKey"] == nil) {
        if ([[[LocalizeHelper sharedLocalSystem] getLanguageCode] hasPrefix:@"zh-"]) {
            [self setRatesKey:@"cny"];
            return @"cny";
        } else if ([[[LocalizeHelper sharedLocalSystem] getLanguageCode] hasPrefix:@"ko"]) {
            [self setRatesKey:@"krw"];
            return @"krw";
        } else if ([[[LocalizeHelper sharedLocalSystem] getLanguageCode] hasPrefix:@"ja"]) {
            [self setRatesKey:@"jpy"];
            return @"jpy";
        } else if ([[[LocalizeHelper sharedLocalSystem] getLanguageCode] hasPrefix:@"vi"]) {
            [self setRatesKey:@"vnd"];
            return @"vnd";
        } else {
            [self setRatesKey:@"usd"];
            return @"usd";
        }
    }
    return [self getValueForKey:@"ratesKey"];
}

- (void)setIsFaceIDLockOpen:(BOOL)isFaceIDLockOpen {
    [self saveValue:@(isFaceIDLockOpen) forKey:@"FaceIDLockOpen"];
}

- (BOOL)isFaceIDLockOpen {
    return [[self getValueForKey:@"FaceIDLockOpen"] boolValue];
}

- (BOOL)isTouchIDLockOpen {
    return [[self getValueForKey:@"TouchIDLockOpen"] boolValue];
}

- (void)setIsTouchIDLockOpen:(BOOL)isTouchIDLockOpen {
    [self saveValue:@(isTouchIDLockOpen) forKey:@"TouchIDLockOpen"];
}

- (void)setHaveLogged:(BOOL)haveLogged {
    [self saveValue:@(haveLogged) forKey:@"HaveLogged"];
}

- (BOOL)haveLogged {
    return [[self getValueForKey:@"HaveLogged"] boolValue];
}

- (BOOL)shouldVerify {
    return [[self getValueForKey:@"BHShouldVerify"] boolValue];
}

- (void)setShouldVerify:(BOOL)shouldVerify {
    [self saveValue:@(shouldVerify) forKey:@"BHShouldVerify"];
}

// 当前账户
- (XXAccountModel *)currentAccount {
    return [[XXSqliteManager sharedSqlite] accountByAddress:KUser.address];
}

// 当前账户地址
- (void)setAddress:(NSString *)address {
    if ([self.address isEqualToString:address]) {
        return;
    } else {
        self.passwordText = @"";
        self.privateKey = @"";
        self.lastPasswordTime = @"";
        self.isQuickTextOpen = NO;
        [self saveValue:address forKey:@"address"];
    }
}

- (NSString *)address {
    return [self getValueForKey:@"address"];
}

- (void)setFee:(NSString *)fee {
    [self saveValue:fee forKey:@"fee"];
}

- (NSString *)fee {
    if (IsEmpty([self getValueForKey:@"fee"])) {
        return @"2000000000000000";
    } else {
        return [self getValueForKey:@"fee"];
    }
}

- (NSString *)showFee {
    NSDecimalNumber *feeDecimal =  [NSDecimalNumber decimalNumberWithString:self.fee];
    return [[feeDecimal decimalNumberByDividingBy:kPrecisionDecimal] stringValue];
}

- (void)setGas:(NSString *)gas {
    [self saveValue:gas forKey:@"gas"];
}

- (NSString *)gas {
    if (IsEmpty([self getValueForKey:@"gas"])) {
        return @"2000000";
    } else {
        return [self getValueForKey:@"gas"];
    }
}

- (void)setTokenString:(NSString *)tokenString {
    [self saveValue:tokenString forKey:@"tokenStringKey"];
}

- (NSString *)tokenString {
    return [self getValueForKey:@"tokenStringKey"];
}

- (void)setDefaultTokens:(NSString *)defaultTokens {
    [self saveValue:defaultTokens forKey:@"defaultTokensKey"];
}

- (NSString *)defaultTokens {
    return [self getValueForKey:@"defaultTokensKey"];
}

- (void)setVerifiedTokens:(NSString *)verifiedTokens {
    [self saveValue:verifiedTokens forKey:@"verifiedTokensKey"];
}

- (NSString *)verifiedTokens {
    return [self getValueForKey:@"verifiedTokensKey"];
}

- (void)setChainString:(NSString *)chainString {
    [self saveValue:chainString forKey:@"chainStringKey"];
}

- (NSString *)chainString {
    return [self getValueForKey:@"chainStringKey"];
}

// 网络状态
- (void)setNetWorkStatus:(NSString *)netWorkStatus {
    [self saveValue:netWorkStatus forKey:@"netWorkStatus"];
}

- (NSString *)netWorkStatus {
    return [self getValueForKey:@"netWorkStatus"];
}

//// 账户数组
- (NSArray *)accounts {
    return [[XXSqliteManager sharedSqlite] accounts];
}

-(id)getValueForKey:(NSString*)key{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value;
}

-(void)saveValue:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
