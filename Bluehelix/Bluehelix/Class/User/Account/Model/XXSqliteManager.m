//
//  XXSqliteManager.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/04.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXSqliteManager.h"
#import "XXTokenModel.h"
#import "XXMappingModel.h"
#import "XXChainModel.h"

@implementation XXSqliteManager

static XXSqliteManager *_sqliteManager;
+ (XXSqliteManager *)sharedSqlite {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sqliteManager = [[XXSqliteManager alloc] init];
    });
    return _sqliteManager;
}

#pragma mark default tokens
- (void)requestDefaultTokens {
    MJWeakSelf
    [HttpManager getWithPath:@"/api/v1/default_tokens" params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            NSString *defaultTokens = [data mj_JSONString];
            NSString *localString = [XXUserData sharedUserData].tokenString;
            if (!IsEmpty(defaultTokens) && ![localString isEqualToString:defaultTokens]) {
                [XXUserData sharedUserData].defaultTokens = defaultTokens;
            }
            weakSelf.defaultTokens = [XXTokenModel mj_objectArrayWithKeyValuesArray:[XXUserData sharedUserData].defaultTokens];
            [weakSelf insertTokens:weakSelf.defaultTokens];
        }
    }];
}

- (NSString *)defaultTokenSymbols {
    NSString *symbols = @"";
    for (XXTokenModel *model in self.defaultTokens) {
        if (IsEmpty(symbols)) {
            symbols = model.symbol;
        } else {
            symbols = [NSString stringWithFormat:@"%@,%@",symbols,model.symbol];
        }
    }
    return symbols;
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
    BOOL result = [self.myFmdb executeUpdate:@"create table if not exists tokens(ID INTEGER PRIMARY KEY AUTOINCREMENT,deposit_threshold TEXT,name TEXT,symbol TEXT,chain TEXT,decimals INTEGER,is_native BOOLEAN,withdrawal_fee TEXT,logo TEXT,is_withdrawal_enabled BOOLEAN)"];
    return result;
}


- (void)insertTokens:(NSArray *)tokens {
    if (![self.myFmdb columnExists:@"deposit_threshold" inTableWithName:@"tokens"]) {
        [self.myFmdb executeUpdate:@"drop table if exists tokens"];
    }
    BOOL existsTable = [self existsTokens];
    if (!existsTable) {
        return;
    }
    for (XXTokenModel *model  in tokens) {
        [self insertToken:model];
    }
}

- (void)insertToken:(XXTokenModel *)model {
    BOOL existsTable = [self existsTokens];
    if (!existsTable) {
        return;
    }
    if ([self tokenBySymbol:model.symbol]) {
        [self updateToken:model];
    } else {
        NSMutableArray *argumentsArr = [[NSMutableArray alloc] init];
        [argumentsArr addObject:model.deposit_threshold];
        [argumentsArr addObject:model.name];
        [argumentsArr addObject:model.symbol];
        [argumentsArr addObject:[NSNumber numberWithInt:model.decimals]];
        [argumentsArr addObject:[NSNumber numberWithInt:model.is_native]];
        [argumentsArr addObject:model.withdrawal_fee];
        [argumentsArr addObject:model.logo];
        [argumentsArr addObject:model.chain];
        [argumentsArr addObject:[NSNumber numberWithInt:model.is_withdrawal_enabled]];
        if (argumentsArr.count != 9) {
            return;
        }
        [self.myFmdb executeUpdate:@"insert into 'tokens'(deposit_threshold,name,symbol,decimals,is_native,withdrawal_fee,logo,chain,is_withdrawal_enabled) values(?,?,?,?,?,?,?,?,?)" withArgumentsInArray:argumentsArr];
    }
}

- (void)updateToken:(XXTokenModel *)model {
    BOOL existsTable = [self existsTokens];
    if (!existsTable) {
        return;
    }
    NSMutableArray *argumentsArr = [[NSMutableArray alloc] init];
    [argumentsArr addObject:model.deposit_threshold];
    [argumentsArr addObject:model.name];
    [argumentsArr addObject:[NSNumber numberWithInt:model.decimals]];
    [argumentsArr addObject:[NSNumber numberWithInt:model.is_native]];
    [argumentsArr addObject:model.withdrawal_fee];
    [argumentsArr addObject:model.logo];
    [argumentsArr addObject:model.chain];
    [argumentsArr addObject:[NSNumber numberWithInt:model.is_withdrawal_enabled]];
    [argumentsArr addObject:model.symbol];
    if (argumentsArr.count != 9) {
        return;
    }
    NSString *sql = [NSString stringWithFormat:@"update 'tokens' set deposit_threshold = ?,name = ?,decimals = ?,is_native = ?,withdrawal_fee = ?,logo = ?,chain = ?,is_withdrawal_enabled = ? where symbol = ?"];
    [self.myFmdb executeUpdate:sql withArgumentsInArray:argumentsArr];
}

