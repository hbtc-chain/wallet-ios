//
//  Y-KlineModel.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/28.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLineModel.h"
#import "Y_KLineGroupModel.h"
#import "Y_StockChartGlobalVariable.h"
@implementation Y_KLineModel


- (void) initWithDataDict:(NSDictionary *_Nullable)dict previousKlineModel:(Y_KLineModel *_Nullable)previousKlineModel {
    if (self) {
        self.Date = KString(dict[@"t"]);
        self.Open = @([dict[@"o"] doubleValue]);
        self.High = @([dict[@"h"] doubleValue]);
        self.Low = @([dict[@"l"] doubleValue]);
        self.Close = @([dict[@"c"] doubleValue]);
        self.Volume = [dict[@"v"] doubleValue];
        self.SumOfLastClose = @(self.Close.doubleValue + previousKlineModel.SumOfLastClose.doubleValue);
        self.SumOfLastVolume = @(self.Volume + previousKlineModel.SumOfLastVolume.doubleValue);
    }
}

- (void)initDataIndex:(NSInteger)index modelsArray:(NSMutableArray<Y_KLineModel *> *_Nullable)models {
    
    // MA5
    if (index > 4) {
        self.MA5 = @((self.SumOfLastClose.doubleValue - models[index - 5].SumOfLastClose.doubleValue) / 5);
    } else if (index == 4) {
        self.MA5 = @((self.SumOfLastClose.doubleValue) / 5);
    }
    
    // MA10
    if (index > 9) {
        self.MA10 = @((self.SumOfLastClose.doubleValue - models[index - 10].SumOfLastClose.doubleValue) / 10);
    } else if (index == 9) {
        self.MA10 = @((self.SumOfLastClose.doubleValue) / 10);
    }
    
    // MA20
    if (index > 19) {
        self.MA20 = @((self.SumOfLastClose.doubleValue - models[index - 20].SumOfLastClose.doubleValue) / 20);
    } else if (index == 19) {
        self.MA20 = @(self.SumOfLastClose.doubleValue / 20);
    }

    // MA30
    if (index > 29) {
        self.MA30 = @((self.SumOfLastClose.doubleValue - models[index - 30].SumOfLastClose.doubleValue) / 30);
    }
    
    // EMA MACD
    Y_KLineModel *previousKlineModel;
    if (index > 0) {
        // EMA5 EMA10 EMA12 EMA26 EMA30
        previousKlineModel = models[index - 1];
    }
    
    // // EMA5 EMA10 EMA30 EMA12 EMA26
    if (index >= 4) {
        self.EMA5 = @((2 * self.Close.doubleValue + 4 * previousKlineModel.EMA5.doubleValue)/6);
    } else if (index == 3) {
        self.EMA5 = @(self.Close.doubleValue);
    }
    
    if (index >= 9) {
        self.EMA10 = @((2 * self.Close.doubleValue + 9 * previousKlineModel.EMA10.doubleValue)/11);
    } else if (index == 8) {
        self.EMA10 = @(self.Close.doubleValue);
    }
    
    if (index >=  29) {
        self.EMA30 = @((2 * self.Close.doubleValue + 29 * previousKlineModel.EMA30.doubleValue)/31);
    } else if (index == 28) {
        self.EMA30 = @(self.Close.doubleValue);
    }

    if (index > 0) {
        self.EMA12 = @((2 * self.Close.doubleValue + 11 * previousKlineModel.EMA12.doubleValue)/13);
        self.EMA26 = @((2 * self.Close.doubleValue + 25 * previousKlineModel.EMA26.doubleValue)/27);
    } else {
        self.EMA12 = @(self.Close.doubleValue);
        self.EMA26 = @(self.Close.doubleValue);
    }
    
    // DIF=EMA（12）-EMA（26）DIF的值即为红绿柱 今日的DEA值=前一日DEA*8/10+今日DIF*2/10.
    self.DIF = @(self.EMA12.doubleValue - self.EMA26.doubleValue);
    self.DEA = @(previousKlineModel.DEA.doubleValue * 0.8 + 0.2*self.DIF.doubleValue);
    self.MACD = @(2*(self.DIF.doubleValue - self.DEA.doubleValue));
    
    // KDJ(14,1,3)
    if (index > 0) {
        // 最大最小值
        [self getClocksMaxAndMinPriceIndex:index modelsArray:models];

        if(self.NineClocksMinPrice == self.NineClocksMaxPrice) {
            self.RSV = @0;
        } else {
            self.RSV = @((self.Close.doubleValue - self.NineClocksMinPrice.doubleValue) * 100 / (self.NineClocksMaxPrice.doubleValue - self.NineClocksMinPrice.doubleValue));
        }
        self.KDJ_K = @((self.RSV.doubleValue + 2 * previousKlineModel.KDJ_K.doubleValue)/3);
        self.KDJ_D = @((self.KDJ_K.doubleValue + 2 * previousKlineModel.KDJ_D.doubleValue)/3);
        self.KDJ_J = @(3*self.KDJ_K.doubleValue - 2*self.KDJ_D.doubleValue);
    } else {
        // 最大最小值
        self.NineClocksMinPrice = self.Low;
        self.self.NineClocksMaxPrice = self.High;
        
        self.KDJ_K = @(50);
        self.KDJ_D = @(50);
        self.KDJ_J = @(3*self.KDJ_K.doubleValue - 2*self.KDJ_D.doubleValue);
    }
    
    // BOLL线
    double BOLLMA20;
    if (index > 19) {
        BOLLMA20 = (self.SumOfLastClose.doubleValue - models[index - 20].SumOfLastClose.doubleValue) / 20;
    } else {
        BOLLMA20 = self.SumOfLastClose.doubleValue / (index + 1);
    }
    self.BOLL_SUBMD = @((self.Close.doubleValue - BOLLMA20) * ( self.Close.doubleValue - BOLLMA20));
    self.BOLL_SUBMD_SUM = @(previousKlineModel.BOLL_SUBMD_SUM.doubleValue + self.BOLL_SUBMD.doubleValue);
    
   if (index > 19) {
        double mdtemp = (previousKlineModel.BOLL_SUBMD_SUM.doubleValue - models[index - 20].BOLL_SUBMD_SUM.doubleValue)/ 20;
        self.BOLL_MD = @(sqrt(mdtemp));
   } else if (index == 19) {
       double mdtemp = previousKlineModel.BOLL_SUBMD_SUM.doubleValue / 20;
       self.BOLL_MD = @(sqrt(mdtemp));
   }
    
    if (index >= 19) {
        self.BOLL_MB = @((self.SumOfLastClose.doubleValue - models[index - 19].SumOfLastClose.doubleValue) / 19);
    }
    if (index >= 19) {
        self.BOLL_UP = @(self.BOLL_MB.doubleValue + 2 * self.BOLL_MD.doubleValue);
    }
    if (index >= 19) {
        self.BOLL_DN = @(self.BOLL_MB.doubleValue - 2 * self.BOLL_MD.doubleValue);
    }

    // Volume_MA Volume_EMA
    if (index > 4) {
        self.Volume_MA5 = @((self.SumOfLastVolume.doubleValue - models[index - 5].SumOfLastVolume.doubleValue) / 5);
    } else if (index == 4) {
        self.Volume_MA5 = @((self.SumOfLastVolume.doubleValue) / 5);
    }
    
    if (index > 9) {
        self.Volume_MA10 = @((self.SumOfLastVolume.doubleValue - models[index - 10].SumOfLastVolume.doubleValue) / 10);
    } else if (index == 9) {
        self.Volume_MA10 = @((self.SumOfLastVolume.doubleValue) / 10);
    }
    
    // Volume_EMA
    if (index > 3) {
        self.Volume_EMA5 = @((self.Volume * 2 + 4 * previousKlineModel.Volume_EMA5.doubleValue)/6);
    }
    
    if (index > 8) {
        self.Volume_EMA10 = @((2 * self.Volume + 9 * previousKlineModel.Volume_EMA10.doubleValue)/11);
    }

}

- (void)getClocksMaxAndMinPriceIndex:(NSInteger)index modelsArray:(NSMutableArray<Y_KLineModel *> *)models {
    
    NSInteger startIndex = index - 13;
    if (startIndex < 0) {
        startIndex = 0;
    }
    NSMutableArray *subArray = [NSMutableArray arrayWithArray:[models subarrayWithRange:NSMakeRange(startIndex, index - startIndex + 1)]];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"High" ascending:NO];
    [subArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    Y_KLineModel *maxModel = subArray.firstObject;
    self.self.NineClocksMaxPrice = maxModel.High;
    
    NSSortDescriptor *sortLow = [NSSortDescriptor sortDescriptorWithKey:@"Low" ascending:YES];
    [subArray sortUsingDescriptors:[NSArray arrayWithObject:sortLow]];
    Y_KLineModel *minModel = subArray.firstObject;
    self.NineClocksMinPrice = minModel.Low;
}

@end
