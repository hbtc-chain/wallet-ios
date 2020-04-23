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
typedef void(^XXMsgSendSuccessCallBlock)(void);
typedef void(^XXMsgSendFailedCallBlock)(void);
@interface XXMsgRequest : NSObject
@property (nonatomic, copy) XXMsgSendSuccessCallBlock msgSendSuccessBlock;
@property (nonatomic, copy) XXMsgSendFailedCallBlock msgSendFaildBlock;
- (void)sendMsg:(XXMsg *)msg;

@end

NS_ASSUME_NONNULL_END