- (XXTokenModel *)tokenModel:(FMResultSet *)set {
    XXTokenModel *model = [[XXTokenModel alloc] init];
    model.deposit_threshold = [set stringForColumn:@"deposit_threshold"];
    model.name = [set stringForColumn:@"name"];
    model.symbol = [set stringForColumn:@"symbol"];
    model.decimals = [set intForColumn:@"decimals"];
    model.is_native = [set boolForColumn:@"is_native"];
    model.withdrawal_fee = [set stringForColumn:@"withdrawal_fee"];
    model.logo = [set stringForColumn:@"logo"];
    model.chain = [set stringForColumn:@"chain"];
    model.is_withdrawal_enabled = [set boolForColumn:@"is_withdrawal_enabled"];
    return model;
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
        XXTokenModel *model = [self tokenModel:set];
        [resultArr addObject:model];
    }
    return resultArr;
}

- (XXTokenModel *)tokenBySymbol:(NSString *)symbol {
    BOOL existsTable = [self existsTokens];
    if (!existsTable) {
        return nil;
    }
    FMResultSet *set = [self.myFmdb executeQuery:@"select * from tokens where symbol = ? limit 1",symbol];
    NSMutableArray *resultArr = [NSMutableArray array];
    while ([set next]) {
        XXTokenModel *model = [self tokenModel:set];
        [resultArr addObject:model];
    }
    return [resultArr firstObject];
}

- (XXTokenModel *)withdrawFeeToken:(XXTokenModel *)token {
    if ([token.symbol isEqualToString:token.chain]) {
        return token;
    } else {
        BOOL existsTable = [self existsTokens];
        if (!existsTable) {
            return nil;
        }
        FMResultSet *set = [self.myFmdb executeQuery:@"select * from tokens where symbol = ? limit 1",token.chain];
        NSMutableArray *resultArr = [NSMutableArray array];
        while ([set next]) {
            XXTokenModel *model = [self tokenModel:set];
            [resultArr addObject:model];
        }
        return [resultArr firstObject];
    }
}

- (NSString *)tokensListString {
    BOOL existsTable = [self existsTokens];
    if (!existsTable) {
        return @"";
    }
    NSString *sql = @"select * from 'tokens'";
    FMResultSet *set = [self.myFmdb executeQuery:sql];
    NSMutableArray *resultArr = [NSMutableArray array];
    while ([set next]) {
        XXTokenModel *model = [self tokenModel:set];
        [resultArr addObject:model];
    }
    NSString *result = @"";
    for (XXTokenModel *token in resultArr) {
        if (result.length == 0) {
            result = token.symbol;
        } else {
            result = [result stringByAppendingString:[NSString stringWithFormat:@",%@",token.symbol]];
        }
    }
    return result;
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
            XXTokenModel *model = [self tokenModel:set];
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
    NSString *sql = @"create table if not exists account(ID INTEGER PRIMARY KEY AUTOINCREMENT,address TEXT,userName TEXT,password TEXT,backupFlag INTEGER,mnemonicPhrase TEXT,publicKey,privateKey TEXT,keystore TEXT,symbols TEXT)";
    BOOL result = [self.myFmdb executeUpdate:sql];
    return result;
}

- (BOOL)insertAccount:(XXAccountModel *)model {
    BOOL existsTable = [self existsAccount];
    if (!existsTable) {
        return NO;
    }
    NSMutableArray *argumentsArr = [[NSMutableArray alloc] init];
    [argumentsArr addObject:model.address];
    [argumentsArr addObject:model.userName];
    [argumentsArr addObject:model.password];
    [argumentsArr addObject:[NSString stringWithFormat:@"%d",model.backupFlag]];
    [argumentsArr addObject:model.publicKey];
    [argumentsArr addObject:model.privateKey];
    [argumentsArr addObject:model.mnemonicPhrase];
    [argumentsArr addObject:model.symbols];
    [argumentsArr addObject:model.keystore];
    BOOL result = [self.myFmdb executeUpdate:@"insert into 'account'(address,userName,password,backupFlag,publicKey,privateKey,mnemonicPhrase,symbols,keystore) values(?,?,?,?,?,?,?,?,?)" withArgumentsInArray:argumentsArr];
    
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
        XXAccountModel *model = [self accountModel:set];
        return model;
    }
    return nil;
}

- (XXAccountModel *)accountModel:(FMResultSet *)set {
    XXAccountModel *model = [[XXAccountModel alloc] init];
    model.address = [set stringForColumn:@"address"];
    model.userName = [set stringForColumn:@"userName"];
    model.symbols = [set stringForColumn:@"symbols"];
    model.backupFlag = [set boolForColumn:@"backupFlag"];
    model.password = [set stringForColumn:@"password"];
    model.publicKey = [set dataForColumn:@"publicKey"];
    model.privateKey = [set stringForColumn:@"privateKey"];
    model.mnemonicPhrase = [set stringForColumn:@"mnemonicPhrase"];
    model.keystore = [set stringForColumn:@"keystore"];
    return model;
}

