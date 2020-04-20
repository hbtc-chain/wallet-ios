//
//  XXTransactionModel.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/08.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXTransactionModel : NSObject

/// 生成转账交易model
/// @param from 转出地址
/// @param to 交易对方账户地址
/// @param amount 交易数
/// @param denom 交易币种
/// @param feeAmount 手续费最大值
/// @param feeGas 手续费 gas
/// @param feeDenom 手续费币种
/// @param memo 备注 暂无
/// @param type 交易类型
/// @param withdrawal_fee 跨链手续费
- (instancetype)initWithfrom:(NSString *)from
                          to:(NSString *)to
                      amount:(NSString *)amount
                       denom:(NSString *)denom
                   feeAmount:(NSString *)feeAmount
                      feeGas:(NSString *)feeGas
                    feeDenom:(NSString *)feeDenom
                        memo:(NSString *)memo
                        type:(NSString *)type
              withdrawal_fee:(NSString *)withdrawal_fee;

@property (nonatomic, strong) NSString *fromAddress; // 转出地址
@property (nonatomic, strong) NSString *toAddress; // 交易对方账户
@property (nonatomic, strong) NSString *amount; // 交易数
@property (nonatomic, strong) NSString *denom; // 交易币种
@property (nonatomic, strong) NSString *feeAmount; // 手续费最大值
@property (nonatomic, strong) NSString *feeGas; // 手续费 gas
@property (nonatomic, strong) NSString *feeDenom; // 手续费币种
@property (nonatomic, strong) NSString *memo; //备注 暂无
@property (nonatomic, strong) NSString *type; //交易类型
@property (nonatomic, strong) NSString *withdrawal_fee; //跨链手续费

@end

NS_ASSUME_NONNULL_END
