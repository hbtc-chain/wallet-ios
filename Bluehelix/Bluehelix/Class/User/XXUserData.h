//
//  XXUserData.h
//  Bluehelix
//
//  Created by 袁振 on 2020/03/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXUserData : NSObject

+ (XXUserData *)sharedUserData;
- (void)addAccount:(NSDictionary *)account;

@property (nonatomic, strong) NSString *localUserName;
@property (nonatomic, strong) NSString *localPassword;
@property (nonatomic, strong) NSString *localPhraseString; //临时助记词
@property (nonatomic, strong) NSString *localPrivateKey; //临时私钥
@property (nonatomic, strong) NSDictionary *rootAccount;
@property (nonatomic, strong) NSMutableArray *accounts;

@end

NS_ASSUME_NONNULL_END
