//
//  XXKeyGenRequest.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXTransactionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXKeyGenRequest : NSObject

- (void)sendMsg:(XXTransactionModel *)model;

@end

NS_ASSUME_NONNULL_END
