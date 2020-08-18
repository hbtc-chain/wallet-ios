//
//  Y-KLineGroupModel.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/28.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLineGroupModel.h"
#import "Y_KLineModel.h"
@implementation Y_KLineGroupModel

+ (instancetype) objectWithArray:(NSArray *)arr kLineType:(NSString *)kLineType {
    
    NSAssert([arr isKindOfClass:[NSArray class]], @"arr不是一个数组");
    
    Y_KLineGroupModel *groupModel = [Y_KLineGroupModel new];
    NSMutableArray *mutableArr = [NSMutableArray array];
    __block Y_KLineModel *preModel = [[Y_KLineModel alloc]init];
    
    //设置数据 1或2 选择一个即可
    // 数组类型的源数据
    for (NSDictionary *item in arr)
    {
        Y_KLineModel *model = [Y_KLineModel new];
        model.kLineType = kLineType;
        [model initWithDataDict:item previousKlineModel:preModel];
        [mutableArr addObject:model];
        preModel = model;
    }

    groupModel.models = mutableArr;

//    //初始化第一个Model的数据
//    Y_KLineModel *firstModel = mutableArr[0];
//    [firstModel initFirstModel];

    //初始化其他Model的数据
    [mutableArr enumerateObjectsUsingBlock:^(Y_KLineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [model initDataIndex:idx modelsArray:mutableArr];
    }];

    return groupModel;
}

- (void)addData:(NSDictionary *)dict  {
    
    Y_KLineModel *preModel = nil;
    if (self.models.count > 0) {
        preModel = self.models.lastObject;
    } else {
        self.models = [NSMutableArray array];
    }
    
    //设置数据 1或2 选择一个即可
    // 数组类型的源数据
    Y_KLineModel *model = [Y_KLineModel new];
    [model initWithDataDict:dict previousKlineModel:preModel];
    [self.models addObject:model];
    
    //初始化其他Model的数据
    [model initDataIndex:self.models.count - 1 modelsArray:self.models];
}

- (void)updateData:(NSDictionary *)dict {
    Y_KLineModel *preModel = nil;
    if (self.models.count > 1) {
        preModel = self.models[self.models.count - 2];
    } else {
        preModel = [Y_KLineModel new];
    }
    
    Y_KLineModel *model = self.models.lastObject;
    [model initWithDataDict:dict previousKlineModel:preModel];
    [model initDataIndex:self.models.count - 1 modelsArray:self.models];
}

- (void)dealloc {
    NSLog(@"行情k线数据释放");
}
@end
