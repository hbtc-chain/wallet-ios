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
/// @param text password
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


/// 添加流动性model
/// @param from 交易发起人
/// @param token_a 币种 a
/// @param token_b 币种 b
/// @param min_token_a_amount 币种的最小数量
/// @param min_token_b_amount 币种的最小数量
/// @param expired_at 交易过期时间，-1 表示不过期
/// @param memo 备注 暂无
/// @param type 交易类型
/// @param text password
- (instancetype)initWithfrom:(NSString *)from
         feeAmount:(NSString *)feeAmount
          feeDenom:(NSString *)feeDenom
           token_a:(NSString *)token_a
           token_b:(NSString *)token_b
min_token_a_amount:(NSString *)min_token_a_amount
min_token_b_amount:(NSString *)min_token_b_amount
        expired_at:(NSString *)expired_at
              memo:(NSString *)memo
              type:(NSString *)type
              text:(NSString *)text;

@property (nonatomic, copy) NSString *fromAddress; // 转出地址
@property (nonatomic, copy) NSString *toAddress; // 交易对方账户
@property (nonatomic, copy) NSString *amount; // 交易数
@property (nonatomic, copy) NSString *denom; // 交易币种
@property (nonatomic, copy) NSString *feeAmount; // 手续费最大值
@property (nonatomic, copy) NSString *feeGas; // 手续费 gas
@property (nonatomic, copy) NSString *feeDenom; // 手续费币种
@property (nonatomic, copy) NSString *memo; //备注 暂无
@property (nonatomic, copy) NSString *type; //交易类型
@property (nonatomic, copy) NSString *withdrawal_fee; //跨链手续费
@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *proposalType;
@property (nonatomic, copy) NSString *proposalTitle;//提案标题
@property (nonatomic, copy) NSString *proposalDescription;//提案描述
@property (nonatomic, copy) NSString *proposalId;//提案id
@property (nonatomic, copy) NSString *proposalOption;//提案投票

//增加流动性
@property (nonatomic, copy) NSString *token_a; //币种 a
@property (nonatomic, copy) NSString *token_b; //币种 b
@property (nonatomic, copy) NSString *min_token_a_amount; //币种的最小数量
@property (nonatomic, copy) NSString *min_token_b_amount; //币种的最小数量
@property (nonatomic, copy) NSString *expired_at; //交易过期时间，-1 表示不过期

@property (nonatomic, copy) NSString *decimals; //代币精度
@property (nonatomic, strong) NSMutableArray *msgs; //交易msg

- (void)buildMsgs;

/// 构造msgs 外部传入msg
- (void)buildMsgsWithMsg:(NSDictionary *)msg;

- (instancetype)initWithFeeAmount:(NSString *)feeAmount
                         feeDenom:(NSString *)feeDenom
                              msg:(id)msg
                             memo:(NSString *)memo
                             text:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
