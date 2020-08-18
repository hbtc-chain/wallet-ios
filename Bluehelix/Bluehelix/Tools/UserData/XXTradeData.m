//
//  XXTradeData.m
//  Bhex
//
//  Created by Bhex on 2019/1/8.
//  Copyright © 2019年 Bhex. All rights reserved.
//

#import "XXTradeData.h"
#import "XXDepthTool.h"
#import "XXDepthModel.h"

#define CoinDepthAmountType @"coinDepthOrderAmountType"
#define OptionDepthAmountType @"optionDepthOrderAmountType"
#define ContractDepthAmountType @"contractDepthOrderAmountType"

@interface XXTradeData () {
    dispatch_queue_t serialQueue; // 串行队列
}

/** 原始数据 */
@property (strong, nonatomic) NSMutableDictionary *leftDictionary;

/** 原始右边数据 */
@property (strong, nonatomic) NSMutableDictionary *rightDictionary;

/** 币币行情 */
@property (strong, nonatomic) XXWebQuoteModel *tikerWebModel;

/** 币币深度 */
@property (strong, nonatomic) XXWebQuoteModel *depthModel;

@end

@implementation XXTradeData
singleton_implementation(XXTradeData)

- (instancetype)init
{
    self = [super init];
    if (self) {
        serialQueue = dispatch_queue_create("com.xyh1.switchSymbol", DISPATCH_QUEUE_SERIAL);
        self.coinDepthAmount = [[self getValueForKey:CoinDepthAmountType] integerValue];
        self.leftDictionary = [NSMutableDictionary dictionary];
        self.rightDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - =============== 币币
- (void)setCoinTradeModel:(XXSymbolModel *)tradeModel {
    _coinTradeModel = tradeModel;
    self.coinTradeSymbol = tradeModel.symbolName;
}

- (void)setCoinTradeSymbol:(NSString *)tradeSymbol {
    [self saveValeu:tradeSymbol forKey:@"TradeSymbol"];
}

- (void)setCoinDepthAmount:(NSInteger)coinDepthAmount {
    _coinDepthAmount = coinDepthAmount;
    [self saveValeu:@(coinDepthAmount) forKey:CoinDepthAmountType];
}

- (NSString *)coinTradeSymbol {
    return [self getValueForKey:@"TradeSymbol"];
}

#pragma mark - 1.0 打开币币Socket
- (void)openSocketWithSymbolModel:(XXSymbolModel *)symbolModel {

    self.currentModel = symbolModel;

    // 是否切换币对删除深度数据
    if (self.webSymbolId && ![self.webSymbolId isEqualToString:symbolModel.symbolId]) {
        if (self.depthModel) {
            self.depthModel = nil;
            self.tikerWebModel = nil;
        }
        if ([self.delegate respondsToSelector:@selector(cleanData)]) {
            [self.delegate cleanData];
        }
    }
    self.webSymbolId = self.currentModel.symbolId;

    // 1. 打开行情
    [self openTikerSocket:self.currentModel];

    // 2. 深度20
    [self openDeptchSocket:self.currentModel];

}

#pragma mark - 1.1 打开tikerSocket
- (void)openTikerSocket:(XXSymbolModel *)symbolTradeModel {
    MJWeakSelf
    // 1. 最新行情
    self.tikerWebModel = [[XXWebQuoteModel alloc] init];
    self.tikerWebModel.successBlock = ^(NSArray *data) {
        if ([data isKindOfClass:[NSArray class]]) {
            if (data.count > 0) {
                if ([weakSelf.delegate respondsToSelector:@selector(tradeQuoteData:)]) {
                    [weakSelf.delegate tradeQuoteData:[data lastObject]];
                }
            } else {
                if ([weakSelf.delegate respondsToSelector:@selector(tradeQuoteData:)]) {
                    [weakSelf.delegate tradeQuoteData:@{}];
                }
            }
        }
    };

    // 1.1 http
    self.tikerWebModel.httpUrl = @"quote/v1/ticker";
    self.tikerWebModel.httpParams = [NSMutableDictionary dictionary];
    self.tikerWebModel.httpParams[@"symbol"] = [NSString stringWithFormat:@"%@.%@", symbolTradeModel.exchangeId, symbolTradeModel.symbolId];

    // 1.2 web
    self.tikerWebModel.params = [NSMutableDictionary dictionary];
    self.tikerWebModel.params[@"topic"] = @"realtimes";
    self.tikerWebModel.params[@"event"] = @"sub";
    self.tikerWebModel.params[@"markets"] = @"";
    self.tikerWebModel.params[@"symbol"] = [NSString stringWithFormat:@"%@.%@", symbolTradeModel.exchangeId, symbolTradeModel.symbolId];
    self.tikerWebModel.params[@"params"] = @{@"binary":@(YES)};
    [KQuoteSocket sendWebSocketSubscribeWithWebSocketModel:self.tikerWebModel];
}

#pragma mark - 1.2 打开深度20条
- (void)openDeptchSocket:(XXSymbolModel *)symbolTradeModel {

    // 1. 盘口深度列表
    MJWeakSelf
    self.depthModel = [[XXWebQuoteModel alloc] init];
    self.depthModel.successBlock = ^(id data) {
        [weakSelf receiveDeptchData:data];
    };

    // 2. http
    self.depthModel.httpUrl = @"quote/v1/depth";
    self.depthModel.httpParams = [NSMutableDictionary dictionary];
    self.depthModel.httpParams[@"symbol"] = [NSString stringWithFormat:@"%@.%@", symbolTradeModel.exchangeId, symbolTradeModel.symbolId];
    self.depthModel.httpParams[@"dumpScale"] = [NSString stringWithFormat:@"%zd", self.priceDigit <= 0 ? -1 : self.priceDigit];
    
    // 3. web 
    self.depthModel.params = [NSMutableDictionary dictionary];
    self.depthModel.params[@"topic"] = @"diffMergedDepth";
    self.depthModel.params[@"event"] = @"sub";
    self.depthModel.params[@"params"] = @{@"dumpScale":[NSString stringWithFormat:@"%zd", self.priceDigit <= 0 ? -1 : self.priceDigit], @"binary":@(YES)};
    
    self.depthModel.params[@"symbol"] = [NSString stringWithFormat:@"%@.%@", symbolTradeModel.exchangeId, symbolTradeModel.symbolId];
    [KQuoteSocket sendWebSocketSubscribeWithWebSocketModel:self.depthModel];
}



#pragma mark - 2. 关闭Socket
- (void)closeSocket {

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [KQuoteSocket cancelWebSocketSubscribeWithWebSocketModel:self.depthModel];
    [KQuoteSocket cancelWebSocketSubscribeWithWebSocketModel:self.tikerWebModel];

    self.depthModel.successBlock = nil;
    self.tikerWebModel.successBlock = nil;
}

#pragma mark - 3.1 收到深度列表数据20
- (void)receiveDeptchData:(id)data {

    if (self.depthModel.isRed) {
        dispatch_async(self->serialQueue, ^{
            [self.leftDictionary removeAllObjects];
            [self.rightDictionary removeAllObjects];
        });
    }
    dispatch_async(self->serialQueue, ^{
        if ([data isKindOfClass:[NSArray class]]) {
            NSDictionary *dict = [data firstObject];
            [self depthListViewWithBids:dict[@"b"] asks:dict[@"a"]];
        } else {
            [self depthListViewWithBids:data[@"b"] asks:data[@"a"]];
        }
    });
}

#pragma mark - 3.2 深度列表处理数据20
- (void)depthListViewWithBids:(NSArray *)binds asks:(NSArray *)asks {

    NSDictionary *listDictionary = [XXDepthTool depthLeftDict:self.leftDictionary rightDict:self.rightDictionary binds:binds asks:asks priceDigit:self.priceDigit amountDigit:self.numberDigit];
    BOOL success = [listDictionary[@"success"] boolValue];
    if (success) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(tradeDepthListData:)]) {
                [self.delegate tradeDepthListData:listDictionary];
            }
        });
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [KQuoteSocket cancelWebSocketSubscribeWithWebSocketModel:self.depthModel];
            [self openDeptchSocket:self.currentModel];
        });
    }
}

#pragma mark - 存取方法
-(id)getValueForKey:(NSString*)key{
    if (key) {
        id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
            return value;
    } else {
        return @"";
    }
}

-(void)saveValeu:(id)value forKey:(NSString *)key{
    
    if (key) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
