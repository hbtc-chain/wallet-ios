//
//  XXWithdrawalRequest.h
//  Bluehelix
//
//  Created by 袁振 on 2020/04/14.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXTransactionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XXWithdrawalRequest : NSObject

- (void)sendMsg:(XXTransactionModel *)model;

@end
NS_ASSUME_NONNULL_END
