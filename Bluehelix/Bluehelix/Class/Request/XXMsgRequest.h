//
//  XXMsgRequest.h
//  Bluehelix
//
//  Created by 袁振 on 2020/04/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXMsg.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXMsgRequest : NSObject

- (void)sendMsg:(XXMsg *)msg;

@end

NS_ASSUME_NONNULL_END
