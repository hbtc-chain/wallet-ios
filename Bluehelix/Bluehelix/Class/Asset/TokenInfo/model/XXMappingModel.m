//
//  XXMappingModel.m
//  Bluehelix
//
//  Created by 袁振 on 2020/10/11.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXMappingModel.h"

@implementation XXMappingModel

- (XXMappingModel *)initWithMap:(XXMappingModel *)map {
    XXMappingModel *mapModel = [[XXMappingModel alloc] init];
    mapModel.issue_symbol = map.issue_symbol;
    mapModel.target_symbol = map.issue_symbol;
    mapModel.map_symbol = map.target_symbol;
    mapModel.issue_pool = map.issue_pool;
    mapModel.total_supply = map.total_supply;
    mapModel.enabled = map.enabled;
    mapModel.target_token = map.issue_token;
    mapModel.issue_token = map.target_token;
    return mapModel;
}

@end
