//
//  XXMsgAddLiquidityModel.h
//  Bluehelix
//
//  Created by 袁振 on 2020/9/27.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXMsgAddLiquidityModel : NSObject

//from：交易发起人
//
//token_a: 币种 a
//
//token_b: 币种 b
//
//min_token_a_amount: a 币种的最小数量
//
//min_token_b_amount：b 币种的最小数量
//
//expired_at：交易过期时间，-1 表示不过期

@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *token_a;
@property (nonatomic, copy) NSString *token_b;
@property (nonatomic, copy) NSString *min_token_a_amount;
@property (nonatomic, copy) NSString *min_token_b_amount;
@property (nonatomic, copy) NSString *expired_at;

@end

NS_ASSUME_NONNULL_END
