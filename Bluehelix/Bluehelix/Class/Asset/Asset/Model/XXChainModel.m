//
//  XXChainModel.m
//  Bluehelix
//
//  Created by 袁振 on 2020/10/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChainModel.h"

@implementation XXChainModel

- (XXChainModel *)initWithSymbol:(NSString *)symbol detailName:(NSString *)detailName typeName:(NSString *)typeName {
    self = [super init];
    if (self) {
        _symbol = symbol;
        _detailName = detailName;
        _typeName = typeName;
    }
    return self;
}

@end
