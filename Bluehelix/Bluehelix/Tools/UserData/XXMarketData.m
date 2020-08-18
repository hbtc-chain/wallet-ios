//
//  XXMarketData.m
//  Bhex
//
//  Created by Bhex on 2018/10/9.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXMarketData.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>

@interface XXMarketData ()

/** 配置数据 */
@property (strong, nonatomic) NSDictionary *configData;

#pragma mark - || 缓存/
/** 币币quoteTokensString */
@property (strong, nonatomic) NSString *quoteTokensString;

/** 收藏币对id数组字符串 */
@property (strong, nonatomic, nullable) NSString *favoriteString;

/** 期权optionQuoteTokensString */
@property (strong, nonatomic) NSString *optionQuoteTokensString;

/** 首页推荐币对id数组 */
@property (strong, nonatomic, nullable) NSString *recommendSymbolIdsString;
@property (strong, nonatomic) NSString *homeRecommendSymbolsString;
@end


@implementation XXMarketData
singleton_implementation(XXMarketData)

- (void)setUserLevel:(BOOL)userLevel {
    _userLevel = userLevel;
    [[NSUserDefaults standardUserDefaults] setObject:@(userLevel) forKey:@"UserCenterUserLevelKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setQuoteTokensString:(NSString *)quoteTokensString {
    _quoteTokensString = quoteTokensString;
    [[NSUserDefaults standardUserDefaults] setObject:quoteTokensString forKey:@"quoteTokensStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSymbolString:(NSString *)symbolString {
    _symbolString = symbolString;
    [[NSUserDefaults standardUserDefaults] setObject:symbolString forKey:@"allSymbolsStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setFavoriteString:(NSString *)favoriteString {
    _favoriteString = favoriteString;
    [[NSUserDefaults standardUserDefaults] setObject:favoriteString forKey:@"favoritesMarket"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setOptionQuoteTokensString:(NSString *)optionQuoteTokensString {
    _optionQuoteTokensString = optionQuoteTokensString;
    [[NSUserDefaults standardUserDefaults] setObject:optionQuoteTokensString forKey:@"optionQuoteTokensStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTokenString:(NSString *)tokenString {
    _tokenString = tokenString;
    [[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:@"tokenStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setOptionCoinToken:(NSString *)optionCoinToken {
    _optionCoinToken = optionCoinToken;
    [[NSUserDefaults standardUserDefaults] setObject:optionCoinToken forKey:@"optionCoinTokenKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setExploreTokens:(NSString *)exploreTokens {
    _exploreTokens = exploreTokens;
    [[NSUserDefaults standardUserDefaults] setObject:exploreTokens forKey:@"exploreTokensStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setOptionUnderlying:(NSString *)optionUnderlying {
    _optionUnderlying = optionUnderlying;
    [[NSUserDefaults standardUserDefaults] setObject:optionUnderlying forKey:@"optionUnderlyingStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setContractUnderlyingString:(NSString *)contractUnderlyingString {
    _contractUnderlyingString = contractUnderlyingString;
    [[NSUserDefaults standardUserDefaults] setObject:contractUnderlyingString forKey:@"contractUnderlyingStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setContractSymbolString:(NSString *)contractSymbolString {
    _contractSymbolString = contractSymbolString;
    [[NSUserDefaults standardUserDefaults] setObject:contractSymbolString forKey:@"contractSymbolStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setContractCoinToken:(NSString *)contractCoinToken {
    _contractCoinToken = contractCoinToken;
    [[NSUserDefaults standardUserDefaults] setObject:contractCoinToken forKey:@"contractCoinTokenKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setOrgId:(NSString *)orgId {
    _orgId = orgId;
    [[NSUserDefaults standardUserDefaults] setObject:KString(orgId) forKey:@"orgIdKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setRecommendSymbolIdsString:(NSString *)recommendSymbolIdsString {
    _recommendSymbolIdsString = recommendSymbolIdsString;
    [[NSUserDefaults standardUserDefaults] setObject:KString(recommendSymbolIdsString) forKey:@"recommendSymbolIdsStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)readData {
    _quoteTokensString = [[NSUserDefaults standardUserDefaults] objectForKey:@"quoteTokensStringKey"];
    _symbolString = [[NSUserDefaults standardUserDefaults] objectForKey:@"allSymbolsStringKey"];
    _favoriteString = [[NSUserDefaults standardUserDefaults] objectForKey:@"favoritesMarket"];
    if (IsString(self.favoriteString) && self.favoriteString.length > 0) {
        _favoritesArray = [NSMutableArray arrayWithArray:[self.favoriteString mj_JSONObject]];
    } else {
        _favoritesArray = [NSMutableArray array];
    }
    _tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenStringKey"];
    _optionQuoteTokensString = [[NSUserDefaults standardUserDefaults] objectForKey:@"optionQuoteTokensStringKey"];
    _optionCoinToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"optionCoinTokenKey"];
    _exploreTokens = [[NSUserDefaults standardUserDefaults] objectForKey:@"exploreTokensStringKey"];
    _optionUnderlying = [[NSUserDefaults standardUserDefaults] objectForKey:@"optionUnderlyingStringKey"];
    _contractUnderlyingString = [[NSUserDefaults standardUserDefaults] objectForKey:@"contractUnderlyingStringKey"];
    _contractSymbolString = [[NSUserDefaults standardUserDefaults] objectForKey:@"contractSymbolStringKey"];
    _contractCoinToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"contractCoinTokenKey"];
    _orgId = KString([[NSUserDefaults standardUserDefaults] objectForKey:@"orgIdKey"]);
    _recommendSymbolIdsString = [[NSUserDefaults standardUserDefaults] objectForKey:@"recommendSymbolIdsStringKey"];
    _userLevel = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserCenterUserLevelKey"] boolValue];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 1. 登录成功通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataOfFavoriteSymbols) name:Login_In_NotificationName object:nil];

        // 2. 读取缓存
        [self readData];
    }
    return self;
}

#pragma mark - 1.0 读取市场数据
- (void)readCachedDataOfMarket {

    // 1. 判断是否存在币币缓存
    if (self.quoteTokensString.length > 0 && self.symbolString.length > 0) {
        [self integrationDataOfSymbolsFromCache];
    }
    
    // 4. 判断首页推荐币对是否有缓存
    if (self.recommendSymbolIdsString.length > 0) {
        [self integrationDataOfRecommendSymbolsFromCache];
    }
}

#pragma mark - 2.1 收到配置信息
- (void)didReceiveConfigData:(NSDictionary *)data {
    
    self.configData = data;
    [self integrationDataOfSymbols];
}

#pragma mark - 3.0 处理请求过来的数据
- (void)integrationDataOfSymbols {
    // 1. 处理币币数据
    [self integrationDataOfCoin];
}

#pragma mark - 3.1 处理币币【HTTP】数据
- (void)integrationDataOfCoin {
    
    // 0. 券商ID
    NSString *orgId = KString(self.configData[@"orgId"]);
    if (![orgId isEqualToString:self.orgId]) {
        self.orgId = orgId;
        [NotificationManager postOrgIdChangeNotification];
    }

    // 1. 处理币币资产token
    NSString *tokensString = [self.configData[@"token"] mj_JSONString];
    if (![self.tokenString isEqualToString:tokensString] && self.tokenChangeBlock) {
        self.tokenString = tokensString;
        self.tokenChangeBlock();
    } else {
        self.tokenString = tokensString;
    }
    
    // 2. 处理体验币
    NSArray *exploreTokensArray = self.configData[@"exploreToken"];
    NSMutableDictionary *exploreTokensDic = [NSMutableDictionary dictionary];
    for (NSInteger i=0; i < exploreTokensArray.count; i ++) {
        NSString *tokenId = exploreTokensArray[i];
        exploreTokensDic[tokenId] = tokenId;
    }
    self.exploreTokens = [exploreTokensDic mj_JSONString];

    // 3. 判断是否更新新数据
    NSArray *quoteTokensArray = self.configData[@"customQuoteToken"]; //行情展示的币对 base左币 quote右币
    NSString *quoteTokensString = [quoteTokensArray mj_JSONString];
    
    NSArray *symbolsArray = self.configData[@"symbol"];
    NSString *symbolString = [symbolsArray mj_JSONString];

    // 5. 判断是否需要更新
    if (![self.quoteTokensString isEqualToString:quoteTokensString] || ![self.symbolString isEqualToString:symbolString]) {
        self.quoteTokensString = quoteTokensString;
        self.symbolString = symbolString;
    } else {
        return;
    }
    
    // 5.1 币对处理
    NSMutableDictionary *symbolsDict = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < symbolsArray.count; i ++) {
        XXSymbolModel *cModel = [XXSymbolModel mj_objectWithKeyValues:symbolsArray[i]];
        cModel.quote = [XXQuoteModel new];
        cModel.type = SymbolTypeCoin;
        symbolsDict[cModel.symbolId] = cModel;
    }

    // 6. 处理数据
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    self.keysArray = [NSMutableArray array];
    [self.keysArray addObject:@"自选"];
    XXQuoteTokenModel *favoriteModel = [[XXQuoteTokenModel alloc] init];
    favoriteModel.symbolsArray = [NSMutableArray array];
    favoriteModel.idsString = @"";
    favoriteModel.isFavorite = YES;
    dataDict[@"自选"] = favoriteModel;

    XXSymbolModel *firstModel = nil;
    for (NSInteger i=0; i < quoteTokensArray.count; i ++) {
        NSDictionary *dict = quoteTokensArray[i];
        NSString *tokenName = dict[@"tokenName"];
        [self.keysArray addObject:tokenName];
        XXQuoteTokenModel *tokenModel = [[XXQuoteTokenModel alloc] init];
        dataDict[tokenName] = tokenModel;
        tokenModel.symbolsArray = [NSMutableArray array];
        tokenModel.idsString = @"";
        NSArray *symbols = dict[@"quoteTokenSymbols"];
        for (NSInteger i=0; i < symbols.count; i ++) {
            NSDictionary *symbol = symbols[i];
            XXSymbolModel *cModel = symbolsDict[symbol[@"symbolId"]];
            cModel.isInTradeSection = YES;
            if (IsEmpty(cModel)) {
                continue;
            }
            if (cModel.showStatus == NO) {
                continue;
            }
            if (!firstModel) {
                firstModel = cModel;
            }

            if (tokenModel.idsString.length==0) {
                tokenModel.idsString = [NSString stringWithFormat:@"%@.%@", cModel.exchangeId, cModel.symbolId];
            } else {
                tokenModel.idsString = [NSString stringWithFormat:@"%@,%@.%@", tokenModel.idsString,  cModel.exchangeId, cModel.symbolId];
            }
            [tokenModel.symbolsArray addObject:cModel];

            if (!KTrade.coinTradeModel) {
                if (!KTrade.coinTradeSymbol) {
                    KTrade.coinTradeModel = cModel;
                    [NotificationManager postHaveTradeSymbolNotification];
                } else if ([KTrade.coinTradeSymbol isEqualToString:cModel.symbolName]) {
                    KTrade.coinTradeModel = cModel;
                    [NotificationManager postHaveTradeSymbolNotification];
                }
            } else {
                if ([KTrade.coinTradeSymbol isEqualToString:cModel.symbolId]) {
                    KTrade.coinTradeModel = cModel;
                }
            }
        }
    }

    if (!KTrade.coinTradeModel && firstModel) {
        KTrade.coinTradeModel = firstModel;
        [NotificationManager postHaveTradeSymbolNotification];
    }
    self.dataDict = dataDict;
    self.symbolsDict = symbolsDict;
    self.isFinishMarketData = YES;
    [self reloadFavoritesArray];
    [self reloadFavoriteQuoteTokenData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [NotificationManager postSymbolListNeedUpdateNotification];
    });
}

#pragma mark - 4.1 处理币币【缓存】数据
- (void)integrationDataOfSymbolsFromCache {

    // 取出数据
    NSArray *quoteTokensArray = [self.quoteTokensString mj_JSONObject];
    NSArray *symbolsArray = [self.symbolString  mj_JSONObject];
    
    // 币对数据
    NSMutableDictionary *symbolsDict = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < symbolsArray.count; i ++) {
        XXSymbolModel *cModel = [XXSymbolModel mj_objectWithKeyValues:symbolsArray[i]];
        cModel.quote = [XXQuoteModel new];
        cModel.type = SymbolTypeCoin;
        symbolsDict[cModel.symbolId] = cModel;
    }

    // 处理数据
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    self.keysArray = [NSMutableArray array];
    [self.keysArray addObject:@"自选"];
    XXQuoteTokenModel *favoriteModel = [[XXQuoteTokenModel alloc] init];
    favoriteModel.symbolsArray = [NSMutableArray array];
    favoriteModel.idsString = @"";
    favoriteModel.isFavorite = YES;
    dataDict[@"自选"] = favoriteModel;

    XXSymbolModel *firstModel = nil;
    for (NSInteger i=0; i < quoteTokensArray.count; i ++) {
        NSDictionary *dict = quoteTokensArray[i];
        NSString *tokenName = dict[@"tokenName"];
        [self.keysArray addObject:tokenName];

        XXQuoteTokenModel *tokenModel = [[XXQuoteTokenModel alloc] init];
        dataDict[tokenName] = tokenModel;
        tokenModel.symbolsArray = [NSMutableArray array];
        tokenModel.idsString = @"";
        NSArray *symbols = dict[@"quoteTokenSymbols"];
        for (NSInteger i=0; i < symbols.count; i ++) {

            NSDictionary *symbol = symbols[i];
            XXSymbolModel *cModel = symbolsDict[symbol[@"symbolId"]];
            cModel.isInTradeSection = YES;
            if (IsEmpty(cModel)) {
                continue;
            }
            if (cModel.showStatus == NO) {
                continue;
            }
            if (!firstModel) {
                firstModel = cModel;
            }

            if (tokenModel.idsString.length==0) {
                tokenModel.idsString = [NSString stringWithFormat:@"%@.%@", cModel.exchangeId, cModel.symbolId];
            } else {
                tokenModel.idsString = [NSString stringWithFormat:@"%@,%@.%@", tokenModel.idsString,  cModel.exchangeId, cModel.symbolId];
            }
            [tokenModel.symbolsArray addObject:cModel];

            if (!KTrade.coinTradeModel) {
                if (!KTrade.coinTradeSymbol) {
                    KTrade.coinTradeModel = cModel;
                } else if ([KTrade.coinTradeSymbol isEqualToString:cModel.symbolName]) {
                    KTrade.coinTradeModel = cModel;
                }
            }
        }
    }

    if (!KTrade.coinTradeModel && firstModel) {
        KTrade.coinTradeModel = firstModel;
    }
    self.dataDict = dataDict;
    self.symbolsDict = symbolsDict;
    self.isFinishMarketData = YES;
    [self reloadFavoritesArray];
    [self reloadFavoriteQuoteTokenData];
}

#pragma mark - 4.4 处理首页推荐币对缓存
- (void)integrationDataOfRecommendSymbolsFromCache {
    self.recommendSymbolIdsArray = [self.recommendSymbolIdsString mj_JSONObject];
    
}

#pragma mark - 5.0 登录成功加载自选列表
- (void)loadDataOfFavoriteSymbols {
    MJWeakSelf
//    [HttpManager user_GetWithPath:@"user/favorite/list" params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
//
//        if (code == 0 && IsArray(data)) {
//            NSMutableArray *dataArray = [NSMutableArray array];
//            NSMutableArray *rqArray = data;
//            for (NSInteger i=0; i < rqArray.count; i ++) {
//                NSDictionary *dict = rqArray[i];
//                NSDictionary *symbolId = dict[@"symbolId"];
//                if (weakSelf.symbolsDict[symbolId]) {
//                    [dataArray addObject:dict];
//                }
//            }
//            [weakSelf didReceiveRequestFavoriteSymbols:dataArray];
//        } else {
//            [weakSelf performSelector:@selector(loadDataOfFavoriteSymbols) withObject:nil afterDelay:3.0f];
//        }
//    }];
}

#pragma mark - 5.1 收到接口自选数据
- (void)didReceiveRequestFavoriteSymbols:(NSArray *)dataArray {
    NSMutableArray *sumsArray = [NSMutableArray array];
    if (self.favoriteString.length > 0) {
        NSMutableArray *needAddArray = [NSMutableArray array];
        BOOL isHave = NO;
        for (NSInteger i=0; i < dataArray.count; i ++) {
            NSDictionary *dict =  dataArray[i];
            isHave = NO;
            for (NSInteger j=0; j < self.favoritesArray.count; j ++) {
                NSString *oldSymbolId = self.favoritesArray[j];
                if ([dict[@"symbolId"] isEqualToString:oldSymbolId]) {
                    isHave = YES;
                    break;
                }
            }
            if (isHave == NO &&  self.symbolsDict[dict[@"symbolId"]]) {
                [needAddArray addObject:dict[@"symbolId"]];
            }
        }
        [sumsArray addObjectsFromArray:self.favoritesArray];
        [sumsArray addObjectsFromArray:needAddArray];
        NSMutableArray *parmasArray = [NSMutableArray array];
        for (NSInteger i=0; i < sumsArray.count; i ++) {
            NSString *symbolId = sumsArray[i];
            XXSymbolModel *cModel = self.symbolsDict[symbolId];
            if (IsEmpty(cModel)) {
                continue;
            }
            [parmasArray addObject:@{@"exchangeId":KString(cModel.exchangeId), @"symbolId":cModel.symbolId}];
        }
        
        if (![self.favoriteString isEqualToString:[sumsArray mj_JSONString]]) {
            [HttpManager postWithPath:@"user/favorite/sort" params:@{@"items":[parmasArray mj_JSONString]} andBlock:^(id data, NSString *msg, NSInteger code) {
            }];
        }
    } else {
        for (NSInteger i=0; i < dataArray.count; i ++) {
            NSDictionary *dict =  dataArray[i];
            [sumsArray addObject:dict[@"symbolId"]];
        }
    }
    
    if (![self.favoriteString isEqualToString:[sumsArray mj_JSONString]]) {
        self.favoritesArray = sumsArray;
        self.favoriteString = [sumsArray mj_JSONString];
        NSArray *keysArray = [self.symbolsDict allKeys];
        for (NSString *symbolId in keysArray) {
            XXSymbolModel *model = self.symbolsDict[symbolId];
            if (![self.favoriteString containsString:model.symbolId]) {
                model.favorite = NO;
            }
        }
        [self reloadFavoriteQuoteTokenData];
    }
}

#pragma mark - 5.2 剔除不存在的币对id
- (void)reloadFavoritesArray {
    NSMutableArray *notArray = [NSMutableArray array];
    for (NSString *symbolId in self.favoritesArray) {
        if (!self.symbolsDict[symbolId]) {
            [notArray addObject:symbolId];
        }
    }
    if (notArray.count > 0) {
        for (NSString *symbolId in notArray) {
            [self.favoritesArray removeObject:symbolId];
        }
        self.favoriteString = [self.favoritesArray mj_JSONString];
    }
}

#pragma mark - 5.3 更新自选交易区模型QuoteTokenModel
- (void)reloadFavoriteQuoteTokenData {
    XXQuoteTokenModel *favoriteTokenModel = self.dataDict[@"自选"];
    if (IsEmpty(favoriteTokenModel) || favoriteTokenModel.symbolsArray == nil) {
        return;
    }
    NSString *idsString = @"";
    NSMutableArray *symbolsArray = [NSMutableArray array];
    for (NSInteger i=0; i < self.favoritesArray.count; i ++) {
        NSString *symbolId = self.favoritesArray[i];
        XXSymbolModel *cModel = self.symbolsDict[symbolId];
        if (IsEmpty(cModel)) {
            continue;
        }
        cModel.favorite = YES;
        [symbolsArray addObject:cModel];
        if (idsString.length == 0) {
            idsString = [NSString stringWithFormat:@"%@.%@", cModel.exchangeId, cModel.symbolId];
        } else {
            idsString = [NSString stringWithFormat:@"%@,%@.%@", idsString,  cModel.exchangeId, cModel.symbolId];
        }
    }
    favoriteTokenModel.symbolsArray = symbolsArray;
    favoriteTokenModel.idsString = idsString;
}

#pragma mark - 5.4 添加自选
- (void)addFavoriteSymbolId:(NSString *)symbolId {
    
    if (IsEmpty(symbolId)) {
        return;
    }
    
    XXSymbolModel *sModel = self.symbolsDict[symbolId];
    
    if (IsEmpty(sModel)) {
        return;
    }
    sModel.favorite = YES;
    [self.favoritesArray insertObject:symbolId atIndex:0];
    self.favoriteString = [self.favoritesArray mj_JSONString];
    [self reloadFavoriteQuoteTokenData];
}

#pragma mark - 5.5 取消自选
- (void)cancelFavoriteSymbolId:(NSString *)symbolId {
    
    if (IsEmpty(symbolId)) {
        return;
    }
    
    XXSymbolModel *sModel = self.symbolsDict[symbolId];
    
    if (IsEmpty(sModel)) {
        return;
    }
    sModel.favorite = NO;
    [self.favoritesArray removeObject:symbolId];
    self.favoriteString = [self.favoritesArray mj_JSONString];
    [self reloadFavoriteQuoteTokenData];
}

#pragma mark - 5.6 刷新缓存自选
- (void)reloadFavoriteSymbol:(NSMutableArray *)symbolIdsArray {
    self.favoritesArray = symbolIdsArray;
    self.favoriteString = [self.favoritesArray mj_JSONString];
    [self reloadFavoriteQuoteTokenData];
}

#pragma mark - 6.1 获取数量精度
- (NSInteger)getNumberPrecisionWithSymbolId:(NSString *)symbolId quoteName:(NSString *)quoteName {
    XXQuoteTokenModel *tokenModel = self.dataDict[quoteName];
    for (NSInteger i=0; i < tokenModel.symbolsArray.count; i ++) {
        XXSymbolModel *cModel = tokenModel.symbolsArray[i];
        if ([cModel.symbolId isEqualToString:symbolId]) {
            return [KDecimal scale:cModel.basePrecision];
        }
    }
    return 8;
}

#pragma mark - 6.2 获取价格精度
- (NSInteger)getPricePrecisionWithSymbolId:(NSString *)symbolId quoteName:(NSString *)quoteName {
    XXQuoteTokenModel *tokenModel = self.dataDict[quoteName];
    for (NSInteger i=0; i < tokenModel.symbolsArray.count; i ++) {
        XXSymbolModel *cModel = tokenModel.symbolsArray[i];
        if ([cModel.symbolId isEqualToString:symbolId]) {
            return [KDecimal scale:cModel.minPricePrecision];
        }
    }
    return 8;
}

#pragma mark - 6.3 获取金额精度
- (NSInteger)getQuotePrecisionWithSymbolId:(NSString *)symbolId quoteName:(NSString *)quoteName {
    XXQuoteTokenModel *tokenModel = self.dataDict[quoteName];
    for (NSInteger i=0; i < tokenModel.symbolsArray.count; i ++) {
        XXSymbolModel *cModel = tokenModel.symbolsArray[i];
        if ([cModel.symbolId isEqualToString:symbolId]) {
            return [KDecimal scale:cModel.quotePrecision];
        }
    }
    return 8;
}

#pragma mark - 7. 获取链数组
- (NSArray *)chainTypesWithTokenId:(NSString *)tokenId {
    if (!tokenId) {
        return @[];
    }
    NSArray *tokensArray = [self.tokenString mj_JSONObject];
    for (NSDictionary *dict in tokensArray) {
        if ([tokenId isEqualToString:dict[@"tokenId"]]) {
            return dict[@"chainTypes"];
        }
    }
    return @[];
}

#pragma mark - 9. 根据域名获取ip地址
- (void)getRemoteAddressIp {
    
    // 串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create("com.remoteAddressIp.switchSymbol", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        double openTime = [[NSDate date] timeIntervalSince1970]*1000.0f;
        NSURL *url = [NSURL URLWithString:kServerUrl];
        self.remoteDomain = url.host;
        struct hostent *hs;
        struct sockaddr_in server;
        if ((hs = gethostbyname([self.remoteDomain UTF8String])) != NULL) {
            server.sin_addr = *((struct in_addr*)hs->h_addr_list[0]);
            self.remoteAddress = [NSString stringWithFormat:@"%@", [NSString stringWithUTF8String:inet_ntoa(server.sin_addr)]];
            double closeTime = [[NSDate date] timeIntervalSince1970]*1000.0f;
            self.dnsDuration = [NSString stringWithFormat:@"%.0f", closeTime - openTime];
        }
    });
}

@end
