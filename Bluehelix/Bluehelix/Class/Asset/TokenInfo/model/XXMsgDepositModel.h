//
//  XXMsgDepositModel.h
//  Bluehelix
//
//  Created by BHEX on 2020/04/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// MsgDeposit 跨链充值
@interface XXMsgDepositModel : NSObject

@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *from_cu;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *to_adddress;
@property (nonatomic, strong) NSString *to_cu;
@property (nonatomic, strong) NSString *txhash;

@end

NS_ASSUME_NONNULL_END
