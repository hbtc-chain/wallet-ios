//
//  XXSqliteManager.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/04.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@class XXAccountModel;
@class XXTokenModel;

NS_ASSUME_NONNULL_BEGIN

/// token 数据库
@interface XXSqliteManager : NSObject

@property (nonatomic, strong) FMDatabase *myFmdb;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, copy)  NSString *sqlitePath;

+ (XXSqliteManager *)sharedSqlite;
- (void)requestTokens;
// 币
- (void)insertTokens:(NSArray *)tokens;
- (NSArray *)tokens; //所有的币
- (NSArray *)showTokens; //用户添加的币
- (NSString *)tokensListString; //所有的币 字符串,隔开

// 账户
- (NSArray *)accounts;
- (BOOL)insertAccount:(XXAccountModel *)model;
- (XXAccountModel *)accountByAddress:(NSString *)address;
- (void)updateAccountColumn:(NSString *)column value:(id)value;
- (void)deleteAccountByAddress:(NSString *)address;
- (void)insertSymbol:(NSString *)symbol;
- (void)deleteSymbol:(NSString *)symbol;


/// 查询跨链手续费对应的token
/// @param token 需要跨链的token
- (XXTokenModel *)withdrawFeeToken:(XXTokenModel *)token;

/// 查询symbol对应的tokenModel
/// @param symbol 币名
- (XXTokenModel *)tokenBySymbol:(NSString *)symbol;
@end

NS_ASSUME_NONNULL_END