- (NSArray *)accounts {
    BOOL existsTable = [self existsAccount];
    if (!existsTable) {
        return @[];
    }
    NSString *sql = @"select * from 'account'";
    FMResultSet *set = [self.myFmdb executeQuery:sql];
    NSMutableArray *resultArr = [NSMutableArray array];
    while ([set next]) {
        XXAccountModel *model = [self accountModel:set];
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

#pragma mark 兑换币对
- (void)requestMapping {
    MJWeakSelf
    [HttpManager getWithPath:@"/api/v1/mappings" params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            NSString *tokensString = [data[@"items"] mj_JSONString];
            NSString *localString = [XXUserData sharedUserData].tokenString;
            if (!IsEmpty(tokensString) && ![localString isEqualToString:tokensString]) {
                [XXUserData sharedUserData].tokenString = tokensString;
            }
            NSArray *mappings = [XXMappingModel mj_objectArrayWithKeyValuesArray:[XXUserData sharedUserData].tokenString];
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithArray:mappings];
            for (XXMappingModel *map in mappings) {
                map.map_symbol = map.issue_symbol;
                XXMappingModel *mapModel = [[XXMappingModel alloc] initWithMap:map];
                [resultArray addObject:mapModel];
            }
            weakSelf.mappingTokens = resultArray;
        }
    }];
}

- (XXMappingModel *)mappingModelBySymbol:(NSString *)symbol {
    for (XXMappingModel *map in self.mappingTokens) {
        if ([map.target_symbol isEqualToString:symbol]) {
            return map;
        }
    }
    return nil;
}

- (BOOL)existMapModel:(NSString *)symbol {
    for (XXMappingModel *map in self.mappingTokens) {
        if ([map.target_symbol isEqualToString:symbol]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark 资产首页展示的链
- (void)requestChain {
    MJWeakSelf
    [HttpManager getWithPath:@"/api/v1/chains" params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            NSString *chainString = [data mj_JSONString];
            NSString *localString = [XXUserData sharedUserData].chainString;
            if (!IsEmpty(chainString) && ![localString isEqualToString:chainString]) {
                [XXUserData sharedUserData].chainString = chainString;
            }
            weakSelf.chain = [XXChainModel mj_objectArrayWithKeyValuesArray:[XXUserData sharedUserData].chainString];
            for (XXChainModel *dic in weakSelf.chain) {
                if ([dic.chain isEqualToString:kMainToken]) {
                    dic.typeName = LocalizedString(@"NativeTokenList");
                } else {
                    dic.typeName =LocalizedString(@"CrossChainTokenList");
                }
            }
        }
    }];
}

- (NSString *)signType:(NSString *)type {
    if ([type isEqualToString:kMsgSend]) { //转账
        return LocalizedString(@"Transfer");
    } else if ([type isEqualToString:kMsgDelegate]) { //委托
        return LocalizedString(@"Delegate");
    } else if ([type isEqualToString:kMsgUndelegate]) { //解委托
        return LocalizedString(@"CancelDelegate");
    } else if ([type isEqualToString:kMsgKeyGen]) { // 跨链地址生成
        return LocalizedString(@"ChainAddress");
    } else if ([type isEqualToString:kMsgDeposit]) { // 跨链充值
        return LocalizedString(@"ChainDeposit");
    } else if ([type isEqualToString:kMsgWithdrawal]) { // 跨链提币
        return LocalizedString(@"ChainWithdrawal");
    } else if ([type isEqualToString:kMsgWithdrawalDelegationReward]) { //提取收益
        return LocalizedString(@"WithdrawMoney");
    } else if ([type isEqualToString:kMsgPledge]) { //质押
        return LocalizedString(@"ProposalNavgationTitlePledge");
    }  else if ([type isEqualToString:kMsgVote]) { // 投票
        return LocalizedString(@"ProposalNavgationTitleVote");
    }  else if ([type isEqualToString:kMsgCreateProposal]) { //发起提案
        return LocalizedString(@"VotingProposal");
    } else if ([type isEqualToString:kMsgMappingSwap]) { //映射
        return LocalizedString(@"Exchange");
    } else if ([type isEqualToString:kMsgSwapExactIn]) { //兑换输入
        return LocalizedString(@"MsgSwapExactIn");
    } else if ([type isEqualToString:kMsgSwapExactOut]) { //兑换输出
        return LocalizedString(@"MsgSwapExactOut");
    } else if ([type isEqualToString:kMsgAddLiquidity]) { //添加流动性
        return LocalizedString(@"MsgAddLiquidity");
    } else if ([type isEqualToString:kMsgRemoveLiquidity]) { //移除流动性
        return LocalizedString(@"MsgRemoveLiquidity");
    } else if ([type isEqualToString:kMsgLimitSwap]) { //限价单兑换
        return LocalizedString(@"MsgLimitSwap");
    } else if ([type isEqualToString:kMsgCancelLimitSwap]) { //撤单
        return LocalizedString(@"MsgCancelLimitSwap");
    } else {
        return LocalizedString(@"ChainOtherType");
    }
}
@end
