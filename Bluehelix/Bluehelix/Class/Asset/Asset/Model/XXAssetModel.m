//
//  XXAssetModel.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/02.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAssetModel.h"
#import "XXTokenModel.h"

@implementation XXAssetModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"assets" : [XXTokenModel class]};
}
@end


