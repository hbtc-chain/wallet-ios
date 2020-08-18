//
//  KSymbolDetailData.m
//  Bhex
//
//  Created by YiHeng on 2020/2/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "KSymbolDetailData.h"

@implementation KSymbolDetailData
singleton_implementation(KSymbolDetailData)

- (void)setSymbolModel:(XXSymbolModel *)symbolModel {
    
    _symbolModel = symbolModel;
    NSArray *digitMergeArray = [_symbolModel.digitMerge componentsSeparatedByString:@","];
    self.priceDigit = [KDecimal scale:[digitMergeArray lastObject]];
    self.numberDigit = [KDecimal scale:_symbolModel.basePrecision];
}

- (void)setKlineIndex:(NSString *)klineIndex {
    [KUser saveValeu:klineIndex forKey:@"klineIndexKey"];
}

- (void)setKlineMainIndex:(NSString *)klineMainIndex {
    [KUser saveValeu:klineMainIndex forKey:@"klineMainIndexKey"];
}

- (void)setKlineAccessoryIndex:(NSString *)klineAccessoryIndex {
    [KUser saveValeu:klineAccessoryIndex forKey:@"klineAccessoryIndexKey"];
}

- (NSString *)klineIndex {
    NSInteger klineValue = [[KUser getValueForKey:@"klineIndexKey"] integerValue];
    if (klineValue == 0) {
        return @"4";
    }
    else {
        return [KUser getValueForKey:@"klineIndexKey"];
    }
}

- (NSString *)klineMainIndex {
    NSInteger index = [[KUser getValueForKey:@"klineMainIndexKey"] integerValue];
    if (index == 0) {
        return @"103";
    } else {
        return [KUser getValueForKey:@"klineMainIndexKey"];
    }
}

- (NSString *)klineAccessoryIndex {
    NSInteger index = [[KUser getValueForKey:@"klineAccessoryIndexKey"] integerValue];
    if (index == 0) {
        return @"100";
    } else {
        return [KUser getValueForKey:@"klineAccessoryIndexKey"];
    }
}

@end
