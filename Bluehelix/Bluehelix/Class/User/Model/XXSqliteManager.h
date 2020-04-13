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

NS_ASSUME_NONNULL_BEGIN

/// token 数据库
@interface XXSqliteManager : NSObject

@property (nonatomic, strong) FMDatabase *myFmdb;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, copy)  NSString *sqlitePath;

+ (XXSqliteManager *)sharedSqlite;

// 币
- (void)insertTokens:(NSArray *)tokens;
- (NSArray *)tokens; //所有的币
- (NSArray *)showTokens; //用户添加的币

// 账户
- (NSArray *)accounts;
- (BOOL)insertAccount:(XXAccountModel *)model;
- (XXAccountModel *)accountByAddress:(NSString *)address;
- (void)updateAccountColumn:(NSString *)column value:(id)value;
- (void)deleteAccountByAddress:(NSString *)address;
- (void)insertSymbol:(NSString *)symbol;
- (void)deleteSymbol:(NSString *)symbol;
@end

NS_ASSUME_NONNULL_END
