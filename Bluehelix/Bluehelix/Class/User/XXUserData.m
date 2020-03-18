//
//  XXUserData.m
//  Bluehelix
//
//  Created by 袁振 on 2020/03/16.
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

// 临时用户名
- (void)setLocalUserName:(NSString *)localUserName {
    [self saveValeu:localUserName forKey:@"localUserName"];
}

- (NSString *)localUserName {
    return [self getValueForKey:@"localUserName"];
}

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
- (void)setRootAccount:(NSDictionary *)rootAccount {
    [self saveValeu:rootAccount forKey:@"rootAccount"];
}

- (NSDictionary *)rootAccount {
    return [self getValueForKey:@"rootAccount"];
}

// 账户数组
- (void)setAccounts:(NSMutableArray *)accounts {
    [self saveValeu:accounts forKey:@"accounts"];
}

- (NSMutableArray *)accounts {
    return [self getValueForKey:@"accounts"];
}

-(id)getValueForKey:(NSString*)key{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value;
}

-(void)saveValeu:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addAccount:(NSDictionary *)account {
    NSArray *oldArray = [self getValueForKey:@"accounts"];
    if (!oldArray) {
        oldArray = [NSMutableArray array];
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:oldArray];
    [array addObject:account];
    [self saveValeu:array forKey:@"accounts"];
}

@end
