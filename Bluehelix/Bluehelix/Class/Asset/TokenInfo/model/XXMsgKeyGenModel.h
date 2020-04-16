//
//  XXMsgKeyGenModel.h
//  Bluehelix
//
//  Created by 袁振 on 2020/04/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// MsgKeyGen 跨链地址生成
@interface XXMsgKeyGenModel : NSObject

@property (nonatomic, strong) NSString *From;
@property (nonatomic, strong) NSString *OrderId;
@property (nonatomic, strong) NSString *Symbol;
@property (nonatomic, strong) NSString *To;

@end

NS_ASSUME_NONNULL_END
