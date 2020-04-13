//
//  XXSqliteManager.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/04.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXSqliteManager.h"
#import "XXTokenModel.h"

@implementation XXSqliteManager

static XXSqliteManager *_sqliteManager;
+ (XXSqliteManager *)sharedSqlite {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sqliteManager = [[XXSqliteManager alloc] init];
    });
    return _sqliteManager;
}

- (NSString *)sqlitePath {
    NSString *path = [NSString stringWithFormat:@"%@/Documents/wallet.db", NSHomeDirectory()];
    NSLog(@"path = %@",path);
    return path;
}

- (FMDatabase *)myFmdb {
    if (!_myFmdb) {
        _myFmdb = [FMDatabase databaseWithPath:[self sqlitePath]];
    }
    return _myFmdb;
}

#pragma mark 币
- (BOOL)existsTokens {
    [self.myFmdb open];
    BOOL result = [self.myFmdb executeUpdate:@"create table if not exists tokens(ID INTEGER PRIMARY KEY AUTOINCREMENT,symbol TEXT,chain TEXT,decimals INTEGER,is_native BOOLEAN)"];
    return result;
}

- (void)insertTokens:(NSArray *)tokens {
    BOOL existsTable = [self existsTokens];
    if (!existsTable) {
        return;
    }
    [self.myFmdb executeUpdate:@"delete from 'tokens'"];
    for (XXTokenModel *model  in tokens) {
        [self.myFmdb executeUpdate:@"insert into 'tokens'(symbol,decimals,is_native) values(?,?,?)" withArgumentsInArray:@[model.symbol,[NSNumber numberWithInt:model.decimals],[NSNumber numberWithInt:model.is_native]]];
    }
}

- (NSArray *)tokens {
    BOOL existsTable = [self existsTokens];
    if (!existsTable) {
        return @[];
    }
    NSString *sql = @"select * from 'tokens'";
    FMResultSet *set = [self.myFmdb executeQuery:sql];
    NSMutableArray *resultArr = [NSMutableArray array];
    while ([set next]) {
        XXTokenModel *model = [[XXTokenModel alloc] init];
        model.symbol = [set stringForColumn:@"symbol"];
        model.decimals = [set intForColumn:@"decimals"];
        model.is_native = [set boolForColumn:@"is_native"];
        [resultArr addObject:model];
    }
    return resultArr;
}

- (NSArray *)showTokens {
    BOOL existsTable = [self existsTokens];
    if (!existsTable) {
        return @[];
    }
    NSString *sql = @"select * from 'tokens'";
    FMResultSet *set = [self.myFmdb executeQuery:sql];
    if (IsEmpty(KUser.currentAccount.symbols)) {
        return @[];
    } else {
        NSArray *symbols = [KUser.currentAccount.symbols componentsSeparatedByString:@","];
        NSMutableArray *resultArr = [NSMutableArray array];
        while ([set next]) {
            XXTokenModel *model = [[XXTokenModel alloc] init];
            model.symbol = [set stringForColumn:@"symbol"];
            model.decimals = [set intForColumn:@"decimals"];
            model.is_native = [set boolForColumn:@"is_native"];
            if ([symbols containsObject:model.symbol]) {
                [resultArr addObject:model];
            }
        }
        return resultArr;
    }
}

#pragma mark 账户
- (BOOL)existsAccount {
    [self.myFmdb open];
    NSString *sql = @"create table if not exists account(ID INTEGER PRIMARY KEY AUTOINCREMENT,address TEXT,userName TEXT,password TEXT,backupFlag INTEGER,mnemonicPhrase TEXT,publicKey,privateKey,symbols TEXT)";
    BOOL result = [self.myFmdb executeUpdate:sql];
    return result;
}

