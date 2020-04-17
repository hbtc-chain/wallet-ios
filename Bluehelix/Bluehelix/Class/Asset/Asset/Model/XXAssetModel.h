//
//  XXAssetModel.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/02.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXAssetModel : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *sequence; //交易数
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) NSString *bonded; //委托中
@property (nonatomic, strong) NSString *unbonding; //赎回中
@property (nonatomic, strong) NSString *claimed_reward; //已收益

#pragma mark 自定义属性
@property (nonatomic, strong) NSString *symbol; //币名
@property (nonatomic, strong) NSString *amount; //数量

@end

NS_ASSUME_NONNULL_END
