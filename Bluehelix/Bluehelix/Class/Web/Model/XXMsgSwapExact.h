//
//  XXMsgSwapExact.h
//  Bluehelix
//
//  Created by 袁振 on 2020/9/27.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXMsgSwapExact : NSObject
//from：交易发起人
//referer: 邀请人，默认等于 from
//receiver: 代币接受者，默认等于 from
//amount_in: 花费的币的数量
//min_amount_out：最少接收的币的数量
//swap_path：兑换路径
//expired_at：交易过期时间，-1 表示不过期
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *referer;
@property (nonatomic, copy) NSString *receiver;
@property (nonatomic, copy) NSString *amount_in;
@property (nonatomic, copy) NSString *min_amount_out;
@property (nonatomic, strong) NSArray *swap_path;
@property (nonatomic, copy) NSString *expired_at;

@end

NS_ASSUME_NONNULL_END
