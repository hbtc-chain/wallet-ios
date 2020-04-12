//
//  RatesManager.h
//  Bhex
//
//  Created by BHEX on 2018/7/11.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RatesManager : NSObject

/** 汇率数组 */
@property (strong, nonatomic, nullable) NSMutableArray *ratesArray;

/** 汇率字典 */
@property (strong, nonatomic, nullable) NSMutableDictionary *dataDic;

+ (RatesManager *_Nullable)shareRatesManager;
- (void)loadDataOfRates;
- (void)cancelTimer;

/** 根据币对取汇率 4位 */
- (NSString *_Nullable)getRatesWithToken:(NSString *_Nullable)tokenId priceValue:(double)priceValue;

/** 根据币对取汇率 2位 */
- (NSString *_Nullable)getTwoRatesWithToken:(NSString *_Nullable)tokenId priceValue:(double)priceValue;

- (NSString *_Nullable)getRatesFromToken:(NSString *_Nullable)fromtokenId fromPrice:(double)fromPrice coinName:(NSString *_Nullable)coinName;

- (NSString *_Nullable)getPriceFromToken:(NSString *_Nullable)token;
@end
