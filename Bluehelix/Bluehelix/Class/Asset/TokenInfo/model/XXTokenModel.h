//
//  XXTokenModel.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/03.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXTokenModel : NSObject

@property (nonatomic, strong) NSString *chain; //所属链名
@property (nonatomic, strong) NSString *symbol; //币名
@property (nonatomic, strong) NSString *amount; //数量
@property (nonatomic, strong) NSString *enable_sendtx;
@property (nonatomic, strong) NSString *external_address; //外链地址
@property (nonatomic, strong) NSString *logo; //图片
@property (nonatomic, strong) NSString *address; //链内地址
@property (nonatomic, assign) int decimals; //精度
@property (nonatomic, assign) BOOL is_native; //是否原生代币
@property (nonatomic, strong) NSString *withdrawal_fee;//跨链手续费
@property (nonatomic, assign) BOOL is_withdrawal_enabled; //是否可以提币

@end

NS_ASSUME_NONNULL_END