- (BOOL)insertAccount:(XXAccountModel *)model {
    BOOL existsTable = [self existsAccount];
    if (!existsTable) {
        return NO;
    }
    BOOL result = [self.myFmdb executeUpdate:@"insert into 'account'(address,userName,password,backupFlag,publicKey,privateKey,mnemonicPhrase,symbols) values(?,?,?,?,?,?,?,?)" withArgumentsInArray:@[model.address,model.userName,model.password,[NSString stringWithFormat:@"%d",model.backupFlag],model.publicKey,model.privateKey,model.mnemonicPhrase,model.symbols]];
    return result;
}

- (void)deleteAccountByAddress:(NSString *)address {
    BOOL existsTable = [self existsAccount];
    if (!existsTable) {
        return;
    }
    [self.myFmdb executeUpdate:@"delete from 'account' where address = ?" withArgumentsInArray:@[address]];
}

- (void)updateAccountColumn:(NSString *)column value:(id)value {
    BOOL existsTable = [self existsAccount];
    if (!existsTable) {
        return;
    }
    NSString *sql = [NSString stringWithFormat:@"update 'account' set %@ = ? where address = ?",column];
    [self.myFmdb executeUpdate:sql withArgumentsInArray:@[value,KUser.address]];
}

- (XXAccountModel *)accountByAddress:(NSString *)address {
    BOOL existsTable = [self existsAccount];
    if (!existsTable) {
        return nil;
    }
    FMResultSet *set = [self.myFmdb executeQuery:@"select * from account where address = ?",address];
    while ([set next]) {
        XXAccountModel *model = [[XXAccountModel alloc] init];
        model.address = [set stringForColumn:@"address"];
        model.userName = [set stringForColumn:@"userName"];
        model.symbols = [set stringForColumn:@"symbols"];
        model.backupFlag = [set boolForColumn:@"backupFlag"];
        model.password = [set stringForColumn:@"password"];
        model.publicKey = [set dataForColumn:@"publicKey"];
        model.privateKey = [set dataForColumn:@"privateKey"];
        model.mnemonicPhrase = [set stringForColumn:@"mnemonicPhrase"];
        return model;
    }
    return nil;
}

- (NSArray *)accounts {
    BOOL existsTable = [self existsAccount];
    if (!existsTable) {
        return @[];
    }
    // TODO: 老的数据表 新的column???
    NSString *sql = @"select * from 'account'";
    FMResultSet *set = [self.myFmdb executeQuery:sql];
    NSMutableArray *resultArr = [NSMutableArray array];
    while ([set next]) {
        XXAccountModel *model = [[XXAccountModel alloc] init];
        model.address = [set stringForColumn:@"address"];
        model.userName = [set stringForColumn:@"userName"];
        model.symbols = [set stringForColumn:@"symbols"];
        model.backupFlag = [set boolForColumn:@"backupFlag"];
        model.publicKey = [set dataForColumn:@"publicKey"];
        model.privateKey = [set dataForColumn:@"privateKey"];
        model.mnemonicPhrase = [set stringForColumn:@"mnemonicPhrase"];
        model.password = [set stringForColumn:@"password"];
        [resultArr addObject:model];
    }
    return resultArr;
}

- (void)insertSymbol:(NSString *)symbol {
    XXAccountModel *model = [self accountByAddress:KUser.address];
    if (IsEmpty(model.symbols)) {
        [self updateAccountColumn:@"symbols" value:symbol];
    } else {
        NSString *symbols = [NSString stringWithFormat:@"%@,%@",model.symbols,symbol];
        [self updateAccountColumn:@"symbols" value:symbols];
    }
}

- (void)deleteSymbol:(NSString *)symbol {
    XXAccountModel *model = [self accountByAddress:KUser.address];
    if (!IsEmpty(model.symbols)) {
        NSMutableArray *symbols = [NSMutableArray arrayWithArray:[model.symbols componentsSeparatedByString:@","]];
        if ([symbols containsObject:symbol]) {
            [symbols removeObject:symbol];
        }
        NSString *result = [symbols componentsJoinedByString:@","];
        [self updateAccountColumn:@"symbols" value:result];
    }
}
@end
