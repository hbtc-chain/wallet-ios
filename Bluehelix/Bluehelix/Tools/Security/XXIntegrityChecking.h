//
//  XXIntegrityChecking.h
//  Bhex
//
//  Created by 袁振 on 2019/11/11.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXIntegrityChecking : NSObject

/// 是否越狱
+ (void)checkJailBreak;

/// 是否有网络代理
+ (void)checkVPN;

@end

NS_ASSUME_NONNULL_END
