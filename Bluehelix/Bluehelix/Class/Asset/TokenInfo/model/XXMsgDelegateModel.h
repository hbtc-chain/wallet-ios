//
//  XXMsgDelegateModel.h
//  Bluehelix
//
//  Created by 袁振 on 2020/4/26.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXCoinModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XXMsgDelegateModel : NSObject

@property (nonatomic, strong) XXCoinModel *amount;
@property (nonatomic, strong) NSString *delegator_address;
@property (nonatomic, strong) NSString *validator_address;

@end

NS_ASSUME_NONNULL_END
