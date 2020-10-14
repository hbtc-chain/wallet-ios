//
//  XXMappingModel.h
//  Bluehelix
//
//  Created by 袁振 on 2020/10/11.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXMappingModel : NSObject

@property (nonatomic, copy) NSString *issue_symbol; //映射对的id
@property (nonatomic, copy) NSString *target_symbol; //映射币（需要映射的，就是左边的）
@property (nonatomic, copy) NSString *total_supply;
@property (nonatomic, copy) NSString *issue_pool;
@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *map_symbol; //映射为 （映射后的，就是右边的 自己添加的字段）
@property (nonatomic, copy) NSString *chain; //所属链名
@property (nonatomic, copy) NSString *amount; //数量
@property (nonatomic, copy) NSString *logo; //图片
@property (nonatomic, assign) int decimals; //精度

- (XXMappingModel *)initWithMap:(XXMappingModel *)map;
@end

NS_ASSUME_NONNULL_END
