//
//  XXMsgSendModel.h
//  Bluehelix
//
//  Created by 袁振 on 2020/04/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXMsgSendModel : NSObject

@property (nonatomic, strong) NSArray *amount;
@property (nonatomic, strong) NSString *from_address;
@property (nonatomic, strong) NSString *to_address;

@end

NS_ASSUME_NONNULL_END
