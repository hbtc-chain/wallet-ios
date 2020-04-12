//
//  XXTransactionRequest.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/01.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXTransactionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XXTransactionRequest : NSObject

- (void)sendMsg:(XXTransactionModel *)model;

@end

NS_ASSUME_NONNULL_END
