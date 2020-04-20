//
//  XXUserData.h
//  Bluehelix
//
//  Created by Bhex on 2020/03/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class XXAccountModel;
@interface XXUserData : NSObject

+ (XXUserData *)sharedUserData;
//- (void)addAccount:(NSDictionary *)account;
//- (void)replaceAccount:(NSDictionary *)dic;
//- (NSString *)increaseID; //获取主键自增ID

@property (nonatomic, strong) NSString *localUserName;
@property (nonatomic, strong) NSString *localPassword;
@property (nonatomic, strong) NSString *localPhraseString; //临时助记词
@property (nonatomic, strong) NSString *localPrivateKey; //临时私钥
//@property (nonatomic, strong) NSString *pubKey; //bech32 后pubkey 暂时没用上
//@property (nonatomic, strong) NSDictionary *rootAccount;
@property (assign, nonatomic) BOOL isNightType; //是否夜间模式
@property (assign, nonatomic) BOOL isSettedNightType; //手动设置的夜间模式
@property (assign, nonatomic) BOOL isHideSmallCoin; //是否隐藏小额币种
@property (assign, nonatomic) BOOL isHideAsset; //是否隐藏资产
@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) XXAccountModel *currentAccount; //当前用户
@property (nonatomic, strong) NSString *rootID; //当前用户id
@property (nonatomic, strong) NSString *address; //当前用户地址

@property (nonatomic, strong) NSString *ratesKey; //汇率
@end

NS_ASSUME_NONNULL_END
