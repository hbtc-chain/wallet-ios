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
@class XXMappingModel;

NS_ASSUME_NONNULL_BEGIN

/// token 数据库
@interface XXSqliteManager : NSObject

@property (nonatomic, strong) FMDatabase *myFmdb;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, copy)  NSString *sqlitePath;

+ (XXSqliteManager *)sharedSqlite;
//- (void)requestTokens;
- (void)requestDefaultTokens; //请求默认tokens
- (void)requestVerifiedTokens; //请求搜索时推荐tokens

// 币
- (void)insertTokens:(NSArray *)tokens;
- (void)insertToken:(XXTokenModel *)token;
- (NSArray *)tokens; //所有的币
- (NSArray *)showTokens; //用户添加的币
- (NSString *)tokensListString; //所有的币 字符串,隔开
- (NSString *)defaultTokenSymbols; //默认需要添加的symbols
@property (nonatomic, copy) NSMutableArray *defaultTokens; //默认tokens
@property (nonatomic, copy) NSMutableArray *verifiedTokens; //搜索推荐tokens

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

//mapping 兑换
- (void)requestMapping;

- (XXMappingModel *)mappingModelBySymbol:(NSString *)symbol;

/// 是否存在这个币的映射
/// @param symbol 币id
- (BOOL)existMapModel:(NSString *)symbol;
@property (nonatomic, copy) NSMutableArray *mappingTokens;

/// 根据交易类型 返回文案
/// @param type 交易类型
- (NSString *)signType:(NSString *)type;

// 链
- (void)requestChain;

@property (nonatomic, copy) NSMutableArray *chain; //链列表
@end

NS_ASSUME_NONNULL_END
