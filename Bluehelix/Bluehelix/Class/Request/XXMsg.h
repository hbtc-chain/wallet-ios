//
//  XXMsg.h
//  Bluehelix
//
//  Created by BHEX on 2020/04/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXMsg : NSObject

/// 生成交易model
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
              withdrawal_fee:(NSString *)withdrawal_fee text:(NSString *)text;


/// 生成交易model
/// @param from 转出地址
/// @param to 交易对方账户地址
/// @param amount 交易数
/// @param denom 交易币种
/// @param feeAmount 手续费最大值
/// @param feeGas 手续费 gas
/// @param feeDenom 手续费币种
/// @param memo 备注 暂无
/// @param type 交易类型
/// @param proposalType 提案类型
/// @param proposalTitle 提案标题
/// @param proposalDescription 提案描述
/// @param withdrawal_fee 跨链手续费
/// @param text
- (instancetype)initProposalMessageWithfrom:(NSString *)from
                          to:(NSString *)to
                      amount:(NSString *)amount
                       denom:(NSString *)denom
                   feeAmount:(NSString *)feeAmount
                    feeGas:(NSString *)feeGas
                  feeDenom:(NSString *)feeDenom
                        memo:(NSString *)memo
                        type:(NSString *)type
                proposalType:(NSString *)proposalType
               proposalTitle:(NSString *)proposalTitle
         proposalDescription:(NSString *)proposalDescription
                 proposalId:(NSString*)proposalId
              proposalOption:(NSString*)proposalOption
              withdrawal_fee:(NSString *)withdrawal_fee
                        text:(NSString *)text;

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
@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSString *proposalType;
@property (nonatomic, strong) NSString *proposalTitle;//提案标题
@property (nonatomic, strong) NSString *proposalDescription;//提案描述
@property (nonatomic, strong) NSString *proposalId;//提案id
@property (nonatomic, strong) NSString *proposalOption;//提案投票

@property (nonatomic, strong) NSString *decimals; //代币精度
@property (nonatomic, strong) NSMutableArray *msgs; //交易msg

- (void)buildMsgs;
@end

NS_ASSUME_NONNULL_END
